import 'stroke_model.dart';
import 'image_model.dart';
import 'text_model.dart';
import 'shape_model.dart';


enum DrawableType {
  stroke,
  image,
  text,
  shape,
}


class DrawableModel {

  final String id;

  DrawableType type;


  StrokeModel? stroke;

  ImageModel? image;

  TextModel? text;

  ShapeModel? shape;



  DrawableModel({
    required this.id,
    required this.type,

    this.stroke,
    this.image,
    this.text,
    this.shape,
  });



  Map<String, dynamic> toJson() {

    return {

      "id": id,

      "type": type.name,


      "stroke": stroke?.toJson(),

      "image": image?.toJson(),

      "text": text?.toJson(),

      "shape": shape?.toJson(),

    };
  }



  factory DrawableModel.fromJson(
      Map<String, dynamic> json) {

    final type =
        DrawableType.values.firstWhere(
      (e) => e.name == json["type"],
      orElse: () => DrawableType.stroke,
    );


    return DrawableModel(

      id: json["id"],

      type: type,


      stroke: json["stroke"] != null
          ? StrokeModel.fromJson(json["stroke"])
          : null,


      image: json["image"] != null
          ? ImageModel.fromJson(json["image"])
          : null,


      text: json["text"] != null
          ? TextModel.fromJson(json["text"])
          : null,


      shape: json["shape"] != null
          ? ShapeModel.fromJson(json["shape"])
          : null,

    );
  }

}