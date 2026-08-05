import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/drawer_ui.dart';

class HomeController {
  const HomeController();

  void openDrawer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DrawerUI()),
    );
  }

  void closeDrawer(BuildContext context) {
    Navigator.pop(context);
  }
}
