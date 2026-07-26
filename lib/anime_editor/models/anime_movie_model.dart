import 'clip_model.dart';

class AnimeMovieModel {
  final String id;

  String name;

  List<ClipModel> clips;

  int selectedClipIndex;

  AnimeMovieModel({
    required this.id,
    required this.name,
    required this.clips,
    this.selectedClipIndex = 0,
  });

  /// Currently selected clip
  ClipModel get currentClip {
    if (clips.isEmpty) {
      throw Exception("No clips found.");
    }

    return clips[selectedClipIndex];
  }

  /// Change selected clip
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

  factory AnimeMovieModel.fromJson(Map<String, dynamic> json) {
    return AnimeMovieModel(
      id: json["id"],
      name: json["name"],
      selectedClipIndex: json["selectedClipIndex"] ?? 0,
      clips: (json["clips"] as List? ?? [])
          .map((e) => ClipModel.fromJson(e))
          .toList(),
    );
  }
}