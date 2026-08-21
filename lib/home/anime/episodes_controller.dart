import 'package:flutter/foundation.dart';

import '../models/episode_model.dart';
import '../models/season_model.dart';

class EpisodesController extends ChangeNotifier {
  EpisodesController({
    required this._season,
  });

  SeasonModel _season;

  bool _isBusy = false;

  SeasonModel get season => _season;

  List<EpisodeModel> get episodes =>
      List.unmodifiable(_season.episodes);

  bool get isBusy => _isBusy;

  int get nextEpisodeNumber {
    if (_season.episodes.isEmpty) {
      return 1;
    }

    return _season.episodes
            .map((episode) => episode.episodeNumber)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }

  EpisodeModel? findEpisode(String id) {
    for (final episode in _season.episodes) {
      if (episode.id == id) {
        return episode;
      }
    }

    return null;
  }

  Future<EpisodeModel> createEpisode({
    String? name,
  }) async {
    _setBusy(true);

    try {
      final number = nextEpisodeNumber;
      final cleaned = name?.trim() ?? '';

      final episode = EpisodeModel(
        id: _createId(number),
        name: cleaned.isEmpty
            ? 'Episode $number'
            : cleaned,
        episodeNumber: number,
        clips: const [],
      );

      _season = _season.copyWith(
        episodes: [
          ..._season.episodes,
          episode,
        ],
      );

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

    if (episode == null) {
      return false;
    }

    final cleaned = newName.trim();

    final updatedEpisode = episode.copyWith(
      name: cleaned.isEmpty
          ? 'Episode ${episode.episodeNumber}'
          : cleaned,
    );

    final updatedEpisodes =
        _season.episodes.map((item) {
      if (item.id == episodeId) {
        return updatedEpisode;
      }

      return item;
    }).toList();

    _season = _season.copyWith(
      episodes: updatedEpisodes,
    );

    notifyListeners();

    return true;
  }

  Future<bool> deleteEpisode(String episodeId) async {
    _setBusy(true);

    try {
      final exists = _season.episodes.any(
        (episode) => episode.id == episodeId,
      );

      if (!exists) {
        return false;
      }

      final updatedEpisodes =
          _season.episodes
              .where((episode) => episode.id != episodeId)
              .toList();

      _season = _season.copyWith(
        episodes: updatedEpisodes,
      );

      notifyListeners();

      return true;
    } finally {
      _setBusy(false);
    }
  }

  String getClipLabel(EpisodeModel episode) {
    if (episode.clipCount == 1) {
      return '1 Clip';
    }

    return '${episode.clipCount} Clips';
  }

  String _createId(int number) {
    return 'episode_${number}_'
        '${DateTime.now().microsecondsSinceEpoch}';
  }

  void _setBusy(bool value) {
    if (_isBusy == value) {
      return;
    }

    _isBusy = value;
    notifyListeners();
  }
}