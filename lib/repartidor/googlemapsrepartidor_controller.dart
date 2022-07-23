import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class GoogleMapsRepartidorController extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};
  Set<Marker> get markers => _markers.values.toSet();

  // RUTA TRAZADA
  late PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];

  final Map<PolylineId, Polyline> _polylines = {};
  Set<Polyline> get polylines => _polylines.values.toSet();

  createPolylines(double startLatitude, double startLongitude,
      double destinationLatitude, double destinationLongitude) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyBy76EU-NQpNx2NAXxHZH2E-3lj3VNwhW4', // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.driving,
    );
    log(result.errorMessage.toString());
    polylineCoordinates.clear();
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    PolylineId polylineId = const PolylineId('poly');
    final polyline = Polyline(
      polylineId: polylineId,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    // Adding the polyline to the map
    _polylines[polylineId] = polyline;
    Set<Polyline>.of(_polylines.values);
    log(polylines.length.toString());
    notifyListeners();
  }

  // final initialCameraPosition = const CameraPosition(
  //   target: LatLng(16.7432391, -93.1025722),
  //   zoom: 15,
  // );
  CameraPosition ubicacionRepartidor(lat, long) {
    return CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
    );
  }

  void onTap(position, name, color, description) {
    final markerdId = MarkerId(_markers.length.toString());
    final marker = Marker(
      markerId: markerdId,
      position: position,
      infoWindow: InfoWindow(title: '$name', snippet: '$description'),
      icon: BitmapDescriptor.defaultMarkerWithHue(color),
    );
    _markers[markerdId] = marker;
    notifyListeners();
  }

  @override
  void dispose() {
    _markers.clear();
    super.dispose();
  }
}
