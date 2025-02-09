import 'package:flutter/material.dart';

double kWidth(double percentage, BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;

  return (screenWidth * percentage) / 100;
}

double kHeight(double percentage, BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;

  return (screenHeight * percentage) / 100;
}

Color hexToColor(String code) {
  return Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
}
