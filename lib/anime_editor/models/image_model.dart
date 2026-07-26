class ImageModel {

  final String id;

  String path;

  double x;

  double y;

  double width;

  double height;

  double rotation;

  double opacity;


  ImageModel({

    required this.id,

    required this.path,

    this.x = 0.0,

    this.y = 0.0,

    this.width = 100.0,

    this.height = 100.0,

    this.rotation = 0.0,

    this.opacity = 1.0,

  });



  Map<String, dynamic> toJson() {

    return {

      "id": id,

      "path": path,

      "x": x,

      "y": y,

      "width": width,

      "height": height,

      "rotation": rotation,

      "opacity": opacity,

    };
  }



  factory ImageModel.fromJson(
      Map<String, dynamic> json) {

    return ImageModel(

      id: json["id"],

      path: json["path"],


      x:
          (json["x"] as num?)?.toDouble() ?? 0.0,


      y:
          (json["y"] as num?)?.toDouble() ?? 0.0,


      width:
          (json["width"] as num?)?.toDouble() ?? 100.0,


      height:
          (json["height"] as num?)?.toDouble() ?? 100.0,


      rotation:
          (json["rotation"] as num?)?.toDouble() ?? 0.0,


      opacity:
          (json["opacity"] as num?)?.toDouble() ?? 1.0,

    );
  }

}