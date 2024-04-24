import 'package:locachat/constants/api_url.dart';
import 'package:locachat/data/network/base_api_sarvices.dart';
import 'package:locachat/data/network/network_api_sarvices.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  String? userName;
  String? userEmail;
  String? profileImageUrl;

  BaseApiServices authServices = NetworkApiSarvices();

  Future<dynamic> authApi(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("x-auth-token");

    print("token is $token");

    try {
      dynamic tokenRes =
          await authServices.getPostApiResponse(baseUrl + tokenIsValid, null, {
        'Content-Type': 'application/json; charset=utf-8',
        'x-auth-token': '$token',
      });

      print(tokenRes);
      if (tokenRes == true) {
        dynamic response = await authServices.getGetApiResponse("$baseUrl/", {
          'Content-Type': 'application/json; charset=utf-8',
          'x-auth-token': '$token',
        });

        userName = response['name'];
        userEmail = response['email'];
        profileImageUrl = response['profileImage'];
        print(userEmail);
        print(userName);
        print(profileImageUrl);
        return response;
      }
    } catch (e) {
      rethrow;
    }
  }
}
