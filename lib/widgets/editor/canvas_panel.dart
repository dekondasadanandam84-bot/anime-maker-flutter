import 'package:flutter/material.dart';
import 'package:flutter_application_1/anime_editor/canvas_system/controllers/canvas_controller.dart';
import 'package:flutter_application_1/anime_editor/canvas_system/controllers/canvas_manager.dart';

class CanvasPanel extends StatelessWidget {
  final CanvasManager canvasManager;
  final CanvasController canvasController;

  const CanvasPanel({
    super.key,
    required this.canvasManager,
    required this.canvasController,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        final canvasSize = canvasManager.calculateCanvasSize(
          Size(
            constraints.maxWidth,
            constraints.maxHeight,
          ),
        );

        return Center(
          child: Container(
            width: canvasSize.width,
            height: canvasSize.height,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            child: const Center(
              child: Text(
                "Canvas Coming Soon",
              ),
            ),
          ),
        );
      },
    );
  }
}