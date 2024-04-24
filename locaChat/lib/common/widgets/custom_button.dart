import 'package:locachat/constants/globle_variable.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool circularProgressIndicator;
  const CustomButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.circularProgressIndicator = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            maximumSize: const Size(double.maxFinite, 50)),
        child: circularProgressIndicator
            ? const CircularProgressIndicator(
                color: GlobleVariable.backgroundColor,
              )
            : Text(text));
  }
}
