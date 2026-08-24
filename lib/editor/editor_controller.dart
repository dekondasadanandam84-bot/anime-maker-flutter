import 'package:flutter/foundation.dart';

import 'left_panel/left_panel_controller.dart';
import 'top_bar/top_bar_controller.dart';
import 'bottom_bar/bottom_bar_controller.dart';

class EditorController extends ChangeNotifier {
  EditorController({
  required this.clipId,
  required this.clipName,
})  : topBarController = TopBarController(
      clipId: clipId,
      clipName: clipName,
    ),
    leftPanelController = LeftPanelController(),
    bottomBarController = BottomBarController();

  final String clipId;
  final String clipName;

  final TopBarController topBarController;
  final LeftPanelController leftPanelController;
  final BottomBarController bottomBarController;

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
  // Save
  // ------------------------------------------------------------

  Future<void> save() async {
    if (_isSaving) return;

    _isSaving = true;
    notifyListeners();

    try {
      // Save logic will be added later.
      await Future<void>.delayed(
        const Duration(milliseconds: 500),
      );
    } finally {
      _isSaving = false;
      notifyListeners();
    }
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

  void onAddFramePressed() {
    bottomBarController.addFrame();
  }

  void onFrameSelected(int frame) {
    bottomBarController.selectFrame(frame);
  }

  @override
void dispose() {
  leftPanelController.dispose();
  topBarController.dispose();
  bottomBarController.dispose();
  super.dispose();
}
}