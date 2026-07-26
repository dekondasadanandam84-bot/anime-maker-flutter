class PaintModel {

  int color;

  double size;

  double opacity;


  bool fillEnabled;

  bool pressureEnabled;


  String selectedBrushId;


  PaintModel({

    this.color = 0xFF000000,

    this.size = 8.0,

    this.opacity = 1.0,


    this.fillEnabled = false,

    this.pressureEnabled = false,


    this.selectedBrushId = "default",

  });



  Map<String, dynamic> toJson() {

    return {

      "color": color,

      "size": size,

      "opacity": opacity,


      "fillEnabled": fillEnabled,

      "pressureEnabled": pressureEnabled,


      "selectedBrushId": selectedBrushId,

    };

  }



  factory PaintModel.fromJson(
      Map<String, dynamic> json) {

    return PaintModel(

      color:
          json["color"] ?? 0xFF000000,


      size:
          (json["size"] as num?)?.toDouble() ?? 8.0,


      opacity:
          (json["opacity"] as num?)?.toDouble() ?? 1.0,


      fillEnabled:
          json["fillEnabled"] ?? false,


      pressureEnabled:
          json["pressureEnabled"] ?? false,


      selectedBrushId:
          json["selectedBrushId"] ?? "default",

    );

  }

}