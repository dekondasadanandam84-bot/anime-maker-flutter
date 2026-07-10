import 'package:flutter/material.dart';
import 'package:flutter_application_1/anime_editor/canvas/drawing_canvas.dart';

import '../../controllers/anime_editor_controller.dart';
import '../../canvas/brush_canvas.dart';

class CanvasPanel extends StatelessWidget {
  final AnimeEditorController controller;
  final String ratio;

  const CanvasPanel({
    super.key,
    required this.controller,
    required this.ratio,
  });

  @override
  Widget build(BuildContext context) {
    double w = 500;
    double h = 280;

    switch (ratio) {
      case "9:16":
        w = 220;
        h = 400;
        break;

      case "1:1":
        w = 350;
        h = 350;
        break;

      case "4:3":
        w = 500;
        h = 375;
        break;

      default:
        w = 500;
        h = 280;
    }

    return Center(
      child: ClipRect(
        child: DrawingCanvas(
  canvasController: controller.canvasController,
  child: Container(
    width: w,
    height: h,
    color: Colors.white,
    child: BrushCanvas(
      brushSystem: controller.brushDrawingSystem,
    ),
  ),
)
      ),
    );
  }
}