import 'package:locachat/constants/api_url.dart';
import 'package:locachat/data/network/base_api_sarvices.dart';

import 'package:locachat/data/network/network_api_sarvices.dart';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetChatRepo {
  BaseApiServices apiServices = NetworkApiSarvices();

  Future<List<Map<String, dynamic>>> getChatApi(
      String senderId, String receiverId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("x-auth-token");

    try {
      Map<String, dynamic> response = await apiServices.getGetApiResponse(
          '$baseUrl$getChat/?senderId=$senderId&receiverId=$receiverId', {
        'Content-Type': 'application/json; charset=utf-8',
        'x-auth-token': '$token',
      });

      List<dynamic> messages = response['messages'];

      List<Map<String, dynamic>> formattedMessages = messages
          .map((message) => {
                'senderId': message['senderId'],
                'message': message['message'],
              })
          .toList();

      print("chat user called" + formattedMessages.toString());
      return formattedMessages;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw e;
    }
  }
}
