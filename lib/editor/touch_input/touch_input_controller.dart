import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Input mode selected from AnimeClip Settings.
///
/// Stylus:
///   Stylus input is intended for drawing.
///
/// Finger:
///   Finger input is intended for canvas manipulation.
///
/// Both:
///   Stylus can draw and finger can manipulate the canvas.
enum InputMode {
  stylus,
  finger,
  both,
}

/// Central controller for editor touch input and viewport manipulation.
///
/// Current features:
/// - Two-finger pinch -> zoom in / zoom out.
/// - Two-finger movement -> pan.
/// - zoomIn() -> manual zoom in helper.
/// - zoomOut() -> manual zoom out helper.
/// - panBy() -> manual pan helper.
/// - Any zoom/pan interaction makes Fit available.
/// - Fit resets zoom and pan.
///
/// Future features intentionally reserved:
/// - One-finger double tap -> Select.
/// - Two-finger undo.
/// - Three-finger redo.
///
/// Architecture:
///
/// Settings
///    ↓
/// TouchInputController
///    ↓
/// MiddleController
///    ↓
/// EditorController
///    ↓
/// MiddleUI / EditorUI
class TouchInputController extends ChangeNotifier {
  TouchInputController({
    this._inputMode = InputMode.stylus,
    double initialZoom = 1.0,
    Offset initialPan = Offset.zero,
    this.minZoom = 0.25,
    this.maxZoom = 4.0,
    this.zoomStep = 0.25,
  })  : assert(minZoom > 0),
        assert(maxZoom >= minZoom),
        assert(zoomStep > 0),
        _zoom = initialZoom.clamp(minZoom, maxZoom),
        _panOffset = initialPan;

  // ============================================================
  // CONFIGURATION
  // ============================================================

  final double minZoom;
  final double maxZoom;
  final double zoomStep;

  // ============================================================
  // INPUT MODE
  // ============================================================

  InputMode _inputMode;

  InputMode get inputMode => _inputMode;

  /// True when finger gestures are allowed to control the canvas.
  bool get allowsFingerGestures =>
      _inputMode == InputMode.finger ||
      _inputMode == InputMode.both;

  /// True when stylus input is allowed to be forwarded to the brush.
  bool get allowsStylusDrawing =>
      _inputMode == InputMode.stylus ||
      _inputMode == InputMode.both;

  /// Change the active input mode.
  void setInputMode(InputMode mode) {
    if (_inputMode == mode) {
      return;
    }

    _inputMode = mode;
    notifyListeners();
  }

  // ============================================================
  // VIEWPORT STATE
  // ============================================================

  double _zoom;
  Offset _panOffset;

  double get zoom => _zoom;

  Offset get panOffset => _panOffset;

  /// True after the user has zoomed or panned.
  ///
  /// This is independent of whether editor panels are visible.
  bool _hasViewportInteraction = false;

  bool get hasViewportInteraction => _hasViewportInteraction;

  /// True when the floating Fit control should be visible.
  ///
  /// This intentionally has no dependency on panelsHidden.
  bool _showFit = false;

  bool get showFit => _showFit;

  // ============================================================
  // TWO-FINGER GESTURE STATE
  // ============================================================

  bool _isTwoFingerGestureActive = false;

  bool get isTwoFingerGestureActive =>
      _isTwoFingerGestureActive;

  double _gestureStartZoom = 1.0;
  Offset _gestureStartPan = Offset.zero;
  Offset _gestureStartFocalPoint = Offset.zero;

  // ============================================================
  // TWO-FINGER SCALE START
  // ============================================================

  /// Starts a two-finger viewport gesture.
  ///
  /// The gesture is ignored when Finger gestures are disabled.
  void onScaleStart(ScaleStartDetails details) {
    if (!allowsFingerGestures) {
      return;
    }

    if (details.pointerCount < 2) {
      return;
    }

    _isTwoFingerGestureActive = true;

    _gestureStartZoom = _zoom;
    _gestureStartPan = _panOffset;
    _gestureStartFocalPoint = details.focalPoint;

    notifyListeners();
  }

  // ============================================================
  // TWO-FINGER SCALE UPDATE
  // ============================================================

  /// Handles two-finger pinch zoom and two-finger pan.
  ///
  /// Pinching:
  ///   details.scale changes → zoom.
  ///
  /// Moving both fingers:
  ///   details.focalPoint changes → pan.
  void onScaleUpdate(ScaleUpdateDetails details) {
    if (!allowsFingerGestures) {
      return;
    }

    if (details.pointerCount < 2) {
      return;
    }

    final safeScale = math.max(details.scale, 0.001);

    final nextZoom =
        (_gestureStartZoom * safeScale).clamp(
      minZoom,
      maxZoom,
    );

    final focalDelta =
        details.focalPoint - _gestureStartFocalPoint;

    final nextPan = _gestureStartPan + focalDelta;

    final zoomChanged =
        (nextZoom - _zoom).abs() > 0.0001;

    final panChanged =
        (nextPan - _panOffset).distance > 0.01;

    if (!zoomChanged && !panChanged) {
      return;
    }

    _zoom = nextZoom;
    _panOffset = nextPan;

    _markViewportInteracted();

    notifyListeners();
  }

  // ============================================================
  // TWO-FINGER SCALE END
  // ============================================================

  void onScaleEnd(ScaleEndDetails details) {
    if (!_isTwoFingerGestureActive) {
      return;
    }

    _isTwoFingerGestureActive = false;

    notifyListeners();
  }

  // ============================================================
  // ZOOM IN
  // ============================================================

  /// Zoom in by [zoomStep].
  void zoomIn() {
    setZoom(_zoom + zoomStep);
  }

  // ============================================================
  // ZOOM OUT
  // ============================================================

  /// Zoom out by [zoomStep].
  void zoomOut() {
    setZoom(_zoom - zoomStep);
  }

  // ============================================================
  // SET ZOOM
  // ============================================================

  /// Set an exact zoom value while respecting min/max limits.
  void setZoom(double value) {
    final nextZoom = value.clamp(
      minZoom,
      maxZoom,
    );

    if ((nextZoom - _zoom).abs() < 0.0001) {
      return;
    }

    _zoom = nextZoom;

    _markViewportInteracted();

    notifyListeners();
  }

  // ============================================================
  // ZOOM BY
  // ============================================================

  /// Change zoom by an arbitrary amount.
  ///
  /// Positive = zoom in.
  /// Negative = zoom out.
  void zoomBy(double amount) {
    if (amount == 0) {
      return;
    }

    setZoom(_zoom + amount);
  }

  // ============================================================
  // PAN
  // ============================================================

  /// Move the canvas by [delta].
  void panBy(Offset delta) {
    if (delta == Offset.zero) {
      return;
    }

    _panOffset += delta;

    _markViewportInteracted();

    notifyListeners();
  }

  // ============================================================
  // SET PAN
  // ============================================================

  /// Set an exact canvas translation.
  void setPanOffset(Offset offset) {
    if (offset == _panOffset) {
      return;
    }

    _panOffset = offset;

    _markViewportInteracted();

    notifyListeners();
  }

  // ============================================================
  // UPDATE VIEWPORT
  // ============================================================

  /// Update zoom and pan together.
  ///
  /// Useful when MiddleController or EditorController wants to apply
  /// a viewport state received from another part of the editor.
  void updateViewport({
    required double zoom,
    required Offset panOffset,
  }) {
    final nextZoom = zoom.clamp(
      minZoom,
      maxZoom,
    );

    final zoomChanged =
        (nextZoom - _zoom).abs() > 0.0001;

    final panChanged =
        (panOffset - _panOffset).distance > 0.01;

    if (!zoomChanged && !panChanged) {
      return;
    }

    _zoom = nextZoom;
    _panOffset = panOffset;

    _markViewportInteracted();

    notifyListeners();
  }

  // ============================================================
  // FIT TO SCREEN
  // ============================================================

  /// Reset the viewport to its default state.
  ///
  /// MiddleController can later calculate a more advanced fit based
  /// on the real canvas and viewport dimensions.
  void fitToScreen() {
    final changed =
        (_zoom - 1.0).abs() > 0.0001 ||
        _panOffset != Offset.zero ||
        _showFit ||
        _hasViewportInteraction;

    _zoom = 1.0;
    _panOffset = Offset.zero;
    _showFit = false;
    _hasViewportInteraction = false;
    _isTwoFingerGestureActive = false;

    if (changed) {
      notifyListeners();
    }
  }

  // ============================================================
  // FIT CONTROL VISIBILITY
  // ============================================================

  /// Show Fit after a zoom/pan interaction.
  ///
  /// This is intentionally independent of editor panel visibility.
  void showFitControl() {
    if (_showFit) {
      return;
    }

    _showFit = true;

    notifyListeners();
  }

  /// Hide Fit without changing zoom or pan.
  void hideFitControl() {
    if (!_showFit) {
      return;
    }

    _showFit = false;

    notifyListeners();
  }

  // ============================================================
  // PANELS HIDDEN
  // ============================================================

  /// Called by EditorController when panels are hidden.
  ///
  /// Fit remains available after a previous viewport interaction.
  void onPanelsHidden() {
    if (_hasViewportInteraction) {
      _showFit = true;
      notifyListeners();
    }
  }

  // ============================================================
  // TOUCH OWNERSHIP
  // ============================================================

  /// Returns true when the viewport should own the pointer sequence.
  ///
  /// Current rule:
  /// - Finger + 2 or more pointers = viewport gesture.
  bool shouldHandleViewport({
    required PointerDeviceKind deviceKind,
    required int pointerCount,
  }) {
    return allowsFingerGestures &&
        deviceKind == PointerDeviceKind.touch &&
        pointerCount >= 2;
  }

  /// Returns true when a stylus can be forwarded to the brush.
  bool shouldHandleStylusBrush({
    required PointerDeviceKind deviceKind,
  }) {
    return allowsStylusDrawing &&
        deviceKind == PointerDeviceKind.stylus;
  }

  // ============================================================
  // FUTURE GESTURE HOOKS
  // ============================================================

  /// Future:
  /// One-finger double tap -> Select.
  void onDoubleTap() {
    // Reserved for the select system.
  }

  /// Future:
  /// Two-finger undo.
  void onTwoFingerUndo() {
    // Reserved for the undo system.
  }

  /// Future:
  /// Three-finger redo.
  void onThreeFingerRedo() {
    // Reserved for the redo system.
  }

  // ============================================================
  // RESET VIEWPORT
  // ============================================================

  /// Reset only viewport state while keeping the input mode.
  void resetViewport() {
    _zoom = 1.0;
    _panOffset = Offset.zero;
    _showFit = false;
    _hasViewportInteraction = false;
    _isTwoFingerGestureActive = false;

    notifyListeners();
  }

  // ============================================================
  // INTERNAL
  // ============================================================

  void _markViewportInteracted() {
    _hasViewportInteraction = true;

    // Fit must appear after zoom or pan, whether panels are visible
    // or hidden.
    _showFit = true;
  }

  static InputMode _globalInputMode = InputMode.stylus;

static InputMode get globalInputMode => _globalInputMode;

static void setGlobalInputMode(InputMode mode) {
  _globalInputMode = mode;
}
}