import 'package:flutter/foundation.dart';

import '../models/clip_model.dart';
import '../project_controller.dart';

class MovieClipsController extends ChangeNotifier {
  MovieClipsController({
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
  // CURRENT MOVIE CLIPS
  // ============================================================
  //
  // Movie/project data always comes from ProjectController.
  // No AnimeMovieModel copy and no FPS copy are stored here.
  // ============================================================

  List<ClipModel> get clips =>
      projectController.currentClips;

  int get clipCount => clips.length;

  int get nextClipNumber {
    if (clips.isEmpty) {
      return 1;
    }

    return clips
            .map((clip) => clip.number)
            .reduce(
              (a, b) => a > b ? a : b,
            ) +
        1;
  }

  ClipModel? findClip(
    String id,
  ) {
    return projectController.findCurrentClipById(
      id,
    );
  }

  // ============================================================
  // CREATE CLIP
  // ============================================================

  Future<ClipModel?> createClip({
    String? name,
  }) async {
    _setBusy(true);

    try {
      return projectController.createCurrentClip(
        name: name,
      );
    } finally {
      _setBusy(false);
    }
  }

  // ============================================================
  // RENAME CLIP
  // ============================================================

  Future<bool> renameClip({
    required String clipId,
    required String newName,
  }) async {
    _setBusy(true);

    try {
      return projectController.renameClip(
        clipId: clipId,
        newName: newName,
      );
    } finally {
      _setBusy(false);
    }
  }

  // ============================================================
  // DELETE CLIP
  // ============================================================

  Future<bool> deleteClip(
    String clipId,
  ) async {
    _setBusy(true);

    try {
      return projectController.deleteClip(
        clipId,
      );
    } finally {
      _setBusy(false);
    }
  }

  // ============================================================
  // REORDER CLIPS
  // ============================================================

  void reorderClip({
    required int oldIndex,
    required int newIndex,
  }) {
    projectController.reorderCurrentClips(
      oldIndex: oldIndex,
      newIndex: newIndex,
    );
  }

  // ============================================================
  // UPDATE CLIP TIMING
  // ============================================================

  void updateClipTiming({
    required String clipId,
    required int durationSeconds,
  }) {
    projectController.updateClipTiming(
      clipId: clipId,
      durationSeconds: durationSeconds,
    );
  }

  // ============================================================
  // TEMPORARY BUSY STATE
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
  // Keep the adapter synchronized with the central controller
  // for any UI that listens to MovieClipsController.
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