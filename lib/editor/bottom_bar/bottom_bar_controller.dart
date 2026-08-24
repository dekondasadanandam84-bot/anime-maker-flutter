import 'package:flutter/foundation.dart';

class BottomBarController extends ChangeNotifier {
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
    if (!_isPlaying) return;

    _isPlaying = false;
    notifyListeners();
  }

  // ============================================================
  // FRAMES
  // ============================================================

  final List<int> _frames = [1];

  int _selectedFrame = 1;

  List<int> get frames => List.unmodifiable(_frames);

  int get selectedFrame => _selectedFrame;

  // ============================================================
  // ADD FRAME
  // ============================================================

  void addFrame() {
    final int nextFrame = _frames.length + 1;

    _frames.add(nextFrame);
    _selectedFrame = nextFrame;

    notifyListeners();
  }

  // ============================================================
  // SELECT FRAME
  // ============================================================

  void selectFrame(int frame) {
    if (!_frames.contains(frame)) return;

    _selectedFrame = frame;

    notifyListeners();
  }

  // ============================================================
  // PREVIOUS FRAME
  // ============================================================

  void previousFrame() {
    final int currentIndex =
        _frames.indexOf(_selectedFrame);

    if (currentIndex <= 0) return;

    _selectedFrame = _frames[currentIndex - 1];

    notifyListeners();
  }

  // ============================================================
  // NEXT FRAME
  // ============================================================

  void nextFrame() {
    final int currentIndex =
        _frames.indexOf(_selectedFrame);

    if (currentIndex < 0 ||
        currentIndex >= _frames.length - 1) {
      return;
    }

    _selectedFrame = _frames[currentIndex + 1];

    notifyListeners();
  }

  // ============================================================
  // RESET
  // ============================================================

  void reset() {
    _isPlaying = false;

    _frames
      ..clear()
      ..add(1);

    _selectedFrame = 1;

    notifyListeners();
  }
}