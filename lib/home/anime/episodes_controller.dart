
import 'package:flutter/foundation.dart';

import '../project_controller.dart';
import '../models/episode_model.dart';

class EpisodesController extends ChangeNotifier {
  EpisodesController({
    required this.projectController,
  }) {
    projectController.addListener(_onProjectChanged);
  }

  // ============================================================
  // SINGLE SOURCE OF TRUTH
  // ============================================================

  final ProjectController projectController;

  // ============================================================
  // TEMPORARY UI STATE
  // ============================================================

  bool _isBusy = false;

  bool get isBusy => _isBusy;

  // ============================================================
  // CURRENT EPISODES
  // ============================================================
  //
  // The episode data always comes from ProjectController.
  // No separate episode list is stored here.
  // ============================================================

  List<EpisodeModel> get episodes =>
      projectController.currentEpisodes;

  EpisodeModel? get currentEpisode =>
      projectController.currentEpisode;

  int get episodeCount => episodes.length;

  int get nextEpisodeNumber {
    if (episodes.isEmpty) {
      return 1;
    }

    return episodes
            .map(
              (episode) => episode.episodeNumber,
            )
            .reduce(
              (a, b) => a > b ? a : b,
            ) +
        1;
  }

  EpisodeModel? findEpisode(
    String id,
  ) {
    for (final episode in episodes) {
      if (episode.id == id) {
        return episode;
      }
    }

    return null;
  }

  // ============================================================
  // CREATE EPISODE
  // ============================================================

  Future<EpisodeModel?> createEpisode({
    String? name,
  }) async {
    _setBusy(true);

    try {
      return projectController.createEpisode(
        name: name,
      );
    } finally {
      _setBusy(false);
    }
  }

  // ============================================================
  // RENAME EPISODE
  // ============================================================

  Future<bool> renameEpisode({
    required String episodeId,
    required String newName,
  }) async {
    _setBusy(true);

    try {
      return projectController.renameEpisode(
        episodeId: episodeId,
        newName: newName,
      );
    } finally {
      _setBusy(false);
    }
  }

  // ============================================================
  // DELETE EPISODE
  // ============================================================

  Future<bool> deleteEpisode(
    String episodeId,
  ) async {
    _setBusy(true);

    try {
      return projectController.deleteEpisode(
        episodeId,
      );
    } finally {
      _setBusy(false);
    }
  }

  // ============================================================
  // CLIP LABEL
  // ============================================================

  String getClipLabel(
    EpisodeModel episode,
  ) {
    if (episode.clipCount == 1) {
      return '1 Clip';
    }

    return '${episode.clipCount} Clips';
  }

  // ============================================================
  // BUSY STATE
  // ============================================================

  void _setBusy(bool value) {
    if (_isBusy == value) {
      return;
    }

    _isBusy = value;
    notifyListeners();
  }

  // ============================================================
  // PROJECT CHANGES
  // ============================================================
  //
  // ProjectController remains the source of truth.
  // This forwarding notification keeps any existing UI that
  // listens to EpisodesController synchronized.
  // ============================================================

  void _onProjectChanged() {
    notifyListeners();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    projectController.removeListener(
      _onProjectChanged,
    );

    super.dispose();
  }
}

