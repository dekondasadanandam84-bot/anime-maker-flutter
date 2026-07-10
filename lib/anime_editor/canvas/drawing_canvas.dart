import 'package:flutter/material.dart';
import 'package:flutter_application_1/anime_editor/canvas/canvas_controller.dart';

class DrawingCanvas extends StatelessWidget {
  final CanvasController canvasController;
  final Widget child;

  const DrawingCanvas({
    super.key,
    required this.canvasController,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController:
          canvasController.transformationController,
      minScale: CanvasController.minScale,
      maxScale: CanvasController.maxScale,
      panEnabled: true,
      scaleEnabled: true,
      boundaryMargin: const EdgeInsets.all(double.infinity),
      clipBehavior: Clip.none,
      child: child,
    );
  }
}