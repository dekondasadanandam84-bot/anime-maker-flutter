import 'package:flutter/foundation.dart';

import '../models/anime_series_model.dart';
import '../models/season_model.dart';

class SeasonsController extends ChangeNotifier {
  SeasonsController({
    required this._series,
  });

  AnimeSeriesModel _series;

  bool _isBusy = false;

  AnimeSeriesModel get series => _series;

  List<SeasonModel> get seasons =>
      List.unmodifiable(_series.seasons);

  bool get isBusy => _isBusy;

  int get nextSeasonNumber {
    if (_series.seasons.isEmpty) {
      return 1;
    }

    return _series.seasons
            .map((season) => season.number)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }

  SeasonModel? findSeason(String id) {
    for (final season in _series.seasons) {
      if (season.id == id) {
        return season;
      }
    }

    return null;
  }

  Future<SeasonModel> createSeason({
  String? name,
}) async {
  _setBusy(true);

  try {
    final number = nextSeasonNumber;

    final input = name?.trim() ?? '';
    final cleaned = _stripSeasonPrefix(input);

    final season = SeasonModel(
      id: _createId(number),
      number: number,
      name: cleaned.isEmpty
          ? 'Season $number'
          : cleaned,
      episodes: const [],
    );

    _series = _series.copyWith(
      seasons: [
        ..._series.seasons,
        season,
      ],
    );

    notifyListeners();

    return season;
  } finally {
    _setBusy(false);
  }
}

  Future<bool> renameSeason({
    required String seasonId,
    required String newName,
  }) async {
    final season = findSeason(seasonId);

    if (season == null) {
      return false;
    }

    final cleaned = _stripSeasonPrefix(
      newName.trim(),
    );

    final updatedSeason = season.copyWith(
      name: cleaned.isEmpty
          ? 'Season ${season.number}'
          : cleaned,
    );

    final updatedSeasons = _series.seasons.map((item) {
      if (item.id == seasonId) {
        return updatedSeason;
      }

      return item;
    }).toList();

    _series = _series.copyWith(
      seasons: updatedSeasons,
    );

    notifyListeners();

    return true;
  }

  Future<bool> deleteSeason(String seasonId) async {
    _setBusy(true);

    try {
      final exists = _series.seasons.any(
        (season) => season.id == seasonId,
      );

      if (!exists) {
        return false;
      }

      final updatedSeasons = _series.seasons
          .where((season) => season.id != seasonId)
          .toList();

      _series = _series.copyWith(
        seasons: updatedSeasons,
      );

      notifyListeners();

      return true;
    } finally {
      _setBusy(false);
    }
  }

  

  String getEpisodeLabel(SeasonModel season) {
    if (season.episodeCount == 1) {
      return '1 Episode';
    }

    return '${season.episodeCount} Episodes';
  }

  String _stripSeasonPrefix(String value) {
    if (value.isEmpty) {
      return '';
    }

    return value
        .replaceFirst(
          RegExp(
            r'^season\s+\d+\s*:?\s*',
            caseSensitive: false,
          ),
          '',
        )
        .trim();
  }

  String _createId(int number) {
    return 'season_${number}_${DateTime.now().microsecondsSinceEpoch}';
  }

  void _setBusy(bool value) {
    if (_isBusy == value) {
      return;
    }

    _isBusy = value;
    notifyListeners();
  }
}