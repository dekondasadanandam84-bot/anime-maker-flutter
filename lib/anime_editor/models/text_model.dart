class TextModel {

  final String id;

  String content;

  double x;

  double y;

  double fontSize;

  String fontFamily;

  int color;

  double rotation;

  double opacity;


  TextModel({

    required this.id,

    required this.content,

    this.x = 0.0,

    this.y = 0.0,

    this.fontSize = 24.0,

    this.fontFamily = "Default",

    this.color = 0xFF000000,

    this.rotation = 0.0,

    this.opacity = 1.0,

  });



  Map<String, dynamic> toJson() {

    return {

      "id": id,

      "content": content,

      "x": x,

      "y": y,

      "fontSize": fontSize,

      "fontFamily": fontFamily,

      "color": color,

      "rotation": rotation,

      "opacity": opacity,

    };

  }



  factory TextModel.fromJson(
      Map<String, dynamic> json) {

    return TextModel(

      id: json["id"],

      content: json["content"] ?? "",


      x:
          (json["x"] as num?)?.toDouble() ?? 0.0,


      y:
          (json["y"] as num?)?.toDouble() ?? 0.0,


      fontSize:
          (json["fontSize"] as num?)?.toDouble() ?? 24.0,


      fontFamily:
          json["fontFamily"] ?? "Default",


      color:
          json["color"] ?? 0xFF000000,


      rotation:
          (json["rotation"] as num?)?.toDouble() ?? 0.0,


      opacity:
          (json["opacity"] as num?)?.toDouble() ?? 1.0,

    );

  }

}