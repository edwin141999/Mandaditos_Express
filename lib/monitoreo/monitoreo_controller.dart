import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mandaditos_express/monitoreo/utils/map_style.dart';

class MonitoreoController extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};
  Set<Marker> get markers => _markers.values.toSet();

  CameraPosition ubicacionCliente(lat, long) {
    return CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
    );
  }

  // final initialCameraPosition = const CameraPosition(
  //     target: LatLng(16.213305935125874, -95.20762635962714), zoom: 15);
  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(mapStyle);
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
