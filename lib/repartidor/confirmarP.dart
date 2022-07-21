import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:mandaditos_express/models/pedidoinfo.dart';
import 'package:http/http.dart' as http;
import 'package:mandaditos_express/repartidor/googlemapsrepartidor_controller.dart';
import 'package:mandaditos_express/styles/colors/colors_view.dart';

class confirmarP extends StatefulWidget {
  final PedidoElement pedidoInfo;
  const confirmarP({Key? key, required this.pedidoInfo}) : super(key: key);

  @override
  State<confirmarP> createState() => _confirmarPState();
}

class _confirmarPState extends State<confirmarP> {
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
    );
    _controllerMap.onTap(
      LatLng(
        double.parse(widget.pedidoInfo.item.latitud),
        double.parse(widget.pedidoInfo.item.longitud),
      ),
    );
    _controllerMap.createPolylines(
      double.parse(widget.pedidoInfo.cliente.latitud),
      double.parse(widget.pedidoInfo.cliente.longitud),
      double.parse(widget.pedidoInfo.item.latitud),
      double.parse(widget.pedidoInfo.item.longitud),
    );
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
            Navigator.pop(context);
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
            padding: const EdgeInsets.symmetric(horizontal: 25),
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
                  width: MediaQuery.of(context).size.width,
                  height: 320,
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  child: GoogleMap(
                    markers: _controllerMap.markers,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: _controllerMap.initialCameraPosition,
                    myLocationButtonEnabled: false,
                    polylines: _controllerMap.polylinesSet,
                    // onTap: _controllerMap.onTap,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    onPressed: () {},
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
