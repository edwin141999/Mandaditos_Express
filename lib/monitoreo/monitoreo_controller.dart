import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mandaditos_express/monitoreo/utils/map_style.dart';

class monitoreo_controller extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};
  Set<Marker> get markers => _markers.values.toSet();

  final initialCameraPosition = const CameraPosition(
      target: LatLng(16.213305935125874, -95.20762635962714), zoom: 15);
  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(mapStyle);
  }

  void markerinico(LatLng position) async {
    final markerId = MarkerId(_markers.length.toString());
    //final icon= await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assets/repartior.png');

    final marker = Marker(
      markerId: markerId,
      position: position,
      // icon: icon,
    );
    _markers[markerId] = marker;
    notifyListeners();
  }

  void markerdestino(LatLng position) async {
    final markerId = MarkerId(_markers.length.toString());
    //final icon= await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assets/repartior.png');

    final marker = Marker(
      markerId: markerId,
      position: position,
      // icon: icon,
    );
    _markers[markerId] = marker;
    notifyListeners();
  }
}
