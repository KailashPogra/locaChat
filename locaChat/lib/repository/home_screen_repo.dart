import 'package:locachat/constants/api_url.dart';
import 'package:locachat/data/network/base_api_sarvices.dart';
import 'package:locachat/data/network/network_api_sarvices.dart';
import 'package:locachat/models/nearby_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenRepo {
  BaseApiServices apiServices = NetworkApiSarvices();

  Future<NearbyUser> getNearbyUserApi(double latitude, double longitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("x-auth-token");

    try {
      dynamic response = await apiServices.getGetApiResponse(
          '$baseUrl$nearbyuser?latitude=$latitude&longitude=$longitude', {
        'Content-Type': 'application/json; charset=utf-8',
        'x-auth-token': '$token',
      });
      print("repo called");
      print(response);

      return NearbyUser.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw e;
    }
  }
}
