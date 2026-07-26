import 'episode_model.dart';

class SeasonModel {
  final String id;

  String name;

  List<EpisodeModel> episodes;

  int selectedEpisodeIndex;

  SeasonModel({
    required this.id,
    required this.name,
    required this.episodes,
    this.selectedEpisodeIndex = 0,
  });

  /// Currently selected episode
  EpisodeModel get currentEpisode {
    if (episodes.isEmpty) {
      throw Exception("No episodes found.");
    }

    return episodes[selectedEpisodeIndex];
  }

  /// Change selected episode
  void selectEpisode(int index) {
    if (index < 0 || index >= episodes.length) return;

    selectedEpisodeIndex = index;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "selectedEpisodeIndex": selectedEpisodeIndex,
      "episodes": episodes.map((e) => e.toJson()).toList(),
    };
  }

  factory SeasonModel.fromJson(Map<String, dynamic> json) {
    return SeasonModel(
      id: json["id"],
      name: json["name"] ?? "Season",
      selectedEpisodeIndex: json["selectedEpisodeIndex"] ?? 0,
      episodes: (json["episodes"] as List? ?? [])
          .map((e) => EpisodeModel.fromJson(e))
          .toList(),
    );
  }
}