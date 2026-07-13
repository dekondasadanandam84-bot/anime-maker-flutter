class CanvasModel {
  String ratio;

  double width;
  double height;

  double zoom;
  double rotation;

  double offsetX;
  double offsetY;

  int backgroundColor;

  bool showGrid;
  bool showOnionSkin;

  CanvasModel({
    required this.ratio,
    required this.width,
    required this.height,
    this.zoom = 1.0,
    this.rotation = 0.0,
    this.offsetX = 0.0,
    this.offsetY = 0.0,
    this.backgroundColor = 0xFFFFFFFF,
    this.showGrid = false,
    this.showOnionSkin = false,
  });

  Map<String, dynamic> toJson() {
    return {
      "ratio": ratio,
      "width": width,
      "height": height,
      "zoom": zoom,
      "rotation": rotation,
      "offsetX": offsetX,
      "offsetY": offsetY,
      "backgroundColor": backgroundColor,
      "showGrid": showGrid,
      "showOnionSkin": showOnionSkin,
    };
  }

  factory CanvasModel.fromJson(Map<String, dynamic> json) {
    return CanvasModel(
      ratio: json["ratio"],
      width: (json["width"] as num).toDouble(),
      height: (json["height"] as num).toDouble(),
      zoom: (json["zoom"] as num?)?.toDouble() ?? 1.0,
      rotation: (json["rotation"] as num?)?.toDouble() ?? 0.0,
      offsetX: (json["offsetX"] as num?)?.toDouble() ?? 0.0,
      offsetY: (json["offsetY"] as num?)?.toDouble() ?? 0.0,
      backgroundColor: json["backgroundColor"] ?? 0xFFFFFFFF,
      showGrid: json["showGrid"] ?? false,
      showOnionSkin: json["showOnionSkin"] ?? false,
    );
  }
}