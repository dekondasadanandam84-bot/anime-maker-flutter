import 'episode_model.dart';

class SeasonModel {
  const SeasonModel({
    required this.id,
    required this.number,
    required this.name,
    this.episodes = const [],
  });

  final String id;
  final int number;
  final String name;
  final List<EpisodeModel> episodes;

  int get episodeCount => episodes.length;

  String get displayName {
    final trimmed = name.trim();

    if (trimmed.isEmpty) {
      return 'Season $number';
    }

    final prefix = RegExp(
      r'^season\s+\d+\s*:?\s*',
      caseSensitive: false,
    );

    final customName = trimmed.replaceFirst(prefix, '').trim();

    return customName.isEmpty
        ? 'Season $number'
        : 'Season $number: $customName';
  }

  SeasonModel copyWith({
    String? id,
    int? number,
    String? name,
    List<EpisodeModel>? episodes,
  }) {
    return SeasonModel(
      id: id ?? this.id,
      number: number ?? this.number,
      name: name ?? this.name,
      episodes: episodes ?? this.episodes,
    );
  }
}