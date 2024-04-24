import 'dart:io';

import 'package:locachat/common/widgets/bottom_bar.dart';

import 'package:locachat/repository/sign_up_repo.dart';
import 'package:locachat/sarvices/location_sarvices.dart';
import 'package:locachat/utils.dart';
import 'package:flutter/material.dart';

class SignUpProvider extends ChangeNotifier {
  SignUpRepository signUpRepository = SignUpRepository();
  final LocationService locationService = LocationService();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> signUpApi(String name, String email, String password,
      File? imageFile, BuildContext context) async {
    setLoading(true);
    signUpRepository
        .signUpApi(
      name: name,
      email: email,
      password: password,
      imageFile: imageFile!, // Provide a default file if imageFile is null
    )
        .then((value) {
      setLoading(false);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BottomBar(
                  latitude: locationService.latitude!,
                  longitude: locationService.longitude!)));
      showSnackBar(
          context, "Account created. plese Login with the same credentials!");
    }).onError((error, stackTrace) {
      setLoading(false);
      showSnackBar(context, error.toString());
    });
  }
}
