import 'package:locachat/constants/api_url.dart';
import 'package:locachat/data/network/base_api_sarvices.dart';
import 'package:locachat/data/network/network_api_sarvices.dart';
import 'package:locachat/models/chat_user_model.dart';
import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ChatUsersRepository {
  BaseApiServices apiServices = NetworkApiSarvices();

  Future<chatUserModel> getChatUsersApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("x-auth-token");

    try {
      dynamic response =
          await apiServices.getGetApiResponse(baseUrl + chatUsers, {
        'Content-Type': 'application/json; charset=utf-8',
        'x-auth-token': '$token',
      });
      print("chat user repo called");
      // print(response);

      return chatUserModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw e;
    }
  }
}
