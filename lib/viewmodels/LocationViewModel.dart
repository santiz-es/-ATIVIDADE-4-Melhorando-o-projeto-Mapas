import 'package:flutter/material.dart';
import 'package:flutter_mapas_osm/models/LocationModel.dart';
import 'package:flutter_mapas_osm/services/LocationService.dart';
import 'package:geolocator/geolocator.dart';

class LocationViewModel extends ChangeNotifier {
  final LocationService _locationService = LocationService();

  LocationModel? _location;
  bool _isLoading = true;

  LocationModel? get location => _location;
  bool get isLoading => _isLoading;

  // Obtiene la ubicación actual
  Future<void> fetchLocation() async {
    _isLoading = true;
    notifyListeners();

    Position? position = await _locationService.getCurrentPosition();

    if (position != null) {
      _location = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  void startLocationUpdates() {
    _locationService.getPositionStream().listen((position) {
      _location = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      notifyListeners();
    });
  }
}
