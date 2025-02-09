import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locachat/common/widgets/custom_button.dart';
import 'package:locachat/common/widgets/custom_textfield.dart';
import 'package:locachat/constants/custom_feature.dart';
import 'package:locachat/constants/globle_variable.dart';
import 'package:locachat/provider/sign_up_provider.dart';
import 'package:locachat/utils.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  File? image;
  final _picker = ImagePicker();
  final _signUpFormKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future getImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 30,
    );

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signUpProvider = Provider.of<SignUpProvider>(context, listen: true);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Theme-based colors
    final backgroundColor =
        isDarkMode ? Colors.black : GlobleVariable.backgroundColor;

    final primaryColor = isDarkMode ? Colors.deepPurple : hexToColor("4F4DAC");
    final containerColor = isDarkMode ? Colors.grey[800] : hexToColor("A0B0FF");

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Top Design Stack
              Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: kHeight(22.4, context),
                      width: kWidth(90, context),
                      decoration: BoxDecoration(
                        color: containerColor,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.elliptical(450, 250),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: kHeight(18, context),
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
                  'WELCOME',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 38,
                    color: primaryColor,
                  ),
                ),
              ),
              SizedBox(height: kHeight(2, context)),

              // Profile Image Section
              Stack(
                children: [
                  Image.asset(
                    "assets/images/profile.png",
                    height: kHeight(10, context),
                    width: kWidth(20, context),
                  ),
                  Positioned(
                    top: 4,
                    right: 0,
                    child: image != null
                        ? ClipOval(
                            child: Image.file(
                              image!,
                              height: kHeight(9.0, context),
                              width: kWidth(20, context),
                            ),
                          )
                        : const SizedBox(),
                  ),
                  Positioned(
                    bottom: 0,
                    top: kHeight(5.6, context),
                    left: kWidth(14.5, context),
                    right: 0,
                    child: IconButton(
                      onPressed: getImage,
                      icon: Icon(
                        Icons.add,
                        size: 19,
                        color: primaryColor,
                      ),
                    ),
                  )
                ],
              ),

              // Form Fields
              Form(
                key: _signUpFormKey,
                child: Column(
                  children: [
                    SizedBox(height: kHeight(3.5, context)),
                    CustomTextField(
                      controller: fullNameController,
                      hintText: "Full Name",
                      prefixIcon: const Icon(Icons.person_outline),
                      //    textColor: textColor,
                    ),
                    SizedBox(height: kHeight(2, context)),
                    CustomTextField(
                      controller: emailController,
                      hintText: "Email",
                      prefixIcon: const Icon(Icons.email_outlined),
                      //  textColor: textColor,
                    ),
                    SizedBox(height: kHeight(2, context)),
                    CustomTextField(
                      controller: passwordController,
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      //   textColor: textColor,
                      //   obscureText: true,
                    ),
                    SizedBox(height: kHeight(5, context)),
                  ],
                ),
              ),

              // Sign Up Button
              CustomButton(
                circularProgressIndicator: signUpProvider.loading,
                text: 'SIGN UP',
                onTap: () {
                  if (image == null) {
                    showSnackBar("Please select profile image");
                  } else if (fullNameController.text.isEmpty) {
                    showSnackBar("Please enter your name");
                  } else if (emailController.text.isEmpty) {
                    showSnackBar("Please enter your email");
                  } else if (passwordController.text.isEmpty) {
                    showSnackBar("Please enter your password");
                  } else if (_signUpFormKey.currentState!.validate()) {
                    signUpProvider.signUpApi(
                      fullNameController.text,
                      emailController.text,
                      passwordController.text,
                      image!,
                      context,
                    );
                  }
                },
              ),
              const Spacer(),

              // Bottom Design Stack
              Stack(
                children: [
                  ClipPath(
                    clipper: ClipClipper(),
                    child: Container(
                      height: kHeight(19.2, context),
                      width: kWidth(100, context),
                      decoration: BoxDecoration(color: containerColor),
                    ),
                  ),
                  ClipPath(
                    clipper: Clip2Clipper(),
                    child: Container(
                      height: kHeight(19.2, context),
                      width: kWidth(100, context),
                      decoration: BoxDecoration(color: primaryColor),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: kHeight(13.5, context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? Please ",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: isDarkMode ? Colors.white70 : Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "signin_screen");
                          },
                          child: const Text(
                            "LOGIN",
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
