import 'package:geolocator/geolocator.dart';

Future<Position> _getGeoLocationPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    return Future.error('Location service are disabled');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permission are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions');
  }

  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}

void inicializarUbicacion() async {
  await _getGeoLocationPosition();
}
