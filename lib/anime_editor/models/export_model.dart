class ExportModel {

  String format;

  String filePath;


  bool includeAudio;

  bool includeImages;

  bool includeLayers;

  bool includeHistory;


  int quality;


  bool exporting;

  double progress;



  ExportModel({

    this.format = "mp4",

    this.filePath = "",


    this.includeAudio = true,

    this.includeImages = true,

    this.includeLayers = false,

    this.includeHistory = false,


    this.quality = 100,


    this.exporting = false,

    this.progress = 0.0,

  });



  Map<String, dynamic> toJson() {

    return {

      "format": format,

      "filePath": filePath,


      "includeAudio": includeAudio,

      "includeImages": includeImages,

      "includeLayers": includeLayers,

      "includeHistory": includeHistory,


      "quality": quality,


      "exporting": exporting,

      "progress": progress,

    };

  }



  factory ExportModel.fromJson(
      Map<String, dynamic> json) {

    return ExportModel(

      format:
          json["format"] ?? "mp4",


      filePath:
          json["filePath"] ?? "",


      includeAudio:
          json["includeAudio"] ?? true,


      includeImages:
          json["includeImages"] ?? true,


      includeLayers:
          json["includeLayers"] ?? false,


      includeHistory:
          json["includeHistory"] ?? false,


      quality:
          json["quality"] ?? 100,


      exporting:
          json["exporting"] ?? false,


      progress:
          (json["progress"] as num?)?.toDouble() ?? 0.0,

    );

  }

}