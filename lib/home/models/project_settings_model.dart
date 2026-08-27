enum ProjectAspectRatio {
  ratio16x9,
  ratio9x16,
  ratio1x1,
  ratio4x1,
}

class ProjectSettingsModel {
  const ProjectSettingsModel({
    required this.aspectRatio,
    required this.fps,
    required this.quality,
    this.resolution = '1920 × 1080',
  });

  final ProjectAspectRatio aspectRatio;
  final double fps;
  final String quality;
  final String resolution;

  ProjectSettingsModel copyWith({
    ProjectAspectRatio? aspectRatio,
    double? fps,
    String? quality,
    String? resolution,
  }) {
    return ProjectSettingsModel(
      aspectRatio: aspectRatio ?? this.aspectRatio,
      fps: fps ?? this.fps,
      quality: quality ?? this.quality,
      resolution: resolution ?? this.resolution,
    );
  }
}