import 'package:geolocator/geolocator.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;

  LocationService._internal();

  double? latitude;
  double? longitude;

  Future<void> updateLocation() async {
    LocationPermission permission = await _checkLocationPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    try {
      Position position =
          await _getCachedLocation() ?? await _getCurrentLocation();
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      throw Exception('Error fetching location: $e');
    }
  }

  Future<LocationPermission> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission;
  }

  Future<Position?> _getCachedLocation() async {
    try {
      Position position = await Geolocator.getLastKnownPosition() ??
          await _getCurrentLocation();
      return position;
    } catch (e) {
      return null;
    }
  }

  Future<Position> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
