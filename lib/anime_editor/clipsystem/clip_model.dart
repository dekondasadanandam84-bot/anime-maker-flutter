import 'package:flutter_application_1/anime_editor/models/frame_model.dart';

class ClipModel {
  final int id;
  final String name;
  final int durationSeconds;
  final int fps;
  final int frameCount;
  List<FrameModel> frames;
  FrameModel get currentFrame => frames[selectedFrame];
  int selectedFrame;

  ClipModel({
    required this.id,
    required this.name,
    required this.durationSeconds,
    required this.fps,
    required this.frameCount,
    required this.frames,
    this.selectedFrame = 0,
  });


  ClipModel copyWith({
    int? id,
    String? name,
    int? durationSeconds,
    int? fps,
    int? frameCount,
    List<FrameModel>? frames,
    int? selectedFrame,
  }) {
    return ClipModel(
      id: id ?? this.id,
      name: name ?? this.name,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      fps: fps ?? this.fps,
      frameCount: frameCount ?? this.frameCount,
      frames: frames ?? List<FrameModel>.from(this.frames),
      selectedFrame: selectedFrame ?? this.selectedFrame,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "durationSeconds": durationSeconds,
      "fps": fps,
      "frameCount": frameCount,
      "frames": frames.map((frame) => frame.toJson()).toList(),
      "selectedFrame": selectedFrame,
    };
  }


  factory ClipModel.fromJson(Map<String, dynamic> json) {
    return ClipModel(
      id: json["id"],
      name: json["name"],
      durationSeconds: json["durationSeconds"],
      fps: json["fps"],
      frameCount: json["frameCount"],
      frames: (json["frames"] as List? ?? [])
    .map((e) => FrameModel.fromJson(e))
    .toList(),
      selectedFrame: json["selectedFrame"] ?? 0,
    );
  }
}