import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mandaditos_express/monitoreo/utils/asset_to_bytes.dart';
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

  void ubicacionRepartidor(position, name, description) async {
    if (_markers.length > 2) {
      _markers.remove(_markers.keys.last);
    }
    final markerdId = MarkerId(_markers.length.toString());
    final icon = BitmapDescriptor.fromBytes(await assetToBytes('assets/images/repartidor.png'));
    final marker = Marker(
      markerId: markerdId,
      position: position,
      infoWindow: InfoWindow(title: '$name', snippet: '$description'),
      icon: icon,
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
