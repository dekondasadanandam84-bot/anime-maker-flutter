import 'season_model.dart';

class AnimeSeriesModel {
  final String id;

  String name;

  List<SeasonModel> seasons;

  int selectedSeasonIndex;

  AnimeSeriesModel({
    required this.id,
    required this.name,
    required this.seasons,
    this.selectedSeasonIndex = 0,
  });

  /// Currently selected season
  SeasonModel get currentSeason {
    if (seasons.isEmpty) {
      throw Exception("No seasons found.");
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
      "selectedSeasonIndex": selectedSeasonIndex,
      "seasons": seasons.map((season) => season.toJson()).toList(),
    };
  }

  factory AnimeSeriesModel.fromJson(Map<String, dynamic> json) {
    return AnimeSeriesModel(
      id: json["id"],
      name: json["name"],
      selectedSeasonIndex: json["selectedSeasonIndex"] ?? 0,
      seasons: (json["seasons"] as List? ?? [])
          .map((e) => SeasonModel.fromJson(e))
          .toList(),
    );
  }
}