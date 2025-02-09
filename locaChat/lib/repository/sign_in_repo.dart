import 'package:locachat/constants/api_url.dart';
import 'package:locachat/data/network/base_api_sarvices.dart';
import 'package:locachat/data/network/network_api_sarvices.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInRepository {
  BaseApiServices loginSarvices = NetworkApiSarvices();

  Future<dynamic> signInApi(dynamic data) async {
    try {
      dynamic response = await loginSarvices.getPostApiResponse(
          baseUrl + signInUrl,
          data,
          {'Content-Type': 'application/json; charset=utf-8'});

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("x-auth-token", response['token']);
      if (response.containsKey('msg')) {
        return response[
            'msg']; // Return the message (e.g., "Incorrect password")
      }
      return response;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw e;
    }
  }
}
