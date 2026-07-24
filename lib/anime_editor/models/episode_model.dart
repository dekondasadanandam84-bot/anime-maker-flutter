import 'clip_model.dart';

class EpisodeModel {
  final String id;

  String name;

  List<ClipModel> clips;

  int selectedClipIndex;

  EpisodeModel({
    required this.id,
    required this.name,
    required this.clips,
    this.selectedClipIndex = 0,
  });

  ClipModel get currentClip => clips[selectedClipIndex];

  void selectClip(int index) {
    if (index < 0 || index >= clips.length) return;
    selectedClipIndex = index;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "selectedClipIndex": selectedClipIndex,
      "clips": clips.map((clip) => clip.toJson()).toList(),
    };
  }

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json["id"],
      name: json["name"],
      selectedClipIndex: json["selectedClipIndex"] ?? 0,
      clips: (json["clips"] as List)
          .map((e) => ClipModel.fromJson(e))
          .toList(),
    );
  }
}