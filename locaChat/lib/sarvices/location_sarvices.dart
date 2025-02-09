import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class LocationService {
  Location location = Location();
  LocationData? _currentLocation;
  double? latitude = 0.0;
  double? longitude = 0.0;

  Future<LocationData?> updateLocation() async {
    LocationPermission permission = await _checkLocationPermission();

    if (permission == LocationPermission.denied) {
      throw ('Location permissions are denied');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    try {
      _currentLocation = await location.getLocation();
      latitude = _currentLocation!.latitude;
      longitude = _currentLocation!.longitude;
      return _currentLocation;
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
}
