import 'episode_model.dart';

class SeasonModel {
  final String id;

  String name;

  List<EpisodeModel> episodes;

  SeasonModel({
    required this.id,
    required this.name,
    required this.episodes,
  });
  int selectedEpisodeIndex = 0;

EpisodeModel get currentEpisode =>
    episodes[selectedEpisodeIndex];

void selectEpisode(int index) {
  if (index < 0 || index >= episodes.length) return;

  selectedEpisodeIndex = index;
}
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "episodes": episodes.map((e) => e.toJson()).toList(),
    };
  }

  factory SeasonModel.fromJson(Map<String, dynamic> json) {
    return SeasonModel(
      id: json["id"],
      name: json["name"],
      episodes: (json["episodes"] as List)
          .map((e) => EpisodeModel.fromJson(e))
          .toList(),
    );
  }
}