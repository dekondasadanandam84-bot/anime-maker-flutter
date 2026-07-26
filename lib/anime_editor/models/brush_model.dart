class BrushModel {

  final String id;

  int color;

  double size;

  double opacity;

  bool antiAlias;

  bool pressureEnabled;


  BrushModel({

    required this.id,

    this.color = 0xFF000000,

    this.size = 8.0,

    this.opacity = 1.0,

    this.antiAlias = true,

    this.pressureEnabled = false,

  });



  Map<String, dynamic> toJson() {

    return {

      "id": id,

      "color": color,

      "size": size,

      "opacity": opacity,

      "antiAlias": antiAlias,

      "pressureEnabled": pressureEnabled,

    };
  }



  factory BrushModel.fromJson(
      Map<String, dynamic> json) {

    return BrushModel(

      id: json["id"],


      color:
          json["color"] ?? 0xFF000000,


      size:
          (json["size"] as num?)?.toDouble() ?? 8.0,


      opacity:
          (json["opacity"] as num?)?.toDouble() ?? 1.0,


      antiAlias:
          json["antiAlias"] ?? true,


      pressureEnabled:
          json["pressureEnabled"] ?? false,

    );
  }


}