import 'package:flutter/foundation.dart';

class TopBarController extends ChangeNotifier {
  TopBarController({
    required this.clipId,
    required this.clipName,
  });

  final String clipId;
  final String clipName;

  bool _isAudioEnabled = true;
  bool _canUndo = false;
  bool _canRedo = false;
  bool _panelsHidden = false;

  bool get isAudioEnabled => _isAudioEnabled;
  bool get canUndo => _canUndo;
  bool get canRedo => _canRedo;

  bool get panelsHidden => _panelsHidden;

  void hidePanels() {
  _panelsHidden = !_panelsHidden;
  notifyListeners();
}

  // ============================================================
  // AUDIO
  // ============================================================

  void toggleAudio() {
    _isAudioEnabled = !_isAudioEnabled;
    notifyListeners();
  }

  // ============================================================
  // COPY / PASTE / DUPLICATE
  // ============================================================

  void copy() {
    // Actual editor clipboard logic later.
  }

  void paste() {
    // Actual editor clipboard logic later.
  }

  void duplicate() {
    // Actual duplicate logic later.
  }

  // ============================================================
  // UNDO / REDO
  // ============================================================

  void undo() {
    if (!_canUndo) return;

    // Actual undo logic later.

    notifyListeners();
  }

  void redo() {
    if (!_canRedo) return;

    // Actual redo logic later.

    notifyListeners();
  }

  void setUndoAvailable(bool value) {
    if (_canUndo == value) return;

    _canUndo = value;
    notifyListeners();
  }

  void setRedoAvailable(bool value) {
    if (_canRedo == value) return;

    _canRedo = value;
    notifyListeners();
  }

  // ============================================================
  // OTHER ACTIONS
  // ============================================================

  void diamondAction() {
    // Reserved for later.
  }

  void moreAction() {
    // Reserved for later.
  }

  void fitToScreen() {
    // Fit-to-screen later.
  }

  // ============================================================
  // HIDE / SHOW CONTROLS
  // ============================================================

  

  // ============================================================
  // RESET
  // ============================================================

  void reset() {
    _panelsHidden = false;
    _isAudioEnabled = true;
    _canUndo = false;
    _canRedo = false;

    notifyListeners();
  }
}