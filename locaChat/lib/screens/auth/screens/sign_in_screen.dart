import 'package:flutter/material.dart';
import 'package:locachat/common/widgets/custom_button.dart';
import 'package:locachat/common/widgets/custom_textfield.dart';
import 'package:locachat/constants/custom_feature.dart';
import 'package:locachat/constants/globle_variable.dart';
import 'package:locachat/provider/sign_in_provider.dart';
import 'package:locachat/utils.dart';
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signInProvider = Provider.of<SignInProvider>(context, listen: true);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Colors based on theme
    final backgroundColor =
        isDarkMode ? Colors.black : GlobleVariable.backgroundColor;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final primaryColor = isDarkMode ? Colors.deepPurple : hexToColor("4F4DAC");

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top design stack
              Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: kHeight(25, context),
                      width: kWidth(90, context),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.grey[800]
                            : hexToColor("A0B0FF"),
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
                        color: primaryColor,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.elliptical(400, 200),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: kHeight(2, context)),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Glad to see you',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 32,
                    color: textColor,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'again',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 38,
                    color: primaryColor,
                  ),
                ),
              ),
              SizedBox(height: kHeight(2, context)),
              Form(
                key: _signInFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: emailController,
                      hintText: "Email",
                      prefixIcon: const Icon(Icons.email_outlined),
                      // textColor: textColor, // Pass color to widget
                    ),
                    SizedBox(height: kHeight(3, context)),
                    CustomTextField(
                      controller: passwordController,
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      // co: textColor, // Pass color to widget
                      //    obscureText: true,
                    ),
                    SizedBox(height: kHeight(6, context)),
                  ],
                ),
              ),
              CustomButton(
                circularProgressIndicator: signInProvider.loading,
                text: 'SIGN IN',
                onTap: () {
                  if (emailController.text == '') {
                    showSnackBar("Please enter your email");
                  } else if (passwordController.text == '') {
                    showSnackBar("Please enter your password");
                  } else if (_signInFormKey.currentState!.validate()) {
                    Map<String, String> data = {
                      "email": emailController.text,
                      "password": passwordController.text,
                    };
                    signInProvider.signInApi(data, context);
                  }
                },
              ),
              const Spacer(),
              // Bottom design stack
              Stack(
                children: [
                  ClipPath(
                    clipper: ClipClipper(),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      height: kHeight(20, context),
                      width: kWidth(100, context),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.grey[800]
                            : hexToColor("A0B0FF"),
                      ),
                    ),
                  ),
                  ClipPath(
                    clipper: Clip2Clipper(),
                    child: Container(
                      height: kHeight(24, context),
                      width: kWidth(100, context),
                      decoration: BoxDecoration(
                        color: primaryColor,
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
                        Text(
                          "Don’t have an account? Please ",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: isDarkMode ? Colors.white70 : Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "signup_screen");
                          },
                          child: const Text(
                            "SIGNUP",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
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
