import 'package:flutter/material.dart';

class CanvasController {
  CanvasController();

  final TransformationController transformationController =
      TransformationController();

  static const double minScale = 0.2;
  static const double maxScale = 8.0;

  void fitToScreen() {
    transformationController.value = Matrix4.identity();
  }

  void reset() {
    fitToScreen();
  }

  void dispose() {
    transformationController.dispose();
  }
}