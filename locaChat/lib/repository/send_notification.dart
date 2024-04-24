import 'dart:convert';

import 'package:locachat/data/network/base_api_sarvices.dart';
import 'package:locachat/data/network/network_api_sarvices.dart';

class SendNotificationRepo {
  BaseApiServices baseApiServices = NetworkApiSarvices();
  Future<dynamic> sendNotificationApi(dynamic data) async {
    try {
      print("dffffsfffffffffffffffff");
      var response = baseApiServices
          .getPostApiResponse('https://fcm.googleapis.com/fcm/send', data, {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'key=AAAAU8c2Y0g:APA91bH7BcAz9pSv8NJRC1VyS-2Uwtq1-ngq42mMeIFrOigOn-0RJnvj0xP8ajybFImPdr2CUmkgV2grNfBW90ccTuGOKxElIt-c6qK6e1KH3RA-6ytbDTLCvoBcCb9Nt3dqnNaINC1o'
      });

      return response;
    } catch (e) {
      print("errrr" + e.toString());
      throw e;
    }
  }
}
