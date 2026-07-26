import 'anime_series_model.dart';
import 'anime_movie_model.dart';
import 'project_settings_model.dart';
import 'export_model.dart';
import 'import_model.dart';


class ProjectModel {

  final String id;


  String name;


  String type;


  ProjectSettingsModel settings;


  AnimeSeriesModel? series;


  AnimeMovieModel? movie;


  ExportModel export;


  ImportModel import;



  ProjectModel({

    required this.id,

    required this.name,

    required this.type,


    required this.settings,


    this.series,

    this.movie,


    required this.export,

    required this.import,

  });



  bool get isSeries =>
      type == "series";


  bool get isMovie =>
      type == "movie";



  Map<String, dynamic> toJson() {

    return {

      "id": id,

      "name": name,

      "type": type,


      "settings":
          settings.toJson(),


      "series":
          series?.toJson(),


      "movie":
          movie?.toJson(),


      "export":
          export.toJson(),


      "import":
          import.toJson(),

    };

  }



  factory ProjectModel.fromJson(
      Map<String, dynamic> json) {

    return ProjectModel(

      id:
          json["id"],


      name:
          json["name"],


      type:
          json["type"] ?? "series",


      settings:
          ProjectSettingsModel.fromJson(
            json["settings"] ?? {},
          ),


      series:
          json["series"] != null
              ? AnimeSeriesModel.fromJson(
                  json["series"],
                )
              : null,


      movie:
          json["movie"] != null
              ? AnimeMovieModel.fromJson(
                  json["movie"],
                )
              : null,


      export:
          ExportModel.fromJson(
            json["export"] ?? {},
          ),


      import:
          ImportModel.fromJson(
            json["import"] ?? {},
          ),

    );

  }

}