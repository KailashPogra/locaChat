import 'package:locachat/constants/api_url.dart';
import 'package:locachat/data/network/base_api_sarvices.dart';
import 'package:locachat/data/network/network_api_sarvices.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStatusRepo {
  BaseApiServices apiServices = NetworkApiSarvices();

  Future<dynamic> userStatusApi(dynamic data) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("x-auth-token");
      dynamic response = await apiServices.getPostApiResponse(
          baseUrl + updateStatus, data, {
        'Content-Type': 'application/json; charset=utf-8',
        'x-auth-token': "$token"
      });
      return response;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw e;
    }
  }
}
