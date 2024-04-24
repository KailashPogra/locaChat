import 'dart:io';
import 'package:locachat/common/widgets/custom_button.dart';
import 'package:locachat/common/widgets/custom_textfield.dart';
import 'package:locachat/constants/api_url.dart';
import 'package:locachat/constants/custom_frature.dart';
import 'package:locachat/provider/update_profile_provider.dart';
import 'package:locachat/repository/auth_repo.dart';
import 'package:locachat/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String? name;
  final String? email;
  final String? profileImage;

  User({this.name, this.email, this.profileImage});
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var fullNameController = TextEditingController();
  final emailController = TextEditingController();

  AuthRepo auth = AuthRepo();
  File? image;
  final _picker = ImagePicker();

  Future getImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 30);

    if (pickedFile != null) {
      image = File(pickedFile.path);
    } else {
      print('no image selected');
    }
  }

  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: auth.authApi(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return const Center(
                  child: Text(
                'somthing went wrong',
                style: TextStyle(
                  fontSize: 25,
                ),
              ));
            } else {
              // Assuming authApi returns a User object
              final Map<String, dynamic>? responseData = snapshot.data;
              final user = User(
                name: responseData?['name'],
                email: responseData?['email'],
                profileImage: responseData?['profileImage'],
              );
              return buildProfileUI(context, user);
            }
          }
        },
      ),
    );
  }

  Widget buildProfileUI(BuildContext context, User user) {
    final updateProfileProvider =
        Provider.of<UpdateProfileProvider>(context, listen: true);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 31, right: kWidth(55, context)),
            child: Text(
              "Profile",
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: hexToColor("4F4DAC"),
                  fontFamily: "Poppins",
                  fontSize: 32),
            ),
          ),
          SizedBox(
            height: kHeight(3, context),
          ),
          Center(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(75),
                  child:
                      user.profileImage != null && user.profileImage!.isNotEmpty
                          ? Image.network(
                              "$baseUrl/${user.profileImage!}",
                              height: 150,
                              width: 150,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) {
                                // If there's an error loading the network image (e.g., 404), display the asset image instead
                                return Image.asset(
                                  "assets/images/profile.png",
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.fill,
                                );
                              },
                            )
                          : Image.asset(
                              "assets/images/profile.png", // Placeholder image if imageUrl is null or empty
                              height: 150,
                              width: 150,
                              fit: BoxFit.fill,
                            ),
                ),
                image != null
                    ? ClipOval(
                        child: Image.file(
                          image!,
                          height: 150,
                          width: 150,
                          fit: BoxFit.fill,
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
          SizedBox(
            height: kHeight(3, context),
          ),
          CustomButton(
              text: 'Change Photo',
              onTap: () {
                getImage();
              }),
          Form(
            child: Column(
              children: [
                SizedBox(
                  height: kHeight(3.5, context),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 35, bottom: 0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      " ${user.name!}",
                      style: const TextStyle(fontSize: 15, color: Colors.blue),
                    ),
                  ),
                ),
                CustomTextField(
                  controller: fullNameController,
                  hintText: "enter new name",
                  prefixIcon: const Icon(Icons.person_outline),
                  suffixIcon: const Icon(Icons.edit_document),
                ),
                SizedBox(
                  height: kHeight(2, context),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 35, bottom: 0, top: 10),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      " ${user.email!}",
                      style: const TextStyle(fontSize: 15, color: Colors.blue),
                    ),
                  ),
                ),
                CustomTextField(
                  controller: emailController,
                  hintText: "enter new email",
                  prefixIcon: const Icon(Icons.email_outlined),
                  suffixIcon: const Icon(Icons.edit_document),
                ),
                SizedBox(
                  height: kHeight(3.5, context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                        text: "logout",
                        circularProgressIndicator:
                            updateProfileProvider.loading,
                        onTap: () async {
                          Navigator.pushNamed(context, "signin_screen");
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.remove("x-auth-token");
                        }),
                    SizedBox(
                        width: kWidth(
                            7, context)), // Add some space between buttons
                    CustomButton(
                        text: "Update",
                        circularProgressIndicator:
                            updateProfileProvider.loading,
                        onTap: () async {
                          print(fullNameController.text);
                          print(emailController.text);
                          if (image == null &&
                              fullNameController.text.toString().isEmpty &&
                              emailController.text.toString().isEmpty) {
                            showSnackBar(context,
                                "please select or enter somthing for updating profile");
                            return;
                          }
                          await updateProfileProvider.updateProfileApi(
                              fullNameController.text.toString(),
                              emailController.text.toString(),
                              image,
                              context);
                          setState(() {});
                        }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
