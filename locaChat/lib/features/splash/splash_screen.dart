import 'dart:async';
import 'package:locachat/common/widgets/bottom_bar.dart';
import 'package:locachat/constants/custom_frature.dart';
import 'package:locachat/constants/globle_variable.dart';

import 'package:locachat/features/auth/screens/sign_up_screen.dart';

import 'package:locachat/repository/auth_repo.dart';
import 'package:locachat/repository/user_status_repo.dart';
import 'package:locachat/sarvices/location_sarvices.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserStatusRepo statusRepo = UserStatusRepo();
  final LocationService locationService = LocationService();

  AuthRepo auth = AuthRepo();
  double? latitude;
  double? longitude;
  String? token;

  @override
  void initState() {
    super.initState();
    auth.authApi(context);

    init();
  }

  void init() async {
    await tokenIsEmpty();
    await locationService.updateLocation();

    await navigate();
  }

  Future<void> navigate() async {
    if (locationService.latitude == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => token == null
              ? const SignUpScreen()
              : BottomBar(
                  latitude: locationService.latitude!,
                  longitude: locationService.longitude!,
                ),
        ),
      );
    } else if (locationService.latitude != null) {
      Timer.periodic(Duration(seconds: 3), (timer) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => token == null
                ? const SignUpScreen()
                : BottomBar(
                    latitude: locationService.latitude!,
                    longitude: locationService.longitude!,
                  ),
          ),
        );
      });
    }
  }

  Future<void> tokenIsEmpty() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('x-auth-token');
    if (locationService.latitude != null && locationService.longitude != null) {
      Map<String, dynamic> data = {
        "isOnline": true,
        "latitude": locationService.latitude!,
        "longitude": locationService.longitude!,
      };
      statusRepo.userStatusApi(data);
    }
  }

//this is checked user is online or not

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobleVariable.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (locationService.latitude == null) const LinearProgressIndicator(),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Image.asset(
              "assets/images/logo.png",
              width: 89.58,
              height: 120,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Image.asset(
            "assets/images/locaChat.png",
            height: kHeight(5, context),
          ),
          const SizedBox(
            height: 30,
          ),
          if (locationService.latitude == null) const LinearProgressIndicator(),
        ],
      ),
    );
  }
}
