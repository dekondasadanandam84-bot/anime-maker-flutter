import 'package:flutter/foundation.dart';

import '../project_controller.dart';
import '../models/season_model.dart';

class SeasonsController extends ChangeNotifier {
  SeasonsController({
    required this.projectController,
  }) {
    projectController.addListener(_onProjectChanged);
  }

  final ProjectController projectController;

  bool _isBusy = false;

  bool get isBusy => _isBusy;

  List<SeasonModel> get seasons =>
      projectController.currentSeasons;

  int get seasonCount => seasons.length;

  int get nextSeasonNumber {
    if (seasons.isEmpty) {
      return 1;
    }

    return seasons
            .map((season) => season.number)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }

  SeasonModel? findSeason(String id) {
    for (final season in seasons) {
      if (season.id == id) {
        return season;
      }
    }

    return null;
  }

  Future<SeasonModel?> createSeason({
    String? name,
  }) async {
    _setBusy(true);

    try {
      final season = projectController.createSeason(
        name: name,
      );

      return season;
    } finally {
      _setBusy(false);
    }
  }

  Future<bool> renameSeason({
    required String seasonId,
    required String newName,
  }) async {
    _setBusy(true);

    try {
      return projectController.renameSeason(
        seasonId: seasonId,
        newName: newName,
      );
    } finally {
      _setBusy(false);
    }
  }

  Future<bool> deleteSeason(
    String seasonId,
  ) async {
    _setBusy(true);

    try {
      return projectController.deleteSeason(
        seasonId,
      );
    } finally {
      _setBusy(false);
    }
  }

  String getEpisodeLabel(
    SeasonModel season,
  ) {
    if (season.episodeCount == 1) {
      return '1 Episode';
    }

    return '${season.episodeCount} Episodes';
  }

  void _setBusy(bool value) {
    if (_isBusy == value) {
      return;
    }

    _isBusy = value;
    notifyListeners();
  }

  void _onProjectChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    projectController.removeListener(_onProjectChanged);
    super.dispose();
  }
}