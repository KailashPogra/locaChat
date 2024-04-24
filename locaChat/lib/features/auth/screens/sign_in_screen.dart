import 'package:locachat/common/widgets/custom_button.dart';
import 'package:locachat/common/widgets/custom_textfield.dart';
import 'package:locachat/constants/custom_frature.dart';
import 'package:locachat/constants/globle_variable.dart';
import 'package:locachat/provider/sign_in_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _signInFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signInProvider = Provider.of<SignInProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: GlobleVariable.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: kHeight(25, context),
                    width: kWidth(90, context),
                    decoration: BoxDecoration(
                      color: hexToColor("A0B0FF"),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.elliptical(450, 250),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: kHeight(22, context),
                    width: kWidth(75, context),
                    decoration: BoxDecoration(
                      color: hexToColor("4F4DAC"),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.elliptical(400, 200),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: kHeight(2, context),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Glad to see you',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 32,
                    color: hexToColor("000000")),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'again',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 38,
                    color: hexToColor("4F4DAC")),
              ),
            ),
            SizedBox(
              height: kHeight(2, context),
            ),
            Form(
              key: _signInFormKey,
              child: Column(
                children: [
                  SizedBox(
                    height: kHeight(3.5, context),
                  ),
                  SizedBox(
                    height: kHeight(2, context),
                  ),
                  CustomTextField(
                      controller: emailController,
                      hintText: "Email",
                      prefixIcon: const Icon(Icons.email_outlined)),
                  SizedBox(
                    height: kHeight(3, context),
                  ),
                  CustomTextField(
                      controller: passwordController,
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.password)),
                  SizedBox(
                    height: kHeight(6, context),
                  ),
                ],
              ),
            ),
            CustomButton(
                circularProgressIndicator: signInProvider.loading,
                text: 'SIGN IN',
                onTap: () {
                  print(
                    emailController.text.toString(),
                  );
                  print(
                    passwordController.text.toString(),
                  );
                  if (_signInFormKey.currentState!.validate()) {
                    Map<String, String> data = {
                      "email": emailController.text.toString(),
                      "password": passwordController.text.toString(),
                    };
                    signInProvider.signInApi(data, context);
                  }
                }),
            SizedBox(
              height: kHeight(2, context),
            ),
            Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: ClipPath(
                    clipper: ClipClipper(),
                    child: Container(
                      height: kHeight(32.3, context),
                      width: kWidth(100, context),
                      decoration: BoxDecoration(
                        color: hexToColor("A0B0FF"),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ClipPath(
                    clipper: Clip2Clipper(),
                    child: Container(
                      height: kHeight(32.3, context),
                      width: kWidth(100, context),
                      decoration: BoxDecoration(
                        color: hexToColor("4F4DAC"),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    left: 0,
                    right: 0,
                    top: kHeight(18, context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don’t have account. Please",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: hexToColor("FFFFFF"),
                                height: 1,
                                fontSize: 15)),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "signup_screen");
                          },
                          child: Text(
                            "SIGNUP",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: hexToColor("41327E"),
                                fontSize: 15),
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ClipClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(300, 120, 0, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class Clip2Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    path.quadraticBezierTo(300, 100, 0, 120);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
