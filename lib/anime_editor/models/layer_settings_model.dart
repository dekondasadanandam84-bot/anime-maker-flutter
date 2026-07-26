class LayerSettingsModel {

  bool visible;

  bool locked;

  double opacity;

  String blendMode;


  LayerSettingsModel({
    this.visible = true,

    this.locked = false,

    this.opacity = 1.0,

    this.blendMode = "normal",
  });



  Map<String, dynamic> toJson() {

    return {

      "visible": visible,

      "locked": locked,

      "opacity": opacity,

      "blendMode": blendMode,

    };
  }



  factory LayerSettingsModel.fromJson(
      Map<String, dynamic> json) {

    return LayerSettingsModel(

      visible:
          json["visible"] ?? true,


      locked:
          json["locked"] ?? false,


      opacity:
          (json["opacity"] as num?)?.toDouble() ?? 1.0,


      blendMode:
          json["blendMode"] ?? "normal",

    );
  }

}