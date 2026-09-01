
import 'package:flutter/foundation.dart';

import '../../home/project_controller.dart';

class BottomBarController extends ChangeNotifier {
  BottomBarController({
    required this.projectController,
    required this.clipId,
  }) {
    projectController.addListener(
      _onProjectChanged,
    );
  }

  // ============================================================
  // PROJECT CONTEXT
  // ============================================================

  final ProjectController projectController;
  final String clipId;

  // ============================================================
  // PLAYBACK
  // ============================================================

  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  void togglePlayback() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void stopPlayback() {
    if (!_isPlaying) {
      return;
    }

    _isPlaying = false;
    notifyListeners();
  }

  // ============================================================
  // FRAMES
  // ============================================================
  //
  // The editor starts with ONE frame only.
  // The + box is handled by the UI.
  // ============================================================

  List<int> _frames = <int>[1];

  int _selectedFrame = 1;

  // ============================================================
  // CLIPBOARD
  // ============================================================

  int _clipboardCount = 0;

  // ============================================================
  // GETTERS
  // ============================================================

  List<int> get frames =>
      List.unmodifiable(_frames);

  int get selectedFrame =>
      _selectedFrame;

  int get frameCount =>
      _frames.length;

  bool get canPaste =>
      _clipboardCount > 0;

  int get clipboardCount =>
      _clipboardCount;

  // ============================================================
  // ADD MULTIPLE FRAMES
  // ============================================================

  void addFrames(int count) {
    if (count <= 0) {
      return;
    }

    final currentIndex =
        _frames.indexOf(_selectedFrame);

    final insertionIndex =
        currentIndex < 0
            ? _frames.length
            : currentIndex + 1;

    _insertFrames(
      insertionIndex: insertionIndex,
      count: count,
    );
  }

  // ============================================================
  // ADD FRAME BEFORE
  // ============================================================

  void addFrameBefore() {
    final currentIndex =
        _frames.indexOf(_selectedFrame);

    if (currentIndex < 0) {
      return;
    }

    _insertFrames(
      insertionIndex: currentIndex,
      count: 1,
    );
  }

  // ============================================================
  // ADD FRAME AFTER
  // ============================================================

  void addFrameAfter() {
    final currentIndex =
        _frames.indexOf(_selectedFrame);

    if (currentIndex < 0) {
      return;
    }

    _insertFrames(
      insertionIndex: currentIndex + 1,
      count: 1,
    );
  }

  // ============================================================
  // INTERNAL INSERT
  // ============================================================

  void _insertFrames({
    required int insertionIndex,
    required int count,
  }) {
    if (count <= 0) {
      return;
    }

    final safeIndex = insertionIndex.clamp(
      0,
      _frames.length,
    );

    final newCount =
        _frames.length + count;

    _frames = List<int>.generate(
      newCount,
      (index) => index + 1,
    );

    _selectedFrame =
        safeIndex + 1;

    _persistFrameCount();

    notifyListeners();
  }

  // ============================================================
  // SELECT FRAME
  // ============================================================

  void selectFrame(int frame) {
    if (!_frames.contains(frame)) {
      return;
    }

    if (_selectedFrame == frame) {
      return;
    }

    _selectedFrame = frame;

    notifyListeners();
  }

  // ============================================================
  // PREVIOUS FRAME
  // ============================================================

  void previousFrame() {
    final currentIndex =
        _frames.indexOf(_selectedFrame);

    if (currentIndex <= 0) {
      return;
    }

    _selectedFrame =
        _frames[currentIndex - 1];

    notifyListeners();
  }

  // ============================================================
  // NEXT FRAME
  // ============================================================

  void nextFrame() {
    final currentIndex =
        _frames.indexOf(_selectedFrame);

    if (currentIndex < 0 ||
        currentIndex >= _frames.length - 1) {
      return;
    }

    _selectedFrame =
        _frames[currentIndex + 1];

    notifyListeners();
  }

  // ============================================================
  // COPY
  // ============================================================

  void copyFrames(
    Iterable<int> frameNumbers,
  ) {
    final validFrames = frameNumbers
        .where(_frames.contains)
        .toSet()
        .toList();

    if (validFrames.isEmpty) {
      return;
    }

    _clipboardCount =
        validFrames.length;

    notifyListeners();
  }

  // ============================================================
  // PASTE
  // ============================================================

  void pasteFrames() {
    if (_clipboardCount <= 0) {
      return;
    }

    final currentIndex =
        _frames.indexOf(_selectedFrame);

    if (currentIndex < 0) {
      return;
    }

    _insertFrames(
      insertionIndex: currentIndex + 1,
      count: _clipboardCount,
    );
  }

  // ============================================================
  // DUPLICATE
  // ============================================================

  void duplicateFrames(
    Iterable<int> frameNumbers,
  ) {
    final validFrames = frameNumbers
        .where(_frames.contains)
        .toSet()
        .toList()
      ..sort();

    if (validFrames.isEmpty) {
      return;
    }

    final lastFrame =
        validFrames.last;

    final lastIndex =
        _frames.indexOf(lastFrame);

    if (lastIndex < 0) {
      return;
    }

    _insertFrames(
      insertionIndex: lastIndex + 1,
      count: validFrames.length,
    );
  }

  // ============================================================
  // ERASE
  // ============================================================

  void eraseFrames(
    Iterable<int> frameNumbers,
  ) {
    final validFrames = frameNumbers
        .where(_frames.contains)
        .toSet()
        .toList()
      ..sort();

    if (validFrames.isEmpty) {
      return;
    }

    // Always keep at least one frame.
    if (_frames.length == 1) {
      return;
    }

    final firstRemovedIndex =
        _frames.indexOf(
      validFrames.first,
    );

    _frames.removeWhere(
      validFrames.contains,
    );

    _frames = List<int>.generate(
      _frames.length,
      (index) => index + 1,
    );

    final targetIndex =
        firstRemovedIndex.clamp(
      0,
      _frames.length - 1,
    );

    _selectedFrame =
        _frames[targetIndex];

    _persistFrameCount();

    notifyListeners();
  }

  // ============================================================
  // RESET
  // ============================================================

  void reset() {
    _isPlaying = false;
    _clipboardCount = 0;

    _frames = <int>[1];
    _selectedFrame = 1;

    _persistFrameCount();

    notifyListeners();
  }

  // ============================================================
  // PERSIST FRAME COUNT
  // ============================================================

  void _persistFrameCount() {
    projectController.updateClipFrameCount(
      clipId: clipId,
      frameCount: _frames.length,
    );
  }

  // ============================================================
  // PROJECT CHANGES
  // ============================================================

  void _onProjectChanged() {
    // Do not rebuild the frame list here.
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

