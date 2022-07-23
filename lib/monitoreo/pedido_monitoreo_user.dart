import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mandaditos_express/layouts/line.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:mandaditos_express/monitoreo/monitoreo_controller.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class pedido_monitoreo_user extends StatefulWidget {
  const pedido_monitoreo_user({key, required this.title});
  final String title;

  @override
  State<pedido_monitoreo_user> createState() => _pedido_monitoreo_userstate();
}

class _pedido_monitoreo_userstate extends State<pedido_monitoreo_user> {
  final _controller = monitoreo_controller();
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  String googleAPiKey = "AIzaSyBy76EU-NQpNx2NAXxHZH2E-3lj3VNwhW4";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
    var inicio = const LatLng(16.213305935125874, -95.20762635962714);
    var destino = const LatLng(16.21240872256714, -95.20714242769476);
    _controller.markerinico(inicio);
    _controller.markerdestino(destino);
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
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Container(
              margin: const EdgeInsets.only(top: 40),
              child: Row(children: <Widget>[
                Center(
                  child: Container(
                    height: 50,
                    width: 20,
                    margin: const EdgeInsets.only(left: 10),
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
                Container(
                  height: 70,
                  width: 70,
                  margin: const EdgeInsets.only(left: 10),
                  child: Image.asset("assets/images/Logo.png"),
                ),
              ]),
            )),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
                width: width,
                height: height * .6,
                child: GoogleMap(
                  onMapCreated: _controller.onMapCreated,
                  initialCameraPosition: _controller.initialCameraPosition,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  markers: _controller.markers,
                  polylines: Set<Polyline>.of(polylines.values),
                )),
            Row(
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(top: 30, left: 150),
                    child: ElevatedButton(
                      onPressed: _callNumber,
                      child: const Text("Llamar"),
                    )),
              ],
            )
          ],
        ));
  }
}
