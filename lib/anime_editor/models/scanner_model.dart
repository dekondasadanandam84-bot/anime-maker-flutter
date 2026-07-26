class ImportScannerModel {

  String path;


  String fileName;


  String fileType;


  bool scanning;


  bool completed;


  double progress;


  int totalFiles;


  int scannedFiles;


  List<String> foundFiles;



  ImportScannerModel({

    this.path = "",

    this.fileName = "",

    this.fileType = "",


    this.scanning = false,


    this.completed = false,


    this.progress = 0.0,


    this.totalFiles = 0,


    this.scannedFiles = 0,


    this.foundFiles = const [],

  });



  void addFile(String file) {

    foundFiles =
        List<String>.from(foundFiles)
          ..add(file);

  }



  Map<String, dynamic> toJson() {

    return {

      "path": path,

      "fileName": fileName,

      "fileType": fileType,


      "scanning": scanning,

      "completed": completed,


      "progress": progress,


      "totalFiles": totalFiles,

      "scannedFiles": scannedFiles,


      "foundFiles": foundFiles,

    };

  }



  factory ImportScannerModel.fromJson(
      Map<String, dynamic> json) {

    return ImportScannerModel(

      path:
          json["path"] ?? "",


      fileName:
          json["fileName"] ?? "",


      fileType:
          json["fileType"] ?? "",


      scanning:
          json["scanning"] ?? false,


      completed:
          json["completed"] ?? false,


      progress:
          (json["progress"] as num?)
              ?.toDouble() ?? 0.0,


      totalFiles:
          json["totalFiles"] ?? 0,


      scannedFiles:
          json["scannedFiles"] ?? 0,


      foundFiles:
          List<String>.from(
            json["foundFiles"] ?? [],
          ),

    );

  }

}