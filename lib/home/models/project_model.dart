import 'project_settings_model.dart';
import 'anime_series_model.dart';
import 'anime_movie_model.dart';

enum ProjectType {
  animeSeries,
  animeMovie,
}

class ProjectModel {
  const ProjectModel({
    required this.id,
    required this.name,
    required this.projectType,
    required this.settings,
    this.animeSeries,
    this.animeMovie,
  });

  final String id;
  final String name;
  final ProjectType projectType;
  final ProjectSettingsModel settings;
  final AnimeSeriesModel? animeSeries;
  final AnimeMovieModel? animeMovie;

  ProjectModel copyWith({
    String? id,
    String? name,
    ProjectType? projectType,
    ProjectSettingsModel? settings,
    AnimeSeriesModel? animeSeries,
    AnimeMovieModel? animeMovie,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      projectType: projectType ?? this.projectType,
      settings: settings ?? this.settings,
      animeSeries: animeSeries ?? this.animeSeries,
      animeMovie: animeMovie ?? this.animeMovie,
    );
  }
}