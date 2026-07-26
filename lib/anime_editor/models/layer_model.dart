import 'layer_settings_model.dart';
import 'drawable_model.dart';


class LayerModel {

  final String id;

  String name;

  LayerSettingsModel settings;

  List<DrawableModel> drawables;


  LayerModel({
    required this.id,
    required this.name,
    required this.settings,
    required this.drawables,
  });



  Map<String, dynamic> toJson() {
    return {

      "id": id,

      "name": name,

      "settings": settings.toJson(),

      "drawables":
          drawables.map((e) => e.toJson()).toList(),

    };
  }



  factory LayerModel.fromJson(Map<String, dynamic> json) {

    return LayerModel(

      id: json["id"],

      name: json["name"],


      settings:
          LayerSettingsModel.fromJson(json["settings"]),


      drawables:
          (json["drawables"] as List? ?? [])
              .map((e) => DrawableModel.fromJson(e))
              .toList(),

    );
  }



  LayerModel copyWith({

    String? id,

    String? name,

    LayerSettingsModel? settings,

    List<DrawableModel>? drawables,

  }) {

    return LayerModel(

      id: id ?? this.id,

      name: name ?? this.name,

      settings: settings ?? this.settings,

      drawables:
          drawables ?? List<DrawableModel>.from(this.drawables),

    );
  }

}