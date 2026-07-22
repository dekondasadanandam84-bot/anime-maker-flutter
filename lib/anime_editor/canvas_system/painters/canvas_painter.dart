import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/canvas_model.dart';
import '../models/stroke_model.dart';

class CanvasPainter extends CustomPainter {
  final CanvasModel canvas;
  final StrokeModel? currentStroke;

  CanvasPainter({
    required this.canvas,
    this.currentStroke,
  });

  @override
void paint(Canvas drawingCanvas, Size size) {

  drawingCanvas.clipRect(
    Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    ),
  );

  for (final stroke in canvas.strokes) {
    _drawStroke(drawingCanvas, stroke);
  }

  if (currentStroke != null) {
    _drawStroke(
      drawingCanvas,
      currentStroke!,
    );
  }
}

  void _drawStroke(
    Canvas drawingCanvas,
    StrokeModel stroke,
  ) {
    if (stroke.points.isEmpty) return;

    final paint = Paint()
      ..color = stroke.brush.color.withValues(
        alpha: stroke.brush.opacity,
      )
      ..strokeWidth = stroke.brush.size
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = stroke.brush.antiAlias;

    if (stroke.points.length == 1) {
      final point = stroke.points.first;

      drawingCanvas.drawPoints(
        PointMode.points,
        [
          Offset(point.x, point.y),
        ],
        paint,
      );

      return;
    }

    for (int i = 0; i < stroke.points.length - 1; i++) {
      final p1 = stroke.points[i];
      final p2 = stroke.points[i + 1];

      drawingCanvas.drawLine(
        Offset(p1.x, p1.y),
        Offset(p2.x, p2.y),
        paint,
      );
    }
  }

  @override
bool shouldRepaint(CanvasPainter oldDelegate) {

  return oldDelegate.canvas != canvas ||
      oldDelegate.currentStroke != currentStroke;

}
}