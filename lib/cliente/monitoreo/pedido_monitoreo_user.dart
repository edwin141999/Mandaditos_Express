//SERVER
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:mandaditos_express/models/pedidoclienteinfo.dart';
import 'package:mandaditos_express/models/repartidorinfo.dart';
import 'package:mandaditos_express/models/userinfo.dart';

import 'package:mandaditos_express/cliente/monitoreo/monitoreo_controller.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class PedidoMonitoreo extends StatefulWidget {
  // final User userInfo;
  // final Pedido pedidoInfo;
  // final RepartidorInfo repartidor;
  // const PedidoMonitoreo({
  //   Key? key,
  //   required this.userInfo,
  //   required this.pedidoInfo,
  //   required this.repartidor,
  // }) : super(key: key);
  const PedidoMonitoreo({Key? key}) : super(key: key);

  @override
  State<PedidoMonitoreo> createState() => _PedidoMonitoreostate();
}

RepartidorInfo? repartidorInfo;

Future<RepartidorInfo> datosRepartidor(int idRepartidor) async {
  var url = Uri.parse('http://34.193.105.11/users/getRepartidor');
  var reqBody = {};
  reqBody['id'] = idRepartidor;
  var response = await http.post(url,
      headers: {'Content-Type': 'application/json'}, body: jsonEncode(reqBody));
  repartidorInfo = RepartidorInfo.fromJson(json.decode(response.body));
  return repartidorInfo!;
}

class _PedidoMonitoreostate extends State<PedidoMonitoreo> {
  final _controller = MonitoreoController();
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  late Timer timerDatos;
  late Timer timerGPS;

  void puntosIniciales() {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final userInfo = arguments['user'] as User;
    final pedidoInfo = arguments['pedido'] as Pedido;
    final repartidor = arguments['repartidor'] as RepartidorInfo;
    _controller.onTap(
      LatLng(double.parse(userInfo.datatype[0].latitud),
          double.parse(userInfo.datatype[0].longitud)),
      'Tu ubicación',
      double.parse('133'),
      userInfo.user.firstName + ' ' + userInfo.user.lastName,
    );
    _controller.onTap(
      LatLng(double.parse(pedidoInfo.item.latitud),
          double.parse(pedidoInfo.item.longitud)),
      'Tu ${pedidoInfo.item.tipoProducto}',
      double.parse('220'),
      pedidoInfo.item.descripcion,
    );
    _controller.ubicacionRepartidor(
      LatLng(
        double.parse(repartidor.repartidor.latitud),
        double.parse(repartidor.repartidor.longitud),
      ),
      'Repartidor',
      '',
    );
  }

  void repartidorInformacion() {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final repartidor = arguments['repartidor'] as RepartidorInfo;
    datosRepartidor(repartidor.repartidor.id);
  }

  @override
  void didChangeDependencies() {
    puntosIniciales();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
    setState(() {
      timerDatos = Timer.periodic(const Duration(seconds: 2), (Timer t2) async {
        repartidorInformacion();
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
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final userInfo = arguments['user'] as User;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        leading: TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              '/cliente/historialUsuario',
              arguments: {
                'user': userInfo,
              },
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
          Container(
            margin: const EdgeInsets.only(top: 3),
            child: const Divider(color: Colors.black, height: 1, thickness: 2),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .84,
            child: GoogleMap(
              onMapCreated: _controller.onMapCreated,
              initialCameraPosition: _controller.ubicacionCliente(
                double.parse(userInfo.datatype[0].latitud),
                double.parse(userInfo.datatype[0].longitud),
              ),
              markers: _controller.markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
          ),
          // Row(
          //   children: [
          //     Container(
          //       margin: const EdgeInsets.only(top: 30, left: 150),
          //       child: ElevatedButton(
          //         onPressed: _callNumber,
          //         child: const Text("Llamar"),
          //       ),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
