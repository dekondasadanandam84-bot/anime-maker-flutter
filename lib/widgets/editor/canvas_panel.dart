import 'package:flutter/material.dart';
import 'package:flutter_application_1/anime_editor/controllers/canvas_manager.dart';


class CanvasPanel extends StatelessWidget {
  final CanvasManager canvasManager;

  const CanvasPanel({
    super.key,
    required this.canvasManager,
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
                color: Colors.black26,
                width: 2,
              ),
              borderRadius: BorderRadius.zero,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 8,
                  offset: Offset(0, 2),
                  color: Colors.black12,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}