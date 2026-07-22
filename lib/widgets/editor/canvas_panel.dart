import 'package:flutter/material.dart';
import 'package:flutter_application_1/anime_editor/canvas_system/controllers/canvas_manager.dart';
import 'package:flutter_application_1/anime_editor/canvas_system/controllers/canvas_controller.dart';
import 'package:flutter_application_1/anime_editor/canvas_system/tools/brush_engine.dart';
import 'package:flutter_application_1/anime_editor/canvas_system/widgets/drawing_canvas.dart';


class CanvasPanel extends StatelessWidget {
  final CanvasManager canvasManager;

  final CanvasController canvasController;

final BrushEngine brushEngine;
final bool brushActive;

  const CanvasPanel({
    super.key,
    required this.canvasManager,
    required this.canvasController,
  required this.brushEngine,
  required this.brushActive,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {


        return Center(
          child: DrawingCanvas(
  canvasManager: canvasManager,
  canvasController: canvasController,
  brushEngine: brushEngine,
  brushActive: brushActive,
)
        );
      },
    );
  }
}