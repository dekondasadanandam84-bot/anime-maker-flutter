import 'clip_model.dart';

class EpisodeModel {
  const EpisodeModel({
    required this.id,
    required this.name,
    required this.episodeNumber,
    this.clips = const [],
  });

  final String id;
  final String name;
  final int episodeNumber;
  final List<ClipModel> clips;

  int get clipCount => clips.length;

  String get displayName {
    final trimmed = name.trim();

    if (trimmed.isEmpty) {
      return 'Episode $episodeNumber';
    }

    return 'Episode $episodeNumber: $trimmed';
  }

  EpisodeModel copyWith({
    String? id,
    String? name,
    int? episodeNumber,
    List<ClipModel>? clips,
  }) {
    return EpisodeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      clips: clips ?? this.clips,
    );
  }
}