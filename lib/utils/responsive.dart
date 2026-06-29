import 'package:flutter/material.dart';

class Responsive {
  // Device detection
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 700;
  }

  static bool isPhone(BuildContext context) {
    return MediaQuery.of(context).size.width < 700;
  }

  static bool isSmallPhone(BuildContext context) {
    return MediaQuery.of(context).size.width < 400;
  }

  // Screen values
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  // 🔥 Main scaling factor (VERY IMPORTANT)
  static double scale(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w / 800; // base design width
  }

  // Optional height scaling
  static double scaleH(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return h / 800;
  }
}