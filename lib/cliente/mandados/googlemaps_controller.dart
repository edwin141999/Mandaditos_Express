import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsController extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};
  Set<Marker> get markers => _markers.values.toSet();

  final initialCameraPosition = const CameraPosition(
    target: LatLng(16.7432391, -93.1025722),
    zoom: 15,
  );

  void onTap(position) {
    // log(position.toString());
    _markers.clear();
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
