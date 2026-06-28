import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class OrientationHelper {

  static Future<void> lockLandscape() async {
    if (kIsWeb) return; // ❌ ignore web

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  static Future<void> resetPortrait() async {
    if (kIsWeb) return; // ❌ ignore web

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}