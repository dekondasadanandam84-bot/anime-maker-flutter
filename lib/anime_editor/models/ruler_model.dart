class RulerModel {

  bool enabled;

  bool showHorizontal;

  bool showVertical;


  double horizontalPosition;

  double verticalPosition;


  double angle;


  RulerModel({

    this.enabled = false,

    this.showHorizontal = true,

    this.showVertical = true,


    this.horizontalPosition = 0.0,

    this.verticalPosition = 0.0,


    this.angle = 0.0,

  });



  Map<String, dynamic> toJson() {

    return {

      "enabled": enabled,

      "showHorizontal": showHorizontal,

      "showVertical": showVertical,


      "horizontalPosition": horizontalPosition,

      "verticalPosition": verticalPosition,


      "angle": angle,

    };

  }



  factory RulerModel.fromJson(
      Map<String, dynamic> json) {

    return RulerModel(

      enabled:
          json["enabled"] ?? false,


      showHorizontal:
          json["showHorizontal"] ?? true,


      showVertical:
          json["showVertical"] ?? true,


      horizontalPosition:
          (json["horizontalPosition"] as num?)
              ?.toDouble() ?? 0.0,


      verticalPosition:
          (json["verticalPosition"] as num?)
              ?.toDouble() ?? 0.0,


      angle:
          (json["angle"] as num?)
              ?.toDouble() ?? 0.0,

    );

  }

}