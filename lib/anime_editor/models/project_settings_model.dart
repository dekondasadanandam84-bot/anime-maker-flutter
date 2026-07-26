class ProjectSettingsModel {

  String ratio;

  int fps;


  String resolution;


  bool autoSave;


  int autoSaveInterval;


  bool enableAudio;


  bool enableEffects;


  bool enableLayers;


  bool enableHistory;



  ProjectSettingsModel({

    this.ratio = "16:9",

    this.fps = 12,


    this.resolution = "1920x1080",


    this.autoSave = true,


    this.autoSaveInterval = 5,


    this.enableAudio = true,


    this.enableEffects = true,


    this.enableLayers = true,


    this.enableHistory = true,

  });



  Map<String, dynamic> toJson() {

    return {

      "ratio": ratio,


      "fps": fps,


      "resolution": resolution,


      "autoSave": autoSave,


      "autoSaveInterval": autoSaveInterval,


      "enableAudio": enableAudio,


      "enableEffects": enableEffects,


      "enableLayers": enableLayers,


      "enableHistory": enableHistory,

    };

  }



  factory ProjectSettingsModel.fromJson(
      Map<String, dynamic> json) {

    return ProjectSettingsModel(

      ratio:
          json["ratio"] ?? "16:9",


      fps:
          json["fps"] ?? 12,


      resolution:
          json["resolution"] ?? "1920x1080",


      autoSave:
          json["autoSave"] ?? true,


      autoSaveInterval:
          json["autoSaveInterval"] ?? 5,


      enableAudio:
          json["enableAudio"] ?? true,


      enableEffects:
          json["enableEffects"] ?? true,


      enableLayers:
          json["enableLayers"] ?? true,


      enableHistory:
          json["enableHistory"] ?? true,

    );

  }

}