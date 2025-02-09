import 'package:locachat/data/response/api_response.dart';
import 'package:locachat/models/nearby_model.dart';
import 'package:locachat/repository/home_screen_repo.dart';
import 'package:flutter/material.dart';
import 'package:locachat/sarvices/location_sarvices.dart';
import 'package:locachat/utils.dart';
import 'package:geocoding/geocoding.dart';

class HomeScreenProvider extends ChangeNotifier {
  Map<String, dynamic> data(bool value) {
    return {
      "isOnline": value,
      "latitude": locationService.latitude!,
      "longitude": locationService.longitude!,
    };
  }

  final homeScreenRepo = HomeScreenRepo();
  LocationService locationService = LocationService();
  ApiResponse<NearbyUser> nearByUserList = ApiResponse.loading();
  String? location;
  setNearByUser(ApiResponse<NearbyUser> response) {
    nearByUserList = response;
    notifyListeners();
  }

  setLocationName() async {
    try {
      await locationService.updateLocation();
      location = await getLocationName(
          locationService.latitude!, locationService.longitude!);
      notifyListeners(); // Only notify after location is retrieved
    } catch (e) {
      location = 'Error: $e';
      notifyListeners();
    }
  }

  Future<String> getLocationName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        return '${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
      } else {
        return 'Location not found';
      }
    } catch (e) {
      return 'Error getting location name';
    }
  }

  Future<void> getNearbyUserApi(
      double latitude, double longitude, BuildContext context) async {
    setNearByUser(ApiResponse.loading());
    homeScreenRepo.getNearbyUserApi(latitude, longitude).then((value) {
      setNearByUser(ApiResponse.completed(value));
      print(value);
    }).onError((error, stackTrace) {
      showLoginPopup(context);
      setNearByUser(ApiResponse.error(error.toString()));
      print("error is" + error.toString());
    });
  }

  Future<void> fetchAndSendLocation(BuildContext context) async {
    try {
      getNearbyUserApi(
          locationService.latitude!, locationService.longitude!, context);
    } catch (e) {
      print("Error fetching location: $e");
    }
  }
}
