import 'package:flutter/foundation.dart';

import 'brush_model.dart';
import 'point_model.dart';

@immutable
class StrokeModel {
  /// Unique ID for this stroke.
  final String id;

  /// Brush settings used to draw this stroke.
  final BrushModel brush;

  /// All sampled points in this stroke.
  final List<PointModel> points;

  const StrokeModel({
    required this.id,
    required this.brush,
    required this.points,
  });

  /// Returns a new stroke with modified values.
  StrokeModel copyWith({
    String? id,
    BrushModel? brush,
    List<PointModel>? points,
  }) {
    return StrokeModel(
      id: id ?? this.id,
      brush: brush ?? this.brush,
      points: points ?? this.points,
    );
  }

  /// Returns a new stroke with one more point.
  StrokeModel addPoint(PointModel point) {
    return StrokeModel(
      id: id,
      brush: brush,
      points: [...points, point],
    );
  }

  /// Convert to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brush': brush.toJson(),
      'points': points.map((point) => point.toJson()).toList(),
    };
  }

  /// Create from JSON.
  factory StrokeModel.fromJson(Map<String, dynamic> json) {
    return StrokeModel(
      id: json['id'] as String,
      brush: BrushModel.fromJson(
        json['brush'] as Map<String, dynamic>,
      ),
      points: (json['points'] as List)
          .map(
            (point) => PointModel.fromJson(
              point as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  @override
  String toString() {
    return 'StrokeModel('
        'id: $id, '
        'points: ${points.length}'
        ')';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is StrokeModel &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            brush == other.brush &&
            listEquals(points, other.points);
  }

  @override
  int get hashCode => Object.hash(
        id,
        brush,
        Object.hashAll(points),
      );
}