import 'brush_model.dart';
import 'point_model.dart';


class StrokeModel {

  final String id;

  BrushModel brush;

  List<PointModel> points;


  StrokeModel({
    required this.id,
    required this.brush,
    required this.points,
  });



  void addPoint(PointModel point) {
    points.add(point);
  }



  Map<String, dynamic> toJson() {

    return {

      "id": id,

      "brush": brush.toJson(),

      "points":
          points.map((e) => e.toJson()).toList(),

    };
  }



  factory StrokeModel.fromJson(
      Map<String, dynamic> json) {

    return StrokeModel(

      id: json["id"],


      brush:
          BrushModel.fromJson(json["brush"]),


      points:
          (json["points"] as List? ?? [])
              .map((e) => PointModel.fromJson(e))
              .toList(),

    );
  }

}