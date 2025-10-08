import 'package:battery_plus/battery_plus.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // Obtiene la ubicación actual con precisión ajustada al nivel de batería
  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    if (permission == LocationPermission.deniedForever) return null;

    // Verifica el nivel de batería
    final battery = Battery();
    final batteryLevel = await battery.batteryLevel;

    // Ajusta la precisión según el nivel de batería
    LocationAccuracy accuracy;
    switch (batteryLevel) {
      case > 50:
        accuracy = LocationAccuracy.best;
        break;
      case > 30:
        accuracy = LocationAccuracy.high;
        break;
      case > 20:
        accuracy = LocationAccuracy.medium;
        break;
      default:
        accuracy = LocationAccuracy.low;
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: 10,
        timeLimit: const Duration(seconds: 10),
      ),
    );
  }

  //  Stream que escucha actualizaciones de ubicación en tiempo real
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // actualiza al moverse al menos 5 metros
      ),
    );
  }
}
