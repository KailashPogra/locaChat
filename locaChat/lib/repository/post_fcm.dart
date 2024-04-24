import 'package:locachat/constants/api_url.dart';
import 'package:locachat/data/network/base_api_sarvices.dart';
import 'package:locachat/data/network/network_api_sarvices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostFcmRepository {
  BaseApiServices apiServices = NetworkApiSarvices();

  Future<dynamic> postFcmApi(dynamic data) async {
    dynamic responseJson;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("x-auth-token");
    try {
      print("fdfffffffffffffffffffffffff");
      var response =
          await apiServices.getPostApiResponse(baseUrl + fcmToken, data, {
        'Content-Type': 'application/json; charset=utf-8',
        'x-auth-token': '$token',
      });

      responseJson = NetworkApiSarvices.returnResponse(response);
      print(responseJson.toString());
      return responseJson;
    } catch (e) {
      return responseJson;
    }
  }
}
