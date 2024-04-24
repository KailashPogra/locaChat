import 'package:locachat/constants/api_url.dart';
import 'package:locachat/data/network/base_api_sarvices.dart';
import 'package:locachat/data/network/network_api_sarvices.dart';
import 'package:flutter/foundation.dart';

class GetFcmRepo {
  BaseApiServices apiServices = NetworkApiSarvices();

  Future<Map<String, dynamic>> getFcmApi(String receiverId) async {
    try {
      Map<String, dynamic> response = await apiServices.getGetApiResponse(
        '$baseUrl$fcmToken/?userId=$receiverId',
        {
          'Content-Type': 'application/json; charset=utf-8',
        },
      );

      return response;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw e;
    }
  }
}
