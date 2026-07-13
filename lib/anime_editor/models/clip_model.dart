class ClipModel {
  final int id;
  final String name;
  final int durationSeconds;
  final int fps;
  final int frameCount;
  List<int> frames;
  int selectedFrame;

  ClipModel({
    required this.id,
    required this.name,
    required this.durationSeconds,
    required this.fps,
    required this.frameCount,
    required this.frames,
    this.selectedFrame = 0,
  });


  ClipModel copyWith({
    int? id,
    String? name,
    int? durationSeconds,
    int? fps,
    int? frameCount,
    List<int>? frames,
    int? selectedFrame,
  }) {
    return ClipModel(
      id: id ?? this.id,
      name: name ?? this.name,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      fps: fps ?? this.fps,
      frameCount: frameCount ?? this.frameCount,
      frames: frames ?? List<int>.from(this.frames),
      selectedFrame: selectedFrame ?? this.selectedFrame,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "durationSeconds": durationSeconds,
      "fps": fps,
      "frameCount": frameCount,
      "frames": frames,
      "selectedFrame": selectedFrame,
    };
  }


  factory ClipModel.fromJson(Map<String, dynamic> json) {
    return ClipModel(
      id: json["id"],
      name: json["name"],
      durationSeconds: json["durationSeconds"],
      fps: json["fps"],
      frameCount: json["frameCount"],
      frames: List<int>.from(
        json["frames"] ?? [1], 
      ),
      selectedFrame: json["selectedFrame"] ?? 0,
    );
  }
}