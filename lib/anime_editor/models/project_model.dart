import 'season_model.dart';
import 'clip_model.dart';

class ProjectModel {
  final String id;

  String name;
  String type;
  final String projectType;
  String ratio;
  int fps;
  List<SeasonModel> seasons;
  List<ClipModel> clips;

  int selectedSeasonIndex;

  ProjectModel({
  required this.id,
  required this.name,
  required this.type,
  required this.projectType,
  required this.ratio,
  required this.fps,
  required this.clips,
  required this.seasons,
  this.selectedSeasonIndex = 0,
});


  /// Currently selected season
  SeasonModel get currentSeason {
  if (seasons.isEmpty) {
    throw Exception("No seasons created for this project");
  }

  return seasons[selectedSeasonIndex];
}


  /// Change selected season
  void selectSeason(int index) {
    if (index < 0 || index >= seasons.length) return;

    selectedSeasonIndex = index;
  }


  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "type": type,
      "ratio": ratio,
      "fps": fps,
      "projectType": projectType,
      "selectedSeasonIndex": selectedSeasonIndex,
      "seasons": seasons.map((season) => season.toJson()).toList(),
      "clips": clips.map((clip) => clip.toJson()).toList(),
    };
  }


  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json["id"],
      name: json["name"],
      type: json["type"],
      ratio: json["ratio"],
      projectType: json["projectType"] ?? "series",
      fps: json["fps"],
      selectedSeasonIndex: json["selectedSeasonIndex"] ?? 0,
      seasons: (json["seasons"] as List? ?? [])
          .map((e) => SeasonModel.fromJson(e))
          .toList(),
          clips: (json["clips"] as List? ?? [])
    .map((e) => ClipModel.fromJson(e))
    .toList(),
    );
  }
}