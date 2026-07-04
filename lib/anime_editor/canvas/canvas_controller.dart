import 'package:flutter/material.dart';

class CanvasController {
  final TransformationController transformationController =
      TransformationController();

  void zoomIn() {
    transformationController.value =
        transformationController.value.scaledByDouble(
      1.2,
      1.2,
      1.0,
      1.0,
    );
  }

  void zoomOut() {
    transformationController.value =
        transformationController.value.scaledByDouble(
      0.8,
      0.8,
      1.0,
      1.0,
    );
  }

  void reset() {
    transformationController.value = Matrix4.identity();
  }

  void dispose() {
    transformationController.dispose();
  }
}