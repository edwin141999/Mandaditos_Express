import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:mandaditos_express/models/pedidoinfo.dart';
import 'package:http/http.dart' as http;
import 'package:mandaditos_express/models/userinfo.dart';
import 'package:mandaditos_express/repartidor/googlemapsrepartidor_controller.dart';
import 'package:mandaditos_express/styles/colors/colors_view.dart';

AlertDialog getAlertDialog(title, content, onPressed) {
  return AlertDialog(
    title: Center(child: Text(title)),
    content: Text(content),
    actions: [
      Center(
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: ColorSelect.kPrimaryColor,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
          child: const Text(
            'Regresar a los mandados disponibles',
            style: TextStyle(
                color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    ],
  );
}

class ConfirmarMandado extends StatefulWidget {
  const ConfirmarMandado({Key? key}) : super(key: key);

  @override
  State<ConfirmarMandado> createState() => _ConfirmarMandadoState();
}

class _ConfirmarMandadoState extends State<ConfirmarMandado> {
  var tipoPago = '';
  Future<void> getTarjeta() async {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final pedidoInfo = arguments['pedido'] as PedidoElement;
    var url = Uri.parse('http://3.95.107.222/users/getTarjeta');
    // var url = Uri.parse(
    //     'http://balanceadorpagos-1548156697.us-east-1.elb.amazonaws.com/users/getTarjeta');
    var reqBody = {};
    reqBody['id'] = int.parse(pedidoInfo.metodoPago);
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reqBody),
    );
    Map<String, dynamic> respBody = jsonDecode(resp.body);
    tipoPago = respBody['tarjeta']['metodo'];
  }

  Future<void> guardarUbicacionRepartidor() async {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final userInfo = arguments['user'] as User;
    final lat = arguments['lat'];
    final long = arguments['long'];
    var url = Uri.parse('http://34.193.105.11/users/actualizarUbicacion');
    var reqBody = {};
    reqBody['id'] = userInfo.datatype[0].id;
    reqBody['lat'] = lat;
    reqBody['long'] = long;
    await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reqBody),
    );
  }

  Future<void> aceptarPedido() async {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final pedidoInfo = arguments['pedido'] as PedidoElement;
    final userInfo = arguments['user'] as User;
    final lat = arguments['lat'];
    final long = arguments['long'];
    var url = Uri.parse('http://34.193.105.11/users/vincularRepartidor');
    var reqBody = {};
    reqBody['id'] = pedidoInfo.id;
    reqBody['delivery_id'] = userInfo.datatype[0].id;
    final resp = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reqBody),
    );
    Map<String, dynamic> responseMap = json.decode(resp.body);
    if (resp.statusCode == 400) {
      showDialog(
        context: context,
        builder: (ctx) => getAlertDialog(
          'Lo sentimos',
          responseMap['message'],
          () {
            Navigator.pushReplacementNamed(
              context,
              '/repartidor/mandadosDisponibles',
              arguments: {'user': userInfo},
            );
          },
        ),
      );
    } else if (resp.statusCode == 200) {
      Navigator.pushReplacementNamed(
        context,
        '/repartidor/rutaMandado',
        arguments: {
          'pedido': pedidoInfo,
          'user': userInfo,
          'lat': lat,
          'long': long,
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => getAlertDialog(
          'Lo sentimos',
          'Hubo un Error en el Servidor',
          () {
            Navigator.pushReplacementNamed(
              context,
              '/repartidor/mandadosDisponibles',
              arguments: {'user': userInfo},
            );
          },
        ),
      );
    }
  }

  //GOOGLE MAPS
  final _controllerMap = GoogleMapsRepartidorController();
  final Completer<GoogleMapController> _controller = Completer();
  void _onMapCreated(GoogleMapController controller) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final lat = arguments['lat'];
    final long = arguments['long'];
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            double.parse(lat),
            double.parse(long),
          ),
          zoom: 14,
        ),
      ),
    );
    _controller.complete(controller);
  }

  Future<void> _disposeController() async {
    _controller.future.then((GoogleMapController controller) {
      controller.dispose();
    });
  }

  void ponerPuntos() {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final pedidoInfo = arguments['pedido'] as PedidoElement;
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
    ponerPuntos();
    super.didChangeDependencies();
  }

  @override
  void initState() {
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
    double sumaTotal = double.parse(pedidoInfo.subtotal) +
        double.parse(pedidoInfo.item.precioProducto);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pushReplacementNamed(
                context, '/repartidor/mandadosDisponibles',
                arguments: {'user': userInfo});
          },
          child: Image.asset('assets/images/icon_back_arrow.png', scale: .8),
        ),
        title: const Text(
          'Descripcion del Mandado',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 400,
                    padding: const EdgeInsets.only(left: 30),
                    decoration: BoxDecoration(
                      color: ColorSelect.cardP,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: FutureBuilder(
                      future: getTarjeta(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            height: 209,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          return Text(
                            '\nProducto: ${pedidoInfo.item.tipoProducto}\n'
                            '\nDescripción: ${pedidoInfo.item.descripcion}\n '
                            '\nUbicación: ${pedidoInfo.cliente.direccion}\n'
                            '\nMetodo de Pago: $tipoPago\n'
                            '\nTotal: \$ $sumaTotal\n',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                // Container(
                //   padding: const EdgeInsets.only(top: 10),
                //   // width: double.infinity ,
                //   width: MediaQuery.of(context).size.width * .5,
                //   height: 55,
                //   child: OutlinedButton(
                //     onPressed: () {
                //       setState(() {
                //         _controllerMap.createPolylines(
                //           double.parse(widget.pedidoInfo.item.latitud),
                //           double.parse(widget.pedidoInfo.item.longitud),
                //           double.parse(widget.pedidoInfo.cliente.latitud),
                //           double.parse(widget.pedidoInfo.cliente.longitud),
                //         );
                //       });
                //     },
                //     style: OutlinedButton.styleFrom(
                //       backgroundColor: Colors.red,
                //       elevation: 0,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(50),
                //       ),
                //     ),
                //     child: Text(
                //       'Mostrar ruta'.toUpperCase(),
                //       style: const TextStyle(
                //         color: Colors.white,
                //         fontSize: 18,
                //         fontWeight: FontWeight.w400,
                //       ),
                //     ),
                //   ),
                // ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 320,
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  child: GoogleMap(
                    markers: _controllerMap.markers,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(0, 0),
                      zoom: 15,
                    ),
                    myLocationButtonEnabled: false,
                    polylines: _controllerMap.polylines,
                    myLocationEnabled: true,
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                      Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer())
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    onPressed: () {
                      guardarUbicacionRepartidor();
                      aceptarPedido();
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: ColorSelect.kPrimaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      'Tomar orden',
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
