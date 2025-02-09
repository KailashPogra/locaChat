import 'package:locachat/common/widgets/bottom_bar.dart';

import 'package:locachat/repository/sign_in_repo.dart';
import 'package:locachat/routs_name.dart';
import 'package:locachat/sarvices/location_sarvices.dart';
import 'package:locachat/utils.dart';
import 'package:flutter/material.dart';

class SignInProvider extends ChangeNotifier {
  SignInRepository signInRepository = SignInRepository();
  final LocationService locationService = LocationService();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> signInApi(dynamic data, BuildContext context) async {
    setLoading(true);
    signInRepository.signInApi(data).then((value) {
      setLoading(false);
      Navigator.pushNamedAndRemoveUntil(
          context, RoutsName.bottombar, (route) => false);
      showSnackBar("login success");
    }).onError((error, stackTrace) {
      setLoading(false);
      showSnackBar("err $error");
    });
  }
}
