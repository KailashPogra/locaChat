import 'dart:async';
import 'package:locachat/common/widgets/bottom_bar.dart';

import 'package:locachat/constants/globle_variable.dart';

import 'package:locachat/screens/auth/screens/sign_up_screen.dart';

import 'package:locachat/repository/auth_repo.dart';
import 'package:locachat/repository/user_status_repo.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserStatusRepo statusRepo = UserStatusRepo();

  AuthRepo auth = AuthRepo();

  String? token;

  @override
  void initState() {
    super.initState();
    auth.authApi();

    init(context);
  }

  void init(BuildContext context) async {
    await tokenIsEmpty();
    checkLocationAndNavigate();
  }

  void checkLocationAndNavigate() async {
    if (mounted) {
      Timer.periodic(const Duration(seconds: 5), (timer) {
        navigate(context);
      });
    }
  }

  Future<void> navigate(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            token == null ? const SignUpScreen() : const BottomBar(),
      ),
    );
  }

  Future<void> tokenIsEmpty() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('x-auth-token');
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
          SizedBox(
            height: 90,
            child: TextLiquidFill(
              boxHeight: 90.0,
              textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.bold),
              boxBackgroundColor: Colors.black,
              text: 'Loca Chat',
              waveColor: Colors.blueAccent,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
