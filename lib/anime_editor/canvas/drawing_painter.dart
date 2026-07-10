
import 'package:flutter/material.dart';

import '../models/stroke_model.dart';

class DrawingPainter extends CustomPainter {
  final List<StrokeModel> strokes;

  const DrawingPainter({
    required this.strokes,
  });

  @override
void paint(Canvas canvas, Size size) {
  for (final stroke in strokes) {
    if (stroke.points.isEmpty) continue;

    final paint = Paint()
      ..color = stroke.color
      ..strokeWidth = stroke.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;
      

    // Single point
    if (stroke.points.length == 1) {
      canvas.drawCircle(
        stroke.points.first.offset,
        stroke.strokeWidth / 2,
        paint,
      );
      continue;
    }

    final path = Path();

    path.moveTo(
      stroke.points.first.offset.dx,
      stroke.points.first.offset.dy,
    );

    for (int i = 1; i < stroke.points.length - 1; i++) {
      final current = stroke.points[i].offset;
      final next = stroke.points[i + 1].offset;

      final midPoint = Offset(
        (current.dx + next.dx) / 2,
        (current.dy + next.dy) / 2,
      );

      path.quadraticBezierTo(
        current.dx,
        current.dy,
        midPoint.dx,
        midPoint.dy,
      );
    }

    final last = stroke.points.last.offset;

    path.lineTo(last.dx, last.dy);

    canvas.drawPath(path, paint);
  }
}

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    return true;
  }
}