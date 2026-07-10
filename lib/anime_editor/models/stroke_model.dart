import 'dart:ui';

import 'point_model.dart';

class StrokeModel {
  final List<PointModel> points;
  final Color color;
  final double strokeWidth;

  StrokeModel({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });
}