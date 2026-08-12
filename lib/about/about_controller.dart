import 'package:flutter/material.dart';

class AboutController {
  void onTimelinePressed(String number) {
    debugPrint('AnimeClip development timeline: $number');
  }

  void contactUs() {
    debugPrint('Contact Us: Bug or issue report requested.');
    // Connect this to your support/contact workflow later.
  }
}
