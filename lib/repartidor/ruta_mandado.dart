import 'dart:async';
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mandaditos_express/models/pedidoinfo.dart';
import 'package:mandaditos_express/models/userinfo.dart';
import 'package:mandaditos_express/repartidor/googlemapsrepartidor_controller.dart';
import 'package:mandaditos_express/styles/colors/colors_view.dart';

class RutaMandado extends StatefulWidget {
  const RutaMandado({Key? key}) : super(key: key);

  @override
  State<RutaMandado> createState() => _RutaMandadoState();
}

class _RutaMandadoState extends State<RutaMandado> {
  final _controllerMap = GoogleMapsRepartidorController();
  final Completer<GoogleMapController> _controller = Completer();
  late Timer timer;
  void _onMapCreated(GoogleMapController controller) {
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              double.parse(latitud),
              double.parse(longitud),
            ),
            zoom: 17,
          ),
        ),
      );
    });
    _controller.complete(controller);
  }

  Future<void> _disposeController() async {
    _controller.future.then((GoogleMapController controller) {
      timer.cancel();
      controller.dispose();
    });
  }

  Future<void> entregarPedido() async {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final pedidoInfo = arguments['pedido'] as PedidoElement;
    var url = Uri.parse('http://34.193.105.11/users/entrega');
    var reqBody = {};
    reqBody['id'] = pedidoInfo.id;
    await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reqBody),
    );
  }

  Future<void> actualizarUbicacionRepartidor() async {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final userInfo = arguments['user'] as User;
    var url = Uri.parse('http://34.193.105.11/users/actualizarUbicacion');
    var reqBody = {};
    reqBody['id'] = userInfo.datatype[0].id;
    reqBody['lat'] = latitud;
    reqBody['long'] = longitud;
    await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reqBody),
    );
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location service are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  String address = 'search';
  String location = 'Null';
  String latitud = '0';
  String longitud = '0';

  Future<void> getAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    location = 'Lat: ${position.latitude} - Long: ${position.longitude}';
  }

  void inicializarUbicacion() async {
    Position position = await _getGeoLocationPosition();
    latitud = position.latitude.toString();
    longitud = position.longitude.toString();
  }

  late Timer timerRepartidor;

  void mostrarPuntos() {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final pedidoInfo = arguments['pedido'] as PedidoElement;
    //CLIENTE
    _controllerMap.onTap(
      LatLng(
        double.parse(pedidoInfo.cliente.latitud),
        double.parse(pedidoInfo.cliente.longitud),
      ),
      'Cliente',
      double.parse('133'),
      pedidoInfo.cliente.users.firstName +
          ' ' +
          pedidoInfo.cliente.users.lastName,
    );
    //PEDIDO
    _controllerMap.onTap(
      LatLng(
        double.parse(pedidoInfo.item.latitud),
        double.parse(pedidoInfo.item.longitud),
      ),
      'Pedido',
      double.parse('220'),
      pedidoInfo.item.descripcion,
    );
  }

  @override
  void didChangeDependencies() {
    mostrarPuntos();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // FUNCION PARA ACTUALIZAR LA UBICACION DEL REPARTIDOR
    timerRepartidor =
        Timer.periodic(const Duration(seconds: 2), (Timer t2) async {
      inicializarUbicacion();
      actualizarUbicacionRepartidor();
    });
    super.initState();
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final pedidoInfo = arguments['pedido'] as PedidoElement;
    final userInfo = arguments['user'] as User;
    final lat = arguments['lat'];
    final long = arguments['long'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Pedido en transcurso',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .7,
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  child: GoogleMap(
                    markers: _controllerMap.markers,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: _controllerMap.ubicacionRepartidor(
                      double.parse(lat),
                      double.parse(long),
                    ),
                    myLocationButtonEnabled: false,
                    polylines: _controllerMap.polylines,
                    myLocationEnabled: true,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      entregarPedido();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          insetPadding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 125),
                          content: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Pedido entregado',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    'Acabas de entregar el pedido a ${pedidoInfo.cliente.users.firstName} ${pedidoInfo.cliente.users.lastName}.'),
                                OutlinedButton(
                                  onPressed: () {
                                    _disposeController();
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/repartidor/dashboard',
                                      arguments: {'user': userInfo},
                                    );
                                  },
                                  child: const Text(
                                    'Regresar al Menu',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width, 40),
                                    backgroundColor: ColorSelect.kPrimaryColor,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: ColorSelect.kPrimaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      'Confirmar Entrega',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
