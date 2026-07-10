class AnimeEditorController {
  String projectName;
  String ratio;
  int fps;

  int frames;

  AnimeEditorController({
    required this.projectName,
    required this.ratio,
    required this.fps,
    this.frames = 1,
  });


  Map<String, dynamic> saveProject() {
    return {
      "name": projectName,
      "type": "anime",
      "ratio": ratio,
      "fps": fps,
      "frames": frames,
      "thumbnail": "anime",
    };
  }


  void addFrames(int value) {
    frames += value;
  }


  void reset() {
    frames = 1;
  }
}