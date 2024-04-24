import 'package:locachat/data/response/api_response.dart';
import 'package:locachat/models/nearby_model.dart';
import 'package:locachat/repository/home_screen_repo.dart';
import 'package:flutter/material.dart';

class HomeScreenProvider extends ChangeNotifier {
  final homeScreenRepo = HomeScreenRepo();

  ApiResponse<NearbyUser> nearByUserList = ApiResponse.loading();

  setNearByUser(ApiResponse<NearbyUser> response) {
    nearByUserList = response;
    notifyListeners();
  }

  Future<void> getNearbyUserApi(double latitude, double longitude) async {
    setNearByUser(ApiResponse.loading());
    homeScreenRepo.getNearbyUserApi(latitude, longitude).then((value) {
      setNearByUser(ApiResponse.completed(value));
      print(value);
    }).onError((error, stackTrace) {
      setNearByUser(ApiResponse.error(error.toString()));
      print("error is" + error.toString());
    });
  }
}
