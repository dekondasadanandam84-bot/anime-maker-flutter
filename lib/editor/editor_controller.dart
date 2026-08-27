import 'package:flutter/foundation.dart';

import 'left_panel/left_panel_controller.dart';
import 'top_bar/top_bar_controller.dart';
import 'bottom_bar/bottom_bar_controller.dart';
import 'middle/middle_controller.dart';

class EditorController extends ChangeNotifier {
  EditorController({
    required this.clipId,
    required this.clipName,
    required double aspectRatio,
    required String resolution,
    required this._fps,
  })  : _aspectRatio = aspectRatio,
        _resolution = resolution,
        topBarController = TopBarController(
          clipId: clipId,
          clipName: clipName,
        ),
        leftPanelController = LeftPanelController(),
        bottomBarController = BottomBarController(),
        middleController = MiddleController(
          aspectRatio: aspectRatio,
          resolution: resolution,
        );

  final String clipId;
  final String clipName;

  // ------------------------------------------------------------
  // Project settings
  // ------------------------------------------------------------

  double _aspectRatio;
  String _resolution;
  double _fps;

  double get aspectRatio => _aspectRatio;
  String get resolution => _resolution;
  double get fps => _fps;

  // ------------------------------------------------------------
  // Controllers
  // ------------------------------------------------------------

  final TopBarController topBarController;
  final LeftPanelController leftPanelController;
  final BottomBarController bottomBarController;
  final MiddleController middleController;

  // ------------------------------------------------------------
  // Saving
  // ------------------------------------------------------------

  bool _isSaving = false;

  bool get isSaving => _isSaving;

  // ------------------------------------------------------------
  // Top bar update receivers
  // ------------------------------------------------------------

  void onDiamondPressed() {
    topBarController.diamondAction();
  }

  void onAudioPressed() {
    topBarController.toggleAudio();
  }

  void onCopyPressed() {
    topBarController.copy();
  }

  void onPastePressed() {
    topBarController.paste();
  }

  void onDuplicatePressed() {
    topBarController.duplicate();
  }

  void onUndoPressed() {
    topBarController.undo();
  }

  void onRedoPressed() {
    topBarController.redo();
  }

  void onMorePressed() {
    topBarController.moreAction();
  }

  void onFitToScreen() {
    topBarController.fitToScreen();
  }

  void onHidePanels() {
    topBarController.hidePanels();
  }

  // ------------------------------------------------------------
  // Left panel update receivers
  // ------------------------------------------------------------

  void onLeftToolSelected(int toolId) {
    leftPanelController.selectTool(toolId);
  }

  void onLeftMorePressed() {
    leftPanelController.toggleMoreTools();
  }

  // ------------------------------------------------------------
  // Bottom bar update receivers
  // ------------------------------------------------------------

  void onPlayPausePressed() {
    bottomBarController.togglePlayback();
  }

  void onPreviousFramePressed() {
    bottomBarController.previousFrame();
  }

  void onNextFramePressed() {
    bottomBarController.nextFrame();
  }

  void onAddFramesPressed(int count) {
    bottomBarController.addFrames(count);
  }

  void onFrameSelected(int frame) {
    bottomBarController.selectFrame(frame);
  }

  // ------------------------------------------------------------
  // Project settings
  // ------------------------------------------------------------

  void updateProjectSettings({
    required double aspectRatio,
    required String resolution,
    required double fps,
  }) {
    _aspectRatio = aspectRatio;
    _resolution = resolution;
    _fps = fps;

    middleController.updateCanvasSettings(
      aspectRatio: aspectRatio,
      resolution: resolution,
    );

    notifyListeners();
  }

  // ------------------------------------------------------------
  // Save
  // ------------------------------------------------------------

  Future<void> save() async {
    if (_isSaving) return;

    _isSaving = true;
    notifyListeners();

    try {
      await Future<void>.delayed(
        const Duration(milliseconds: 500),
      );
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // ------------------------------------------------------------
  // Dispose
  // ------------------------------------------------------------

  @override
  void dispose() {
    leftPanelController.dispose();
    topBarController.dispose();
    bottomBarController.dispose();
    middleController.dispose();
    super.dispose();
  }
}