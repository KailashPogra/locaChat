import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:locachat/screens/auth/screens/sign_in_screen.dart';

void showSnackBar(String text) {
  Fluttertoast.showToast(msg: text);
}

void showLoginPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Somthing went werong"),
        content: const Text("somthing went wrong . Please log in again."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Close the dialog
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()));
              // Navigate to the login screen or perform any login-related actions
              // For example:
              // Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text("Login"),
          ),
        ],
      );
    },
  );
}
