import 'package:flutter/material.dart';

@immutable
class PointModel {
  final double x;
  final double y;

  /// Pressure from stylus/finger.
  /// Defaults to 1.0 when pressure is unavailable.
  final double pressure;

  /// Timestamp of when the point was created.
  final DateTime timestamp;

  const PointModel({
    required this.x,
    required this.y,
    this.pressure = 1.0,
    required this.timestamp,
  });

  /// Creates a copy with modified values.
  PointModel copyWith({
    double? x,
    double? y,
    double? pressure,
    DateTime? timestamp,
  }) {
    return PointModel(
      x: x ?? this.x,
      y: y ?? this.y,
      pressure: pressure ?? this.pressure,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  /// Convert to JSON.
  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'pressure': pressure,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Create from JSON.
  factory PointModel.fromJson(Map<String, dynamic> json) {
    return PointModel(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      pressure: (json['pressure'] as num?)?.toDouble() ?? 1.0,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PointModel &&
            runtimeType == other.runtimeType &&
            x == other.x &&
            y == other.y &&
            pressure == other.pressure &&
            timestamp == other.timestamp;
  }

  @override
  int get hashCode {
    return Object.hash(
      x,
      y,
      pressure,
      timestamp,
    );
  }

  @override
  String toString() {
    return 'PointModel('
        'x: $x, '
        'y: $y, '
        'pressure: $pressure, '
        'timestamp: $timestamp'
        ')';
  }
}