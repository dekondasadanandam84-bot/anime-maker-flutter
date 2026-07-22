import 'package:flutter/material.dart';

@immutable
class BrushModel {
  /// Unique brush ID.
  final String id;

  /// Brush color.
  final Color color;

  /// Brush size in logical pixels.
  final double size;

  /// Brush opacity (0.0 - 1.0).
  final double opacity;

  /// Whether anti-aliasing is enabled.
  final bool antiAlias;

  /// Whether pressure sensitivity is enabled.
  final bool pressureEnabled;

  const BrushModel({
    required this.id,
    this.color = Colors.black,
    this.size = 8.0,
    this.opacity = 1.0,
    this.antiAlias = true,
    this.pressureEnabled = false,
  });

  /// Creates a modified copy.
  BrushModel copyWith({
    String? id,
    Color? color,
    double? size,
    double? opacity,
    bool? antiAlias,
    bool? pressureEnabled,
  }) {
    return BrushModel(
      id: id ?? this.id,
      color: color ?? this.color,
      size: size ?? this.size,
      opacity: opacity ?? this.opacity,
      antiAlias: antiAlias ?? this.antiAlias,
      pressureEnabled: pressureEnabled ?? this.pressureEnabled,
    );
  }

  /// Convert to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'color': color.toARGB32(),
      'size': size,
      'opacity': opacity,
      'antiAlias': antiAlias,
      'pressureEnabled': pressureEnabled,
    };
  }

  /// Create from JSON.
  factory BrushModel.fromJson(Map<String, dynamic> json) {
    return BrushModel(
      id: json['id'] as String,
      color: Color(json['color'] as int),
      size: (json['size'] as num).toDouble(),
      opacity: (json['opacity'] as num).toDouble(),
      antiAlias: json['antiAlias'] as bool,
      pressureEnabled: json['pressureEnabled'] as bool,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BrushModel &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            color == other.color &&
            size == other.size &&
            opacity == other.opacity &&
            antiAlias == other.antiAlias &&
            pressureEnabled == other.pressureEnabled;
  }

  @override
  int get hashCode => Object.hash(
        id,
        color,
        size,
        opacity,
        antiAlias,
        pressureEnabled,
      );

  @override
  String toString() {
    return 'BrushModel('
        'id: $id, '
        'size: $size, '
        'opacity: $opacity'
        ')';
  }
}