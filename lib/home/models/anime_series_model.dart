import 'season_model.dart';

class AnimeSeriesModel {
  const AnimeSeriesModel({
    required this.id,
    required this.name,
    this.seasons = const [],
  });

  final String id;
  final String name;
  final List<SeasonModel> seasons;

  int get seasonCount => seasons.length;

  AnimeSeriesModel copyWith({
    String? id,
    String? name,
    List<SeasonModel>? seasons,
  }) {
    return AnimeSeriesModel(
      id: id ?? this.id,
      name: name ?? this.name,
      seasons: seasons ?? this.seasons,
    );
  }
}