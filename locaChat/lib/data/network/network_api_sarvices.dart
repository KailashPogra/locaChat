import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:locachat/data/app_exceptions.dart';
import 'package:locachat/data/network/base_api_sarvices.dart';
import 'package:http/http.dart' as http;

class NetworkApiSarvices extends BaseApiServices {
  @override
  Future getGetApiResponse(String url, Map<String, String> headers) async {
    dynamic responseJson;
    try {
      var response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));
      print(response.statusCode);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FatchDataException('no internet connection');
    } on TimeoutException {
      throw TimeoutException('request timed out');
    }

    return responseJson;
  }

  @override
  Future getPostApiResponse(
      String url, data, Map<String, String> headers) async {
    dynamic responseJson;
    try {
      var response = await http.post(Uri.parse(url),
          body: data == null ? data : jsonEncode(data), headers: headers);
      print(response.body);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FatchDataException('no internet connection');
    } on TimeoutException {
      throw TimeoutException('request timed out');
    }
    return responseJson;
  }

  static dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 500:
      case 404:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FatchDataException(
            'error occur while communicating with server with status code: ${response.statusCode}');
    }
  }
}
