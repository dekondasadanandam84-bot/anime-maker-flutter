class ClipModel {
  const ClipModel({
    required this.id,
    required this.name,
    required this.number,
    this.durationSeconds = 60,
    this.frameCount = 720,
  });

  final String id;
  final String name;
  final int number;
  final int durationSeconds;
  final int frameCount;

  String get durationLabel {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  String get frameLabel => '$frameCount Frames';

  String get metadataLabel => '$durationLabel • $frameLabel';

  ClipModel copyWith({
    String? id,
    String? name,
    int? number,
    int? durationSeconds,
    int? frameCount,
  }) {
    return ClipModel(
      id: id ?? this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      frameCount: frameCount ?? this.frameCount,
    );
  }
}
