class AudioTrackModel {

  final String id;

  String name;

  String filePath;


  double volume;

  double startTime;

  double endTime;


  bool muted;

  bool locked;



  AudioTrackModel({

    required this.id,

    required this.name,

    required this.filePath,


    this.volume = 1.0,

    this.startTime = 0.0,

    this.endTime = 0.0,


    this.muted = false,

    this.locked = false,

  });



  Map<String, dynamic> toJson() {

    return {

      "id": id,

      "name": name,

      "filePath": filePath,


      "volume": volume,

      "startTime": startTime,

      "endTime": endTime,


      "muted": muted,

      "locked": locked,

    };

  }



  factory AudioTrackModel.fromJson(
      Map<String, dynamic> json) {

    return AudioTrackModel(

      id: json["id"],

      name: json["name"] ?? "Audio Track",

      filePath: json["filePath"] ?? "",


      volume:
          (json["volume"] as num?)?.toDouble() ?? 1.0,


      startTime:
          (json["startTime"] as num?)?.toDouble() ?? 0.0,


      endTime:
          (json["endTime"] as num?)?.toDouble() ?? 0.0,


      muted:
          json["muted"] ?? false,


      locked:
          json["locked"] ?? false,

    );

  }

}