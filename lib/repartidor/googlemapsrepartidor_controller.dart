import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class GoogleMapsRepartidorController extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};
  Set<Marker> get markers => _markers.values.toSet();

  // RUTA TRAZADA
  late PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];

  final Map<PolylineId, Polyline> _polylines = {};
  Set<Polyline> get polylinesSet => _polylines.values.toSet();

  void createPolylines(double startLatitude, double startLongitude,
      double destinationLatitude, double destinationLongitude) async {
    polylinePoints = PolylinePoints();
    log('startLatitude: $startLatitude');
    log('startLongitude: $startLongitude');
    log('destinationLatitude: $destinationLatitude');
    log('destinationLongitude: $destinationLongitude');
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyBy76EU-NQpNx2NAXxHZH2E-3lj3VNwhW4', // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.driving,
    );
    log(result.status.toString());
    log(result.points.toString());
    polylineCoordinates.clear();
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    log('*' * 20);
    log(polylineCoordinates.toString());
    PolylineId id = const PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    // Adding the polyline to the map
    _polylines[id] = polyline;
    // Set<Polyline>.of(_polylines.values);
    // log(polyline.points.toString());
    notifyListeners();
  }

  // MARKERS
  final initialCameraPosition = const CameraPosition(
    target: LatLng(16.7432391, -93.1025722),
    zoom: 15,
  );

  void onTap(position) {
    // log(position.toString());
    // _markers.clear();
    final markerdId = MarkerId(_markers.length.toString());
    final marker = Marker(
      markerId: markerdId,
      position: position,
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
