import 'package:flutter/material.dart';

class ProjectModel {
  final String name;
  final String type; // "anime" or "manga"
  final String ratio;
  final int fps;

  final IconData thumbnail;

  const ProjectModel({
    required this.name,
    required this.type,
    required this.ratio,
    required this.fps,
    required this.thumbnail,
  });

  // ===========================
  // COPY WITH (VERY IMPORTANT)
  // ===========================
  ProjectModel copyWith({
    String? name,
    String? type,
    String? ratio,
    int? fps,
    IconData? thumbnail,
  }) {
    return ProjectModel(
      name: name ?? this.name,
      type: type ?? this.type,
      ratio: ratio ?? this.ratio,
      fps: fps ?? this.fps,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }

  // ===========================
  // FACTORY: FROM MAP (migration helper)
  // ===========================
  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      name: map["name"] ?? "Untitled",
      type: map["type"] ?? "anime",
      ratio: map["ratio"] ?? "16:9",
      fps: map["fps"] ?? 12,
      thumbnail: map["thumbnail"] ?? Icons.movie,
    );
  }

  // ===========================
  // TO MAP (for storage if needed)
  // ===========================
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "type": type,
      "ratio": ratio,
      "fps": fps,
      "thumbnail": thumbnail,
    };
  }

  @override
  String toString() {
    return "ProjectModel(name: $name, type: $type, ratio: $ratio, fps: $fps)";
  }
}