import 'dart:io';

import 'package:locachat/common/widgets/custom_button.dart';
import 'package:locachat/common/widgets/custom_textfield.dart';
import 'package:locachat/constants/custom_frature.dart';
import 'package:locachat/constants/globle_variable.dart';
import 'package:locachat/provider/sign_up_provider.dart';
import 'package:locachat/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  File? image;
  final _picker = ImagePicker();

  Future getImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 30);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {});
    } else {
      print('no image selected');
    }
  }

  final _signUpFormKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signUpProvider = Provider.of<SignUpProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: GlobleVariable.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: kHeight(22.4, context),
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
                    height: kHeight(18, context),
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
                'WELCOME',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 38,
                    color: hexToColor("4F4DAC")),
              ),
            ),
            SizedBox(
              height: kHeight(2, context),
            ),
            Stack(
              children: [
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
                              child: Image.file(image!,
                                  height: kHeight(9.0, context),
                                  width: kWidth(20, context)),
                            )
                          : const SizedBox(),
                    ),
                  ],
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
                        color: hexToColor("41327E"),
                      )),
                )
              ],
            ),
            Form(
              key: _signUpFormKey,
              child: Column(
                children: [
                  SizedBox(
                    height: kHeight(3.5, context),
                  ),
                  CustomTextField(
                      controller: fullNameController,
                      hintText: "Full Name",
                      prefixIcon: const Icon(Icons.person_outline)),
                  SizedBox(
                    height: kHeight(2, context),
                  ),
                  CustomTextField(
                      controller: emailController,
                      hintText: "Email",
                      prefixIcon: const Icon(Icons.email_outlined)),
                  SizedBox(
                    height: kHeight(2, context),
                  ),
                  CustomTextField(
                      controller: passwordController,
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.password)),
                  SizedBox(
                    height: kHeight(5, context),
                  ),
                ],
              ),
            ),
            CustomButton(
                circularProgressIndicator: signUpProvider.loading,
                text: 'SIGN UP',
                onTap: () {
                  if (image == null) {
                    showSnackBar(context, "please select profile image");
                  }
                  if (_signUpFormKey.currentState!.validate()) {
                    signUpProvider.signUpApi(
                        fullNameController.text.toString(),
                        emailController.text.toString(),
                        passwordController.text.toString(),
                        image!,
                        context);
                  }
                }),
            Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: ClipPath(
                    clipper: ClipClipper(),
                    child: Container(
                      height: kHeight(22, context),
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
                      height: kHeight(22, context),
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
                    top: kHeight(13.5, context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have account. Please",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: hexToColor("FFFFFF"),
                                height: 1,
                                fontSize: 15)),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "signin_screen");
                          },
                          child: Text(
                            "LOGIN",
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
