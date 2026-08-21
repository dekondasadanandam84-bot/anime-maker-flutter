import 'package:flutter/foundation.dart';

import '../models/anime_movie_model.dart';
import '../models/clip_model.dart';

class MovieClipsController extends ChangeNotifier {
  MovieClipsController({
    required this._movie,
    required this.fps,
  });

  AnimeMovieModel _movie;
  final int fps;

  bool _isBusy = false;

  AnimeMovieModel get movie => _movie;

  List<ClipModel> get clips =>
      List.unmodifiable(_movie.clips);

  bool get isBusy => _isBusy;

  int get clipCount => _movie.clips.length;

  int get nextClipNumber {
    if (_movie.clips.isEmpty) {
      return 1;
    }

    return _movie.clips
            .map((clip) => clip.number)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }

  ClipModel? findClip(String id) {
    for (final clip in _movie.clips) {
      if (clip.id == id) {
        return clip;
      }
    }

    return null;
  }

  Future<ClipModel> createClip({
    String? name,
  }) async {
    _setBusy(true);

    try {
      final number = nextClipNumber;

      const int durationSeconds = 60;
      final int frameCount = durationSeconds * fps;

      final trimmedName = name?.trim() ?? '';

      final clip = ClipModel(
        id: _createId(number),
        number: number,
        name: trimmedName.isEmpty
            ? 'Clip $number'
            : trimmedName,
        durationSeconds: durationSeconds,
        frameCount: frameCount,
      );

      _movie = _movie.copyWith(
        clips: [
          ..._movie.clips,
          clip,
        ],
      );

      notifyListeners();

      return clip;
    } finally {
      _setBusy(false);
    }
  }

  Future<bool> renameClip({
    required String clipId,
    required String newName,
  }) async {
    final clip = findClip(clipId);

    if (clip == null) {
      return false;
    }

    final trimmed = newName.trim();

    final updatedClip = clip.copyWith(
      name: trimmed.isEmpty
          ? 'Clip ${clip.number}'
          : trimmed,
    );

    final updatedClips = _movie.clips.map((item) {
      if (item.id == clipId) {
        return updatedClip;
      }

      return item;
    }).toList();

    _movie = _movie.copyWith(
      clips: updatedClips,
    );

    notifyListeners();

    return true;
  }

  Future<bool> deleteClip(String clipId) async {
    _setBusy(true);

    try {
      final exists = _movie.clips.any(
        (clip) => clip.id == clipId,
      );

      if (!exists) {
        return false;
      }

      final updatedClips = _movie.clips
          .where((clip) => clip.id != clipId)
          .toList();

      _movie = _movie.copyWith(
        clips: updatedClips,
      );

      notifyListeners();

      return true;
    } finally {
      _setBusy(false);
    }
  }

  void reorderClip({
    required int oldIndex,
    required int newIndex,
  }) {
    if (oldIndex < 0 ||
        oldIndex >= _movie.clips.length) {
      return;
    }

    if (newIndex < 0 ||
        newIndex > _movie.clips.length) {
      return;
    }

    if (oldIndex == newIndex ||
        oldIndex + 1 == newIndex) {
      return;
    }

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final updatedClips =
        List<ClipModel>.from(_movie.clips);

    final clip = updatedClips.removeAt(oldIndex);
    updatedClips.insert(newIndex, clip);

    final renumbered = <ClipModel>[];

    for (int i = 0; i < updatedClips.length; i++) {
      renumbered.add(
        updatedClips[i].copyWith(
          number: i + 1,
        ),
      );
    }

    _movie = _movie.copyWith(
      clips: renumbered,
    );

    notifyListeners();
  }

  void updateClipTiming({
    required String clipId,
    required int durationSeconds,
  }) {
    final clip = findClip(clipId);

    if (clip == null) {
      return;
    }

    final safeDuration =
        durationSeconds.clamp(1, 60);

    final updatedClip = clip.copyWith(
      durationSeconds: safeDuration,
      frameCount: safeDuration * fps,
    );

    _movie = _movie.copyWith(
      clips: _movie.clips.map((item) {
        if (item.id == clipId) {
          return updatedClip;
        }

        return item;
      }).toList(),
    );

    notifyListeners();
  }

  String _createId(int number) {
    return 'movie_clip_${number}_'
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