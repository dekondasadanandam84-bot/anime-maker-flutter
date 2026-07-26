class ImportModel {

  String filePath;

  String fileType;


  bool scanning;

  bool completed;


  double progress;


  int totalItems;

  int importedItems;


  List<String> detectedFiles;



  ImportModel({

    this.filePath = "",

    this.fileType = "",


    this.scanning = false,

    this.completed = false,


    this.progress = 0.0,


    this.totalItems = 0,

    this.importedItems = 0,


    this.detectedFiles = const [],

  });



  void addFile(String file) {

    detectedFiles =
        List<String>.from(detectedFiles)
          ..add(file);

  }



  Map<String, dynamic> toJson() {

    return {

      "filePath": filePath,

      "fileType": fileType,


      "scanning": scanning,

      "completed": completed,


      "progress": progress,


      "totalItems": totalItems,

      "importedItems": importedItems,


      "detectedFiles": detectedFiles,

    };

  }



  factory ImportModel.fromJson(
      Map<String, dynamic> json) {

    return ImportModel(

      filePath:
          json["filePath"] ?? "",


      fileType:
          json["fileType"] ?? "",


      scanning:
          json["scanning"] ?? false,


      completed:
          json["completed"] ?? false,


      progress:
          (json["progress"] as num?)?.toDouble() ?? 0.0,


      totalItems:
          json["totalItems"] ?? 0,


      importedItems:
          json["importedItems"] ?? 0,


      detectedFiles:
          List<String>.from(
            json["detectedFiles"] ?? [],
          ),

    );

  }

}