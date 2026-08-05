import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/drawer_ui.dart';
import 'package:flutter_application_1/settings/settings_ui.dart';

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

  void openSettings(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const SettingsUI(),
    ),
  );
}
  void closeSettings(BuildContext context) {
  Navigator.pop(context);
}
}
