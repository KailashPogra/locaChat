import 'dart:async';

import 'dart:io';

import 'package:locachat/constants/api_url.dart';
import 'package:locachat/data/app_exceptions.dart';
import 'package:locachat/data/network/network_api_sarvices.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignUpRepository {
  Future<void> signUpApi({
    required String name,
    required String email,
    required String password,
    required File imageFile,
  }) async {
    dynamic responseJson;
    try {
      // Create a multipart request
      var request =
          http.MultipartRequest('POST', Uri.parse(baseUrl + signUpUrl));

      // Add text fields to the request
      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['password'] = password;

      // Add the image file to the request
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile(
        'profileImage',
        stream,
        length,
        filename: imageFile.path, // Provide a filename for the image
      );

      request.files.add(multipartFile);

      // Send the request
      var response = await http.Response.fromStream(await request.send());
      print(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      responseJson = NetworkApiSarvices.returnResponse(response);
      await prefs.setString("x-auth-token", responseJson['token']);
    } on SocketException {
      throw FatchDataException('no internet connection');
    } on TimeoutException {
      throw TimeoutException('request timed out');
    }

    return responseJson;
  }
}
