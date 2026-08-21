import 'season_model.dart';

class AnimeSeriesModel {
  final String id;
  final String name;
  final List<SeasonModel> seasons;

  const AnimeSeriesModel({
    required this.id,
    required this.name,
    this.seasons = const [],
  });

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