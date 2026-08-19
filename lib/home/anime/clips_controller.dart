import 'package:flutter/foundation.dart';

class ClipModel {
  ClipModel({
    required this.id,
    required this.number,
    required this.name,
    this.durationSeconds = 120,
    this.frameCount = 1440,
  });

  final String id;
  int number;
  String name;
  int durationSeconds;
  int frameCount;

  ClipModel copyWith({
    String? id,
    int? number,
    String? name,
    int? durationSeconds,
    int? frameCount,
  }) {
    return ClipModel(
      id: id ?? this.id,
      number: number ?? this.number,
      name: name ?? this.name,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      frameCount: frameCount ?? this.frameCount,
    );
  }

  String get durationLabel {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get frameLabel => '$frameCount Frames';
  String get metadataLabel => '$durationLabel • $frameLabel';
}

class ClipsController extends ChangeNotifier {
  ClipsController({List<ClipModel>? initialClips})
      : _clips = initialClips ??
            [
              ClipModel(
                id: 'clip_1',
                number: 1,
                name: 'Opening Scene',
                durationSeconds: 120,
                frameCount: 1440,
              ),
              ClipModel(
                id: 'clip_2',
                number: 2,
                name: 'Protagonist Introduction',
                durationSeconds: 75,
                frameCount: 900,
              ),
              ClipModel(
                id: 'clip_3',
                number: 3,
                name: 'City Establishing Shot',
                durationSeconds: 30,
                frameCount: 360,
              ),
              ClipModel(
                id: 'clip_4',
                number: 4,
                name: 'Action Sequence 1',
                durationSeconds: 225,
                frameCount: 2700,
              ),
              ClipModel(
                id: 'clip_5',
                number: 5,
                name: 'Dialogue: Rivals',
                durationSeconds: 140,
                frameCount: 1680,
              ),
            ];

  final List<ClipModel> _clips;
  bool _isBusy = false;

  List<ClipModel> get clips => List.unmodifiable(_clips);
  bool get isBusy => _isBusy;
  int get clipCount => _clips.length;

  int get nextClipNumber {
    if (_clips.isEmpty) return 1;
    return _clips.map((clip) => clip.number).reduce((a, b) => a > b ? a : b) + 1;
  }

  ClipModel? findClip(String id) {
    for (final clip in _clips) {
      if (clip.id == id) return clip;
    }
    return null;
  }

  Future<ClipModel> createClip({
    String? name,
    int durationSeconds = 120,
    int? frameCount,
  }) async {
    _setBusy(true);

    try {
      final number = nextClipNumber;
      final normalizedDuration = durationSeconds < 1 ? 1 : durationSeconds;
      final normalizedFrames = frameCount ?? (normalizedDuration * 12);
      final trimmedName = name?.trim() ?? '';

      final clip = ClipModel(
        id: _createId(number),
        number: number,
        name: trimmedName.isEmpty ? 'Clip $number' : trimmedName,
        durationSeconds: normalizedDuration,
        frameCount: normalizedFrames < 1 ? 1 : normalizedFrames,
      );

      _clips.add(clip);
      _renumberByPosition();
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
    if (clip == null) return false;

    final trimmed = newName.trim();
    clip.name = trimmed.isEmpty ? 'Clip ${clip.number}' : trimmed;
    notifyListeners();
    return true;
  }

  Future<bool> deleteClip(String clipId) async {
    _setBusy(true);

    try {
      final index = _clips.indexWhere((clip) => clip.id == clipId);
      if (index == -1) return false;

      _clips.removeAt(index);
      _renumberByPosition();
      notifyListeners();
      return true;
    } finally {
      _setBusy(false);
    }
  }

  void reorderClip({required int oldIndex, required int newIndex}) {
    if (oldIndex < 0 || oldIndex >= _clips.length) return;
    if (newIndex < 0 || newIndex > _clips.length) return;
    if (oldIndex == newIndex || oldIndex + 1 == newIndex) return;

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final clip = _clips.removeAt(oldIndex);
    _clips.insert(newIndex, clip);
    _renumberByPosition();
    notifyListeners();
  }

  void updateClipTiming({
    required String clipId,
    required int durationSeconds,
    int? frameCount,
  }) {
    final clip = findClip(clipId);
    if (clip == null) return;

    clip.durationSeconds = durationSeconds < 1 ? 1 : durationSeconds;
    clip.frameCount = frameCount ?? (clip.durationSeconds * 12);
    if (clip.frameCount < 1) clip.frameCount = 1;
    notifyListeners();
  }

  void _renumberByPosition() {
    for (var i = 0; i < _clips.length; i++) {
      _clips[i].number = i + 1;
      if (_clips[i].name.trim().isEmpty || RegExp(r'^Clip \d+$').hasMatch(_clips[i].name.trim())) {
        _clips[i].name = 'Clip ${i + 1}';
      }
    }
  }

  String _createId(int number) {
    return 'clip_${number}_${DateTime.now().microsecondsSinceEpoch}';
  }

  void _setBusy(bool value) {
    if (_isBusy == value) return;
    _isBusy = value;
    notifyListeners();
  }
}
