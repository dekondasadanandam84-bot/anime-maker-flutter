import '../clipsystem/clip_model.dart';

class ProjectModel {
  final String id;

  String name;
  String type;

  String ratio;
  int fps;



  List<ClipModel> clips;

  int selectedClipIndex;

  ProjectModel({
    required this.id,
    required this.name,
    required this.type,
    required this.ratio,
    required this.fps,
    required this.clips,
    this.selectedClipIndex = 0,
  });

  /// Currently selected clip
  ClipModel get currentClip => clips[selectedClipIndex];

  /// Change selected clip
  void selectClip(int index) {
    if (index < 0 || index >= clips.length) return;
    selectedClipIndex = index;
  }

  /// Convert project into JSON for saving
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "type": type,
      "ratio": ratio,
      "fps": fps,
      "selectedClipIndex": selectedClipIndex,
      "clips": clips.map((clip) => clip.toJson()).toList(),
    };
  }

  /// Load project from JSON
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json["id"],
      name: json["name"],
      type: json["type"],
      ratio: json["ratio"],
      fps: json["fps"],
      selectedClipIndex: json["selectedClipIndex"] ?? 0,
      clips: (json["clips"] as List)
          .map((e) => ClipModel.fromJson(e))
          .toList(),
    );
  }
}