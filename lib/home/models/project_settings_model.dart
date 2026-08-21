enum ProjectAspectRatio {
  ratio16x9,
  ratio9x16,
  ratio4x3,
  ratio3x4,
  ratio1x1,
}

class ProjectSettingsModel {
  final ProjectAspectRatio aspectRatio;
  final double fps;
  final String quality;

  const ProjectSettingsModel({
    required this.aspectRatio,
    required this.fps,
    required this.quality,
  });
}
