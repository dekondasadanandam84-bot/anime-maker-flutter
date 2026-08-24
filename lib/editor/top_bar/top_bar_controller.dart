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

  bool get isAudioEnabled => _isAudioEnabled;
  bool get canUndo => _canUndo;
  bool get canRedo => _canRedo;

  void toggleAudio() {
    _isAudioEnabled = !_isAudioEnabled;
    notifyListeners();
  }

  void copy() {
    // Top-bar copy action.
    // Actual editor selection/clipboard logic will be coordinated
    // by EditorController later.
  }

  void paste() {
    // Top-bar paste action.
  }

  void duplicate() {
    // Top-bar duplicate action.
  }

  void undo() {
    if (!_canUndo) return;

    // Actual undo operation will be coordinated
    // by EditorController later.

    notifyListeners();
  }

  void redo() {
    if (!_canRedo) return;

    // Actual redo operation will be coordinated
    // by EditorController later.

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

  void diamondAction() {
    // Reserved for the diamond button.
    // Behavior can be connected later.
  }

  void moreAction() {
    // Reserved for the three-dot button.
    // Its purpose will be added later.
  }

  void fitToScreen() {
  // Fit-to-screen update will be implemented later.
}

void hidePanels() {
  // Hide-panels update will be implemented later.
}
}