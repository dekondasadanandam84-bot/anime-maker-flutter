import 'package:flutter/material.dart';
import 'package:flutter_application_1/goplus/go_plus_ui.dart';
import 'package:flutter_application_1/home/drawer_ui.dart';
import 'package:flutter_application_1/settings/settings_ui.dart';
import 'package:flutter_application_1/templates/templates_ui.dart';
import 'package:flutter_application_1/collaborations/collaborations_ui.dart';
import 'package:flutter_application_1/earn_coins/earn_coins_ui.dart';
import 'package:flutter_application_1/follow_us/follow_us_ui.dart';
import 'package:flutter_application_1/about/about_ui.dart';
import 'package:flutter_application_1/about/about_controller.dart';
import 'package:flutter_application_1/accounts/accounts_ui.dart';
import 'package:flutter_application_1/tutorials/tutorials_ui.dart';
import 'package:flutter_application_1/help_guide/help_guide_ui.dart';

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

  // Collaborations

void openCollaborations(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const CollaborationsUI(),
    ),
  );
}

void closeCollaborations(BuildContext context) {
  Navigator.pop(context);
}

void openEarnCoins(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const EarnCoinsUI(),
    ),
  );
}

void closeEarnCoins(BuildContext context) {
  Navigator.pop(context);
}

void openFollowUs(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const FollowUsUI(),
    ),
  );
}

void closeFollowUs(BuildContext context) {
  Navigator.pop(context);
}

void openAbout(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => AboutUI(
        controller: AboutController(),
      ),
    ),
  );
}

void closeAbout(BuildContext context) {
  Navigator.pop(context);
}

void openAccounts(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const AccountsUI(),
    ),
  );
}

void closeAccounts(BuildContext context) {
  Navigator.pop(context);
}

void openTutorials(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const TutorialsScreen(),
    ),
  );
}

void closeTutorials(BuildContext context) {
  Navigator.pop(context);
}

void openHelpGuide(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const HelpGuideUi(),
    ),
  );
}

void closeHelpGuide(BuildContext context) {
  Navigator.pop(context);
}
}