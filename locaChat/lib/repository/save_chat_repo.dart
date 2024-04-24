import 'package:locachat/constants/api_url.dart';
import 'package:locachat/data/network/base_api_sarvices.dart';
import 'package:locachat/data/network/network_api_sarvices.dart';

class SaveChatRepository {
  BaseApiServices apiServices = NetworkApiSarvices();

  Future<dynamic> saveChatApi(dynamic data) async {
    dynamic responseJson;
    try {
      var response = await apiServices.getPostApiResponse(baseUrl + saveChat,
          data, {'Content-Type': 'application/json; charset=utf-8'});
      //  print(response);
      responseJson = NetworkApiSarvices.returnResponse(response);
      return responseJson;
    } catch (e) {
      return responseJson;
    }
  }
}
