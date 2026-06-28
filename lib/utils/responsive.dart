import 'package:flutter/material.dart';

class Responsive {
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 700;
  }

  static bool isPhone(BuildContext context) {
    return MediaQuery.of(context).size.width < 700;
  }
}