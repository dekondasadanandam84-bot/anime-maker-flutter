import 'package:flutter/foundation.dart';

class EpisodeModel {
  EpisodeModel({
    required this.id,
    required this.number,
    this.name,
    this.clipCount = 0,
  });

  final String id;
  final int number;
  String? name;
  int clipCount;

  String get displayName {
    final trimmed = name?.trim() ?? '';
    return trimmed.isEmpty ? 'Episode $number' : trimmed;
  }

  EpisodeModel copyWith({
    String? id,
    int? number,
    String? name,
    int? clipCount,
  }) {
    return EpisodeModel(
      id: id ?? this.id,
      number: number ?? this.number,
      name: name ?? this.name,
      clipCount: clipCount ?? this.clipCount,
    );
  }
}

class EpisodesController extends ChangeNotifier {
  EpisodesController({
    List<EpisodeModel>? initialEpisodes,
  }) : _episodes = initialEpisodes ??
            [
              EpisodeModel(id: 'episode_1', number: 1, clipCount: 4),
              EpisodeModel(id: 'episode_2', number: 2, clipCount: 8),
              EpisodeModel(id: 'episode_3', number: 3, clipCount: 0),
            ];

  final List<EpisodeModel> _episodes;
  bool _isBusy = false;

  List<EpisodeModel> get episodes => List.unmodifiable(_episodes);
  bool get isBusy => _isBusy;

  int get nextEpisodeNumber {
    if (_episodes.isEmpty) return 1;
    return _episodes.map((e) => e.number).reduce((a, b) => a > b ? a : b) + 1;
  }

  EpisodeModel? findEpisode(String id) {
    for (final episode in _episodes) {
      if (episode.id == id) return episode;
    }
    return null;
  }

  Future<EpisodeModel> createEpisode({
    String? name,
    int clipCount = 0,
  }) async {
    _setBusy(true);
    try {
      final number = nextEpisodeNumber;
      final cleanName = name?.trim() ?? '';
      final episode = EpisodeModel(
        id: _createId(number),
        number: number,
        name: cleanName.isEmpty ? null : cleanName,
        clipCount: clipCount < 0 ? 0 : clipCount,
      );
      _episodes.add(episode);
      notifyListeners();
      return episode;
    } finally {
      _setBusy(false);
    }
  }

  Future<bool> renameEpisode({
    required String episodeId,
    required String newName,
  }) async {
    final episode = findEpisode(episodeId);
    if (episode == null) return false;

    final cleanName = newName.trim();
    episode.name = cleanName.isEmpty ? null : cleanName;
    notifyListeners();
    return true;
  }

  Future<bool> deleteEpisode(String episodeId) async {
    _setBusy(true);
    try {
      final index = _episodes.indexWhere((e) => e.id == episodeId);
      if (index == -1) return false;
      _episodes.removeAt(index);
      notifyListeners();
      return true;
    } finally {
      _setBusy(false);
    }
  }

  void updateClipCount({
    required String episodeId,
    required int clipCount,
  }) {
    final episode = findEpisode(episodeId);
    if (episode == null) return;
    episode.clipCount = clipCount < 0 ? 0 : clipCount;
    notifyListeners();
  }

  String getClipLabel(EpisodeModel episode) {
    return episode.clipCount == 1
        ? '1 Clip'
        : '${episode.clipCount} Clips';
  }

  String _createId(int number) =>
      'episode_${number}_${DateTime.now().microsecondsSinceEpoch}';

  void _setBusy(bool value) {
    if (_isBusy == value) return;
    _isBusy = value;
    notifyListeners();
  }
}
