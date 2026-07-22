import 'package:flutter/material.dart';

import '../models/brush_model.dart';
import '../models/point_model.dart';
import 'canvas_controller.dart';

class TouchInputHandler {
  final CanvasController canvasController;

  TouchInputHandler({
    required this.canvasController,
  });

  void onPanStart({
    required DragStartDetails details,
    required BrushModel brush,
  }) {
    final position = details.localPosition;

    canvasController.startStroke(
      point: PointModel(
        x: position.dx,
        y: position.dy,
        pressure: 1.0,
        timestamp: DateTime.now(),
      ),
      brush: brush,
    );
  }

  void onPanUpdate({
    required DragUpdateDetails details,
  }) {
    final position = details.localPosition;

    canvasController.addPoint(
      PointModel(
        x: position.dx,
        y: position.dy,
        pressure: 1.0,
        timestamp: DateTime.now(),
      ),
    );
  }

  void onPanEnd(
    DragEndDetails details,
  ) {
    canvasController.endStroke();
  }
}