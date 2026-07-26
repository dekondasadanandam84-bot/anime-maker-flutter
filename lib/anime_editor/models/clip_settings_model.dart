class ClipSettingsModel {

  int fps;

  int durationSeconds;

  bool loop;

  bool autoPlay;

  String name;


  ClipSettingsModel({

    required this.fps,

    required this.durationSeconds,

    this.loop = false,

    this.autoPlay = false,

    required this.name,

  });



  Map<String, dynamic> toJson() {

    return {

      "fps": fps,

      "durationSeconds": durationSeconds,

      "loop": loop,

      "autoPlay": autoPlay,

      "name": name,

    };
  }



  factory ClipSettingsModel.fromJson(
      Map<String, dynamic> json) {

    return ClipSettingsModel(

      fps:
          json["fps"] ?? 12,


      durationSeconds:
          json["durationSeconds"] ?? 1,


      loop:
          json["loop"] ?? false,


      autoPlay:
          json["autoPlay"] ?? false,


      name:
          json["name"] ?? "Clip",

    );
  }

}