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
import 'package:mandaditos_express/repartidor/mandados_disponibles.dart';
import 'package:mandaditos_express/repartidor/ruta_mandado.dart';
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
  final PedidoElement pedidoInfo;
  final User userInfo;
  final String lat, long;
  const ConfirmarMandado({
    Key? key,
    required this.pedidoInfo,
    required this.userInfo,
    required this.lat,
    required this.long,
  }) : super(key: key);

  @override
  State<ConfirmarMandado> createState() => _ConfirmarMandadoState();
}

class _ConfirmarMandadoState extends State<ConfirmarMandado> {
  var tipoPago = '';
  Future<void> getTarjeta() async {
    var url = Uri.parse('http://54.163.243.254:83/users/getTarjeta');
    var reqBody = {};
    reqBody['id'] = int.parse(widget.pedidoInfo.metodoPago);
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reqBody),
    );
    Map<String, dynamic> respBody = jsonDecode(resp.body);
    tipoPago = respBody['tarjeta']['metodo'];
  }

  Future<void> guardarUbicacionRepartidor() async {
    var url = Uri.parse('http://54.163.243.254:81/users/actualizarUbicacion');
    var reqBody = {};
    reqBody['id'] = widget.userInfo.datatype[0].id;
    reqBody['lat'] = widget.lat;
    reqBody['long'] = widget.long;
    await http.put(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reqBody));
  }

  Future<void> aceptarPedido() async {
    var url = Uri.parse('http://54.163.243.254:81/users/vincularRepartidor');
    var reqBody = {};
    reqBody['id'] = widget.pedidoInfo.id;
    reqBody['delivery_id'] = widget.userInfo.datatype[0].id;
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
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (ctx) =>
                        MandadosDisponibles(userInfo: widget.userInfo)));
          },
        ),
      );
    } else if (resp.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => RutaMandado(
                  pedidoInfo: widget.pedidoInfo,
                  userInfo: widget.userInfo,
                  lat: widget.lat,
                  long: widget.long,
                )),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => getAlertDialog(
          'Lo sentimos',
          'Hubo un Error en el Servidor',
          () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (ctx) =>
                        MandadosDisponibles(userInfo: widget.userInfo)));
          },
        ),
      );
    }
  }

  //GOOGLE MAPS
  final _controllerMap = GoogleMapsRepartidorController();
  final Completer<GoogleMapController> _controller = Completer();
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Future<void> _disposeController() async {
    _controller.future.then((GoogleMapController controller) {
      controller.dispose();
    });
  }

  @override
  void initState() {
    _controllerMap.onTap(
      LatLng(
        double.parse(widget.pedidoInfo.cliente.latitud),
        double.parse(widget.pedidoInfo.cliente.longitud),
      ),
      'Cliente',
      double.parse('133'),
      widget.pedidoInfo.cliente.users.firstName +
          ' ' +
          widget.pedidoInfo.cliente.users.lastName,
    );
    _controllerMap.onTap(
      LatLng(
        double.parse(widget.pedidoInfo.item.latitud),
        double.parse(widget.pedidoInfo.item.longitud),
      ),
      'Pedido',
      double.parse('220'),
      widget.pedidoInfo.item.descripcion,
    );
    setState(() {
      _controllerMap.createPolylines(
        double.parse(widget.pedidoInfo.item.latitud),
        double.parse(widget.pedidoInfo.item.longitud),
        double.parse(widget.pedidoInfo.cliente.latitud),
        double.parse(widget.pedidoInfo.cliente.longitud),
      );
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
    int sumaTotal = int.parse(widget.pedidoInfo.subtotal) +
        int.parse(widget.pedidoInfo.item.precioProducto);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MandadosDisponibles(userInfo: widget.userInfo),
              ),
            );
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
                            '\nProducto: ${widget.pedidoInfo.item.tipoProducto}\n'
                            '\nDescripción: ${widget.pedidoInfo.item.descripcion}\n '
                            '\nUbicación: ${widget.pedidoInfo.cliente.direccion}\n'
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
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  // width: double.infinity ,
                  width: MediaQuery.of(context).size.width * .5,
                  height: 55,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _controllerMap.createPolylines(
                          double.parse(widget.pedidoInfo.item.latitud),
                          double.parse(widget.pedidoInfo.item.longitud),
                          double.parse(widget.pedidoInfo.cliente.latitud),
                          double.parse(widget.pedidoInfo.cliente.longitud),
                        );
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.red,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      'Mostrar ruta'.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 320,
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  child: GoogleMap(
                    markers: _controllerMap.markers,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(double.parse(widget.lat),
                            double.parse(widget.long)),
                        zoom: 15),
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
