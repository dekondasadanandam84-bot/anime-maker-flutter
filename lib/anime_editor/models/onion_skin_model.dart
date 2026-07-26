class OnionSkinModel {

  bool enabled;

  bool showPreviousFrames;

  bool showNextFrames;


  int previousFrameCount;

  int nextFrameCount;


  double opacity;


  int previousColor;

  int nextColor;



  OnionSkinModel({

    this.enabled = false,

    this.showPreviousFrames = true,

    this.showNextFrames = true,


    this.previousFrameCount = 1,

    this.nextFrameCount = 1,


    this.opacity = 0.5,


    this.previousColor = 0xFFFF0000,

    this.nextColor = 0xFF0000FF,

  });



  Map<String, dynamic> toJson() {

    return {

      "enabled": enabled,


      "showPreviousFrames": showPreviousFrames,

      "showNextFrames": showNextFrames,


      "previousFrameCount": previousFrameCount,

      "nextFrameCount": nextFrameCount,


      "opacity": opacity,


      "previousColor": previousColor,

      "nextColor": nextColor,

    };

  }



  factory OnionSkinModel.fromJson(
      Map<String, dynamic> json) {

    return OnionSkinModel(

      enabled:
          json["enabled"] ?? false,


      showPreviousFrames:
          json["showPreviousFrames"] ?? true,


      showNextFrames:
          json["showNextFrames"] ?? true,


      previousFrameCount:
          json["previousFrameCount"] ?? 1,


      nextFrameCount:
          json["nextFrameCount"] ?? 1,


      opacity:
          (json["opacity"] as num?)?.toDouble() ?? 0.5,


      previousColor:
          json["previousColor"] ?? 0xFFFF0000,


      nextColor:
          json["nextColor"] ?? 0xFF0000FF,

    );

  }

}