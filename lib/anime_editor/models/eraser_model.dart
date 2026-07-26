class EraserModel {

  double size;

  double opacity;


  bool pressureEnabled;


  String mode;


  bool eraseOnlyCurrentLayer;



  EraserModel({

    this.size = 20.0,

    this.opacity = 1.0,


    this.pressureEnabled = false,


    this.mode = "normal",


    this.eraseOnlyCurrentLayer = true,

  });



  Map<String, dynamic> toJson() {

    return {

      "size": size,

      "opacity": opacity,


      "pressureEnabled": pressureEnabled,


      "mode": mode,


      "eraseOnlyCurrentLayer": eraseOnlyCurrentLayer,

    };

  }



  factory EraserModel.fromJson(
      Map<String, dynamic> json) {

    return EraserModel(

      size:
          (json["size"] as num?)?.toDouble() ?? 20.0,


      opacity:
          (json["opacity"] as num?)?.toDouble() ?? 1.0,


      pressureEnabled:
          json["pressureEnabled"] ?? false,


      mode:
          json["mode"] ?? "normal",


      eraseOnlyCurrentLayer:
          json["eraseOnlyCurrentLayer"] ?? true,

    );

  }

}