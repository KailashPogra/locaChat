import 'package:locachat/constants/custom_frature.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Icon prefixIcon;
  final Icon? suffixIcon;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kWidth(80, context),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: 2.0),
          ),
        ),
        child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: EdgeInsets.only(right: kWidth(4, context)),
                child: prefixIcon,
              ),
              suffixIcon: suffixIcon != null
                  ? Padding(
                      padding: EdgeInsets.only(left: kWidth(4, context)),
                      child: suffixIcon,
                    )
                  : null,
              hintText: hintText,
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 30, minHeight: 24),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16.0,
              ),
              hintStyle: const TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter your $hintText';
              }
            }),
      ),
    );
  }
}
