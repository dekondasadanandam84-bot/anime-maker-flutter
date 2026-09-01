import 'package:flutter/foundation.dart';

import '../home/project_controller.dart';
import '../home/models/project_settings_model.dart';

import 'left_panel/left_panel_controller.dart';
import 'top_bar/top_bar_controller.dart';
import 'bottom_bar/bottom_bar_controller.dart';
import 'bottom_bar/frames_viewer_controller.dart';
import 'middle/middle_controller.dart';

class EditorController extends ChangeNotifier {
  EditorController({
    required this.projectController,
    required this.clipId,
  })  : topBarController = TopBarController(),
        leftPanelController = LeftPanelController(),
        bottomBarController = BottomBarController(
          projectController: projectController,
          clipId: clipId,
        ),
        middleController = MiddleController(
          aspectRatio: _aspectRatioValue(
            projectController.currentAspectRatio ??
                ProjectAspectRatio.ratio16x9,
          ),
          resolution:
              projectController.currentResolution ??
                  '1920 × 1080',
        ) {
    // ==========================================================
    // FRAMES VIEWER
    // ==========================================================
    //
    // Uses the SAME BottomBarController instance.
    // Therefore the floating frame strip and full-screen
    // Frames Viewer always share the same frame state.
    // ==========================================================

    framesViewerController = FramesViewerController(
      bottomBarController: bottomBarController,
    );

    projectController.addListener(
      _onProjectControllerChanged,
    );
  }

  // ============================================================
  // PROJECT CONTEXT
  // ============================================================

  final ProjectController projectController;

  final String clipId;

  // ============================================================
  // CURRENT PROJECT DATA
  // ============================================================

  ProjectSettingsModel? get settings =>
      projectController.currentSettings;

  double get aspectRatio {
    final ratio =
        projectController.currentAspectRatio;

    if (ratio == null) {
      return 16 / 9;
    }

    return _aspectRatioValue(ratio);
  }

  String get resolution =>
      projectController.currentResolution ??
      '1920 × 1080';

  double get fps =>
      projectController.currentFps ?? 12;

  String? get projectName =>
      projectController.currentProjectName;

  // ============================================================
  // CURRENT CLIP
  // ============================================================

  String? get currentClipName =>
      projectController
          .findCurrentClipById(clipId)
          ?.name;

  // ============================================================
  // EDITOR CONTROLLERS
  // ============================================================

  final TopBarController topBarController;

  final LeftPanelController leftPanelController;

  final BottomBarController bottomBarController;

  late final FramesViewerController framesViewerController;

  final MiddleController middleController;

  // ============================================================
  // SAVING
  // ============================================================

  bool _isSaving = false;

  bool get isSaving => _isSaving;

  // ============================================================
  // TOP BAR UPDATE RECEIVERS
  // ============================================================

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

  // ============================================================
  // LEFT PANEL UPDATE RECEIVERS
  // ============================================================

  void onLeftToolSelected(int toolId) {
    leftPanelController.selectTool(toolId);
  }

  void onLeftMorePressed() {
    leftPanelController.toggleMoreTools();
  }

  // ============================================================
  // BOTTOM BAR UPDATE RECEIVERS
  // ============================================================

  void onPlayPausePressed() {
    bottomBarController.togglePlayback();
  }

  void onPreviousFramePressed() {
    bottomBarController.previousFrame();
  }

  void onNextFramePressed() {
    bottomBarController.nextFrame();
  }

  // ============================================================
  // PROJECT SETTINGS UPDATE
  // ============================================================

  void updateProjectSettings({
    required double aspectRatio,
    required String resolution,
    required double fps,
  }) {
    projectController.updateCurrentProjectSettings(
      aspectRatio:
          _projectAspectRatio(aspectRatio),
      resolution: resolution,
      fps: fps,
    );
  }

  // ============================================================
  // PROJECT CONTROLLER CHANGES
  // ============================================================

  void _onProjectControllerChanged() {
    middleController.updateCanvasSettings(
      aspectRatio: aspectRatio,
      resolution: resolution,
    );

    notifyListeners();
  }

  // ============================================================
  // SAVE
  // ============================================================

  Future<void> save() async {
    if (_isSaving) {
      return;
    }

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

  // ============================================================
  // ASPECT RATIO HELPERS
  // ============================================================

  static double _aspectRatioValue(
    ProjectAspectRatio ratio,
  ) {
    switch (ratio) {
      case ProjectAspectRatio.ratio16x9:
        return 16 / 9;

      case ProjectAspectRatio.ratio9x16:
        return 9 / 16;

      case ProjectAspectRatio.ratio1x1:
        return 1;

      case ProjectAspectRatio.ratio4x1:
        return 4;
    }
  }

  static ProjectAspectRatio _projectAspectRatio(
    double value,
  ) {
    if ((value - (16 / 9)).abs() < 0.001) {
      return ProjectAspectRatio.ratio16x9;
    }

    if ((value - (9 / 16)).abs() < 0.001) {
      return ProjectAspectRatio.ratio9x16;
    }

    if ((value - 1).abs() < 0.001) {
      return ProjectAspectRatio.ratio1x1;
    }

    if ((value - 4).abs() < 0.001) {
      return ProjectAspectRatio.ratio4x1;
    }

    return ProjectAspectRatio.ratio16x9;
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    projectController.removeListener(
      _onProjectControllerChanged,
    );

    framesViewerController.dispose();

    leftPanelController.dispose();
    topBarController.dispose();
    bottomBarController.dispose();
    middleController.dispose();

    super.dispose();
  }
}