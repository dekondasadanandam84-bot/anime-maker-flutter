import 'package:flutter_application_1/anime_editor/canvas_system/models/canvas_model.dart';

class FrameModel {
  final int id;
  CanvasModel canvas;

  int duration;

  bool visible;

  bool locked;

  bool selected;

  String? thumbnailPath;

  FrameModel({
    required this.id,
     required this.canvas,
    this.duration = 1,
    this.visible = true,
    this.locked = false,
    this.selected = false,
    this.thumbnailPath,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "duration": duration,
      "visible": visible,
      "locked": locked,
      "selected": selected,
      "thumbnailPath": thumbnailPath,
      "canvas": canvas.toJson(),
    };
  }

  factory FrameModel.fromJson(Map<String, dynamic> json) {
    return FrameModel(
      id: json["id"],
      duration: json["duration"] ?? 1,
      visible: json["visible"] ?? true,
      locked: json["locked"] ?? false,
      selected: json["selected"] ?? false,
      thumbnailPath: json["thumbnailPath"],
      canvas: CanvasModel.fromJson(json["canvas"]),
    );
  }

  FrameModel copyWith({
    int? id,
    CanvasModel? canvas,
    int? duration,
    bool? visible,
    bool? locked,
    bool? selected,
    String? thumbnailPath,
  }) {
    return FrameModel(
      id: id ?? this.id,
      canvas: canvas ?? this.canvas,
      duration: duration ?? this.duration,
      visible: visible ?? this.visible,
      locked: locked ?? this.locked,
      selected: selected ?? this.selected,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
    );
  }
}