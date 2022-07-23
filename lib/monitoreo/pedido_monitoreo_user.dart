import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:mandaditos_express/historial/usuario_historial.dart';
import 'package:mandaditos_express/models/pedidoclienteinfo.dart';
import 'package:mandaditos_express/models/userinfo.dart';

import 'package:mandaditos_express/monitoreo/monitoreo_controller.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class PedidoMonitoreo extends StatefulWidget {
  final User userInfo;
  final Pedido pedidoInfo;
  const PedidoMonitoreo({
    Key? key,
    required this.userInfo,
    required this.pedidoInfo,
  }) : super(key: key);

  @override
  State<PedidoMonitoreo> createState() => _PedidoMonitoreostate();
}

class _PedidoMonitoreostate extends State<PedidoMonitoreo> {
  final _controller = MonitoreoController();
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  String googleAPiKey = "AIzaSyBy76EU-NQpNx2NAXxHZH2E-3lj3VNwhW4";

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _getPolyline() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      const PointLatLng(16.213305935125874, -95.20762635962714),
      const PointLatLng(16.21240872256714, -95.20714242769476),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  _callNumber() async {
    const number = '+52  994 263 9815'; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
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
              // polylines: Set<Polyline>.of(polylines.values),
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
