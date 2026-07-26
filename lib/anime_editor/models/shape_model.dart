enum ShapeType {
  rectangle,
  circle,
  line,
  ellipse,
  polygon,
}


class ShapeModel {

  final String id;

  ShapeType type;


  double x;

  double y;


  double width;

  double height;


  int strokeColor;

  double strokeWidth;


  int fillColor;

  bool filled;


  double rotation;

  double opacity;



  ShapeModel({

    required this.id,

    required this.type,


    this.x = 0.0,

    this.y = 0.0,


    this.width = 100.0,

    this.height = 100.0,


    this.strokeColor = 0xFF000000,

    this.strokeWidth = 2.0,


    this.fillColor = 0x00000000,

    this.filled = false,


    this.rotation = 0.0,

    this.opacity = 1.0,

  });



  Map<String, dynamic> toJson() {

    return {

      "id": id,

      "type": type.name,


      "x": x,

      "y": y,


      "width": width,

      "height": height,


      "strokeColor": strokeColor,

      "strokeWidth": strokeWidth,


      "fillColor": fillColor,

      "filled": filled,


      "rotation": rotation,

      "opacity": opacity,

    };
  }



  factory ShapeModel.fromJson(
      Map<String, dynamic> json) {

    return ShapeModel(

      id: json["id"],


      type: ShapeType.values.firstWhere(
        (e) => e.name == json["type"],
        orElse: () => ShapeType.rectangle,
      ),


      x:
          (json["x"] as num?)?.toDouble() ?? 0.0,


      y:
          (json["y"] as num?)?.toDouble() ?? 0.0,


      width:
          (json["width"] as num?)?.toDouble() ?? 100.0,


      height:
          (json["height"] as num?)?.toDouble() ?? 100.0,


      strokeColor:
          json["strokeColor"] ?? 0xFF000000,


      strokeWidth:
          (json["strokeWidth"] as num?)?.toDouble() ?? 2.0,


      fillColor:
          json["fillColor"] ?? 0x00000000,


      filled:
          json["filled"] ?? false,


      rotation:
          (json["rotation"] as num?)?.toDouble() ?? 0.0,


      opacity:
          (json["opacity"] as num?)?.toDouble() ?? 1.0,

    );
  }

}