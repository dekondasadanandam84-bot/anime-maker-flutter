import 'package:flutter/material.dart';
import 'package:flutter_application_1/goplus/go_plus_ui.dart';
import 'package:flutter_application_1/home/drawer_ui.dart';
import 'package:flutter_application_1/settings/settings_ui.dart';
import 'package:flutter_application_1/templates/templates_ui.dart';

class HomeController {
  const HomeController();

  void openDrawer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DrawerUI(),
      ),
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

  void openTemplates(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TemplatesUI(),
      ),
    );
  }

  void closeTemplates(BuildContext context) {
    Navigator.pop(context);
  }

  // Go Plus
  void openGoPlus(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const GoPlusUI(),
      ),
    );
  }

  void closeGoPlus(BuildContext context) {
    Navigator.pop(context);
  }
}