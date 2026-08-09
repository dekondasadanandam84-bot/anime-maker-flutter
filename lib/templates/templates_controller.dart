
import 'package:flutter/material.dart';

class TemplateModel {
  final String title;
  final String description;
  final String image;
  final String duration;

  const TemplateModel({
    required this.title,
    required this.description,
    required this.image,
    required this.duration,
  });
}

class TemplatesController extends ChangeNotifier {
  final List<TemplateModel> _templates = [
    TemplateModel(
      title: "Walk Cycle",
      description: "Smooth character walking loop.",
      duration: "2s",
      image: "assets/templates/screen9.png",
    ),
    TemplateModel(
      title: "Run Cycle",
      description: "Basic running animation.",
      duration: "1s",
      image: "assets/templates/screen5.png",
    ),
    TemplateModel(
      title: "Jump",
      description: "Takeoff and landing animation.",
      duration: "1s",
      image: "assets/templates/screen1.png",
    ),
    TemplateModel(
      title: "Idle",
      description: "Breathing idle pose.",
      duration: "4s",
      image: "assets/templates/screen8.png",
    ),
    TemplateModel(
      title: "Talking",
      description: "Simple mouth movement cycle.",
      duration: "3s",
      image: "assets/templates/screen7.png",
    ),
    TemplateModel(
      title: "Wave",
      description: "Friendly hand waving.",
      duration: "2s",
      image: "assets/templates/screen10.png",
    ),
    TemplateModel(
      title: "Punch",
      description: "Quick punch action.",
      duration: "1s",
      image: "assets/templates/screen3.png",
    ),
    TemplateModel(
      title: "Kick",
      description: "Basic kick animation.",
      duration: "1s",
      image: "assets/templates/screen2.png",
    ),
    TemplateModel(
      title: "Turn Around",
      description: "180° character turn.",
      duration: "2s",
      image: "assets/templates/screen4.png",
    ),
    TemplateModel(
      title: "Blink",
      description: "Natural eye blinking loop.",
      duration: "2s",
      image: "assets/templates/screen6.png",
    ),
  ];

  /// All templates available in AnimeClip.
  List<TemplateModel> get templates => _templates;

  void useTemplate(TemplateModel template) {
    debugPrint("Selected: ${template.title}");

    // Later:
    // Open Editor
    // Import Frames
    // Create Project
  }

  void init() {}
}

