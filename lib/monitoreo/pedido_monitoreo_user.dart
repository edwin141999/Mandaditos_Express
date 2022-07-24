//SERVER
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:mandaditos_express/historial/usuario_historial.dart';
import 'package:mandaditos_express/models/pedidoclienteinfo.dart';
import 'package:mandaditos_express/models/repartidorinfo.dart';
import 'package:mandaditos_express/models/userinfo.dart';

import 'package:mandaditos_express/monitoreo/monitoreo_controller.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class PedidoMonitoreo extends StatefulWidget {
  final User userInfo;
  final Pedido pedidoInfo;
  final RepartidorInfo repartidor;
  const PedidoMonitoreo({
    Key? key,
    required this.userInfo,
    required this.pedidoInfo,
    required this.repartidor,
  }) : super(key: key);

  @override
  State<PedidoMonitoreo> createState() => _PedidoMonitoreostate();
}

RepartidorInfo? repartidorInfo;

Future<RepartidorInfo> datosRepartidor(int idRepartidor) async {
  var url = Uri.parse('http://54.163.243.254:81/users/getRepartidor');
  var reqBody = {};
  reqBody['id'] = idRepartidor;
  var response = await http.post(url,
      headers: {'Content-Type': 'application/json'}, body: jsonEncode(reqBody));
  log(response.body);
  repartidorInfo = RepartidorInfo.fromJson(json.decode(response.body));
  return repartidorInfo!;
}

class _PedidoMonitoreostate extends State<PedidoMonitoreo> {
  final _controller = MonitoreoController();
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  late Timer timerDatos;
  late Timer timerGPS;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
    _controller.onTap(
      LatLng(double.parse(widget.userInfo.datatype[0].latitud),
          double.parse(widget.userInfo.datatype[0].longitud)),
      'Tu ubicación',
      double.parse('133'),
      widget.userInfo.user.firstName + ' ' + widget.userInfo.user.lastName,
    );
    _controller.onTap(
      LatLng(double.parse(widget.pedidoInfo.item.latitud),
          double.parse(widget.pedidoInfo.item.longitud)),
      'Tu ${widget.pedidoInfo.item.tipoProducto}',
      double.parse('220'),
      widget.pedidoInfo.item.descripcion,
    );
    _controller.ubicacionRepartidor(
      LatLng(
        double.parse(widget.repartidor.repartidor.latitud),
        double.parse(widget.repartidor.repartidor.longitud),
      ),
      'Repartidor',
      '',
    );
    setState(() {
      timerDatos = Timer.periodic(const Duration(seconds: 2), (Timer t2) async {
        datosRepartidor(widget.repartidor.repartidor.id);
      });
      timerGPS = Timer.periodic(const Duration(seconds: 4), (Timer t) {
        _controller.ubicacionRepartidor(
          LatLng(
            double.parse(repartidorInfo!.repartidor.latitud),
            double.parse(repartidorInfo!.repartidor.longitud),
          ),
          'Repartidor',
          '',
        );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    timerDatos.cancel();
    timerGPS.cancel();
    super.dispose();
  }

  _callNumber() async {
    const number = '+52  994 263 9815'; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        leading: TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    UsuarioHitorial(userInfo: widget.userInfo),
              ),
            );
          },
          child: Image.asset('assets/images/icon_back_arrow.png', scale: .8),
        ),
        actions: [
          Container(
            width: MediaQuery.of(context).size.width * .8,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset('assets/images/Logo.png', scale: .8),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .6,
            child: GoogleMap(
              onMapCreated: _controller.onMapCreated,
              initialCameraPosition: _controller.ubicacionCliente(
                double.parse(widget.userInfo.datatype[0].latitud),
                double.parse(widget.userInfo.datatype[0].longitud),
              ),
              markers: _controller.markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30, left: 150),
                child: ElevatedButton(
                  onPressed: _callNumber,
                  child: const Text("Llamar"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
