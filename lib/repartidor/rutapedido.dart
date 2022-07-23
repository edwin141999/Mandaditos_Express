import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mandaditos_express/models/pedidoinfo.dart';
import 'package:mandaditos_express/models/userinfo.dart';
import 'package:mandaditos_express/repartidor/googlemapsrepartidor_controller.dart';
import 'package:mandaditos_express/repartidor/menu.dart';
import 'package:mandaditos_express/styles/colors/colors_view.dart';

class RutaPedido extends StatefulWidget {
  final PedidoElement pedidoInfo;
  final User userInfo;
  const RutaPedido({Key? key, required this.pedidoInfo, required this.userInfo})
      : super(key: key);

  @override
  State<RutaPedido> createState() => _RutaPedidoState();
}

class _RutaPedidoState extends State<RutaPedido> {
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

  Future<void> entregarPedido() async {
    var url = Uri.parse('http://54.163.243.254:81/users/entrega');
    var reqBody = {};
    reqBody['id'] = widget.pedidoInfo.id;
    final resp = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reqBody),
    );
    log(resp.body);
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
                    // initialCameraPosition: _controllerMap.initialCameraPosition,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        double.parse(widget.pedidoInfo.item.latitud),
                        double.parse(widget.pedidoInfo.item.longitud),
                      ),
                      zoom: 13,
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
                                    'Acabas de entregar el pedido al cliente ${widget.pedidoInfo.cliente.users.firstName} ${widget.pedidoInfo.cliente.users.lastName}.'),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            menuM(userInfo: widget.userInfo),
                                      ),
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
