class SelectionModel {

  bool active;


  double x;

  double y;

  double width;

  double height;


  double rotation;


  bool moving;

  bool resizing;



  SelectionModel({

    this.active = false,


    this.x = 0.0,

    this.y = 0.0,


    this.width = 0.0,

    this.height = 0.0,


    this.rotation = 0.0,


    this.moving = false,

    this.resizing = false,

  });



  Map<String, dynamic> toJson() {

    return {

      "active": active,


      "x": x,

      "y": y,


      "width": width,

      "height": height,


      "rotation": rotation,


      "moving": moving,

      "resizing": resizing,

    };

  }



  factory SelectionModel.fromJson(
      Map<String, dynamic> json) {

    return SelectionModel(

      active:
          json["active"] ?? false,


      x:
          (json["x"] as num?)?.toDouble() ?? 0.0,


      y:
          (json["y"] as num?)?.toDouble() ?? 0.0,


      width:
          (json["width"] as num?)?.toDouble() ?? 0.0,


      height:
          (json["height"] as num?)?.toDouble() ?? 0.0,


      rotation:
          (json["rotation"] as num?)?.toDouble() ?? 0.0,


      moving:
          json["moving"] ?? false,


      resizing:
          json["resizing"] ?? false,

    );

  }

}