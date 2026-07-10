import 'package:flutter/material.dart';

import '../drawing/brush_drawing_system.dart';
import 'drawing_painter.dart';

class BrushCanvas extends StatelessWidget {
  final BrushDrawingSystem brushSystem;

  const BrushCanvas({
    super.key,
    required this.brushSystem,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: brushSystem,
      builder: (context, child) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,

          onPanStart: (details) {
            brushSystem.startStroke(details.localPosition);
          },

          onPanUpdate: (details) {
            brushSystem.addPoint(details.localPosition);
          },

          onPanEnd: (_) {
            brushSystem.endStroke();
          },

          child: CustomPaint(
            painter: DrawingPainter(
              strokes: brushSystem.strokes,
            ),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}