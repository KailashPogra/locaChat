import 'dart:async';

import 'dart:io';

import 'package:locachat/constants/api_url.dart';
import 'package:locachat/data/app_exceptions.dart';
import 'package:locachat/data/network/network_api_sarvices.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfileRepository {
  Future<void> updateProfileApi({
    required String name,
    required String email,
    required File? imageFile,
  }) async {
    dynamic responseJson;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("x-auth-token");
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=utf-8',
        'x-auth-token': '$token',
      };
      // Create a multipart request
      var request =
          http.MultipartRequest('PUT', Uri.parse(baseUrl + updateProfile));

      // Add text fields to the request
      request.fields['name'] = name;
      request.fields['email'] = email;

      // Add the image file to the request
      if (imageFile != null) {
        var stream = http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();
        var multipartFile = http.MultipartFile(
          'profileImage',
          stream,
          length,
          filename: imageFile.path, // Provide a filename for the image
        );

        request.files.add(multipartFile);
      }
      request.headers.addAll(headers);
      // Send the request
      var response = await http.Response.fromStream(await request.send());
      print(response.body);
      responseJson = NetworkApiSarvices.returnResponse(response);
    } on SocketException {
      throw FatchDataException('no internet connection');
    } on TimeoutException {
      throw TimeoutException('request timed out');
    }
    print(responseJson);
    return responseJson;
  }
}
