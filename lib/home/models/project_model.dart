import 'project_settings_model.dart';
import 'anime_series_model.dart';
import 'anime_movie_model.dart';

enum ProjectType {
  animeSeries,
  animeMovie,
}

class ProjectModel {
  final String id;
  final String name;
  final ProjectType projectType;

  final ProjectSettingsModel settings;

  final AnimeSeriesModel? animeSeries;
  final AnimeMovieModel? animeMovie;

  const ProjectModel({
    required this.id,
    required this.name,
    required this.projectType,
    required this.settings,
    this.animeSeries,
    this.animeMovie,
  });
}