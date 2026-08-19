import 'package:flutter/foundation.dart';

class SeasonModel {
  SeasonModel({
    required this.id,
    required this.number,
    required this.name,
    this.episodeCount = 0,
  });

  final String id;
  final int number;
  String name;
  int episodeCount;

  String get displayName {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'Season $number';

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
    int? episodeCount,
  }) {
    return SeasonModel(
      id: id ?? this.id,
      number: number ?? this.number,
      name: name ?? this.name,
      episodeCount: episodeCount ?? this.episodeCount,
    );
  }
}

class SeasonsController extends ChangeNotifier {
  SeasonsController({
  List<SeasonModel>? initialSeasons,
}) : _seasons = initialSeasons ?? [];

  final List<SeasonModel> _seasons;
  bool _isBusy = false;

  List<SeasonModel> get seasons => List.unmodifiable(_seasons);
  bool get isBusy => _isBusy;

  int get nextSeasonNumber {
    if (_seasons.isEmpty) return 1;
    return _seasons
            .map((season) => season.number)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }

  SeasonModel? findSeason(String id) {
    for (final season in _seasons) {
      if (season.id == id) return season;
    }
    return null;
  }

  Future<SeasonModel> createSeason({
    String? name,
    int episodeCount = 0,
  }) async {
    _setBusy(true);
    try {
      final number = nextSeasonNumber;
      final input = name?.trim() ?? '';
      final cleaned = _stripSeasonPrefix(input);

      final season = SeasonModel(
        id: _createId(number),
        number: number,
        name: cleaned.isEmpty ? 'Season $number' : cleaned,
        episodeCount: episodeCount < 0 ? 0 : episodeCount,
      );

      _seasons.add(season);
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
    if (season == null) return false;

    final cleaned = _stripSeasonPrefix(newName.trim());
    season.name = cleaned.isEmpty
        ? 'Season ${season.number}'
        : cleaned;

    notifyListeners();
    return true;
  }

  Future<bool> deleteSeason(String seasonId) async {
    _setBusy(true);
    try {
      final index = _seasons.indexWhere((season) => season.id == seasonId);
      if (index == -1) return false;

      _seasons.removeAt(index);
      notifyListeners();
      return true;
    } finally {
      _setBusy(false);
    }
  }

  void updateEpisodeCount({
    required String seasonId,
    required int episodeCount,
  }) {
    final season = findSeason(seasonId);
    if (season == null) return;

    season.episodeCount = episodeCount < 0 ? 0 : episodeCount;
    notifyListeners();
  }

  String getEpisodeLabel(SeasonModel season) {
    if (season.episodeCount == 1) return '1 Episode';
    return '${season.episodeCount} Episodes';
  }

  String _stripSeasonPrefix(String value) {
    if (value.isEmpty) return '';
    return value
        .replaceFirst(
          RegExp(r'^season\s+\d+\s*:?\s*', caseSensitive: false),
          '',
        )
        .trim();
  }

  String _createId(int number) {
    return 'season_${number}_${DateTime.now().microsecondsSinceEpoch}';
  }

  void _setBusy(bool value) {
    if (_isBusy == value) return;
    _isBusy = value;
    notifyListeners();
  }
}
