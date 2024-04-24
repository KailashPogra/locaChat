import 'package:locachat/common/widgets/bottom_bar.dart';
import 'package:locachat/features/splash/splash_screen.dart';

import 'package:locachat/repository/sign_in_repo.dart';
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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BottomBar(
                  latitude: locationService.latitude!,
                  longitude: locationService.longitude!)));
      showSnackBar(context, "login success");
    }).onError((error, stackTrace) {
      setLoading(false);
      showSnackBar(context, "err $error");
    });
  }
}
