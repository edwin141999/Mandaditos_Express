import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:mandaditos_express/models/pedidoinfo.dart';
import 'package:http/http.dart' as http;
import 'package:mandaditos_express/models/userinfo.dart';
import 'package:mandaditos_express/styles/colors/colors_view.dart';

class MandadosDisponibles extends StatefulWidget {
  const MandadosDisponibles({Key? key}) : super(key: key);

  @override
  State<MandadosDisponibles> createState() => _MandadosDisponiblesState();
}

class _MandadosDisponiblesState extends State<MandadosDisponibles> {
  Future<Pedido> getMandados() async {
    var url = Uri.parse('http://34.193.105.11/users/mostrarMandados');
    final resp =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    return pedidoFromJson(resp.body);
  }

  //UBICACION ACTUAL
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
    latitud = position.latitude.toString();
    longitud = position.longitude.toString();
    setState(() {
      latitud = position.latitude.toString();
      longitud = position.longitude.toString();
    });
  }

  void inicializarUbicacion() async {
    Position position = await _getGeoLocationPosition();
    latitud = position.latitude.toString();
    longitud = position.longitude.toString();
  }

  @override
  void initState() {
    inicializarUbicacion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final userInfo = arguments['user'] as User;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pushReplacementNamed(
              context,
              '/repartidor/dashboard',
              arguments: {'user': userInfo},
            );
          },
          child: Image.asset('assets/images/icon_back_arrow.png', scale: .8),
        ),
        title: const Text(
          'Mandados Disponibles',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getMandados(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _ListaPedidos(
                snapshot.data.pedidos, userInfo, latitud, longitud);
          }
        },
      ),
    );
  }
}

class _ListaPedidos extends StatelessWidget {
  final List<PedidoElement> pe;
  final User userInfo;
  final String lat, long;
  const _ListaPedidos(this.pe, this.userInfo, this.lat, this.long);

  @override
  Widget build(BuildContext context) {
    if (pe.isNotEmpty) {
      return ListView.builder(
        itemCount: pe.length,
        itemBuilder: (BuildContext context, int i) {
          return Card(
            elevation: 1,
            margin: const EdgeInsets.all(15),
            color: ColorSelect.cardP,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 10, left: 20),
                  child: Image.asset('assets/images/notificacion.png'),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  width: MediaQuery.of(context).size.width * .4,
                  child: Text(
                    (int.parse(pe[i]
                                .horaSolicitada
                                .toString()
                                .substring(11, 13)) <
                            12)
                        ? '\n${pe[i].cliente.users.firstName} ${pe[i].cliente.users.lastName}\n'
                            '\n${pe[i].item.tipoProducto}\n'
                            '\n${pe[i].horaSolicitada.toString().substring(11, 16)} AM\n'
                            '\n${pe[i].horaSolicitada.toString().substring(0, 11)}\n'
                            '\nTotal: \$ ${pe[i].subtotal}\n'
                        : '\n${pe[i].cliente.users.firstName} ${pe[i].cliente.users.lastName}\n'
                            '\n${pe[i].item.tipoProducto}\n'
                            '\n${pe[i].horaSolicitada.toString().substring(11, 16)} PM\n'
                            '\n${pe[i].horaSolicitada.toString().substring(0, 11)}\n'
                            '\nTotal: \$ ${pe[i].subtotal}\n',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 80),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/repartidor/confirmarMandado',
                        arguments: {
                          'pedido': pe[i],
                          'user': userInfo,
                          'lat': lat,
                          'long': long,
                        },
                      );
                    },
                    color: Colors.lightBlue,
                    child: const Text('Ver Detalles',
                        style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
          );
        },
      );
    } else {
      return Center(
        child: Card(
          elevation: 1,
          margin: const EdgeInsets.all(15),
          color: ColorSelect.cardP,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: SizedBox(
            width: 200,
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('assets/images/mandado_vacio.png'),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .6,
                  child: const Center(
                    child: Text(
                      'No hay mandados disponibles por el momento',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
