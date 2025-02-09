import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:locachat/data/app_exceptions.dart';
import 'package:locachat/data/network/base_api_sarvices.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:locachat/utils.dart';

class NetworkApiSarvices extends BaseApiServices {
  final Box cacheBox = Hive.box('apiCache'); // Open Hive box for caching

  @override
  Future getGetApiResponse(String url, Map<String, String> headers) async {
    dynamic responseJson;

    try {
      var response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));

      print(response.statusCode);
      responseJson = returnResponse(response);

      // Store API response in Hive cache
      cacheBox.put(url, jsonEncode(responseJson));
    } on SocketException {
      showSnackBar('No internet connection. Fetching from cache.');
      print('No internet connection. Fetching from cache.');
      if (cacheBox.containsKey(url)) {
        // Return cached response if available
        responseJson = jsonDecode(cacheBox.get(url));
      } else {
        showSnackBar('No internet & no cached data available');
        throw FatchDataException('No internet & no cached data available');
      }
    } on TimeoutException {
      throw TimeoutException('Request timed out');
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

      // Store API response in Hive cache
      cacheBox.put(url, jsonEncode(responseJson));
    } on SocketException {
      showSnackBar('No internet connection. Fetching from cache.');
      print('No internet connection. Fetching from cache.');
      // showSnackBar(context, 'No internet connection');
      if (cacheBox.containsKey(url)) {
        responseJson = jsonDecode(cacheBox.get(url));
      } else {
        showSnackBar('No internet & no cached data available');
        throw FatchDataException('No internet & no cached data available');
      }
    } on TimeoutException {
      throw TimeoutException('Request timed out');
    }

    return responseJson;
  }

  static dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 201:
        return jsonDecode(response.body);
      case 400:
        throw BadRequestException(response.body.toString());
      case 500:
      case 404:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FatchDataException(
            'Error communicating with server: ${response.statusCode}');
    }
  }
}
