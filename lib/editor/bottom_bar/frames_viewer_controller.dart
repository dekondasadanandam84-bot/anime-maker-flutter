import 'package:flutter/foundation.dart';

import 'bottom_bar_controller.dart';

class FramesViewerController extends ChangeNotifier {
  FramesViewerController({
    required this.bottomBarController,
  }) {
    bottomBarController.addListener(
      _onBottomBarChanged,
    );
  }

  final BottomBarController bottomBarController;

  // ============================================================
  // SELECTION MODE
  // ============================================================

  bool _selectionMode = false;

  final Set<int> _selectedFrames = <int>{};

  bool get selectionMode => _selectionMode;

  List<int> get selectedFrames {
    final result = _selectedFrames.toList()
      ..sort();

    return List.unmodifiable(result);
  }

  bool get hasSelection =>
      _selectedFrames.isNotEmpty;

  bool isFrameSelected(int frame) {
    return _selectedFrames.contains(frame);
  }

  // ============================================================
  // FRAME TAP
  // ============================================================

  void onFrameTap(int frame) {
    if (!bottomBarController.frames.contains(frame)) {
      return;
    }

    if (_selectionMode) {
      toggleFrameSelection(frame);
      return;
    }

    bottomBarController.selectFrame(frame);
  }

  // ============================================================
  // LONG PRESS
  // ============================================================

  void onFrameLongPress(int frame) {
    if (!bottomBarController.frames.contains(frame)) {
      return;
    }

    if (!_selectionMode) {
      _selectionMode = true;
      _selectedFrames.clear();
    }

    _selectedFrames.add(frame);

    notifyListeners();
  }

  // ============================================================
  // TOGGLE FRAME SELECTION
  // ============================================================

  void toggleFrameSelection(int frame) {
    if (!_selectionMode) {
      return;
    }

    if (!bottomBarController.frames.contains(frame)) {
      return;
    }

    if (_selectedFrames.contains(frame)) {
      _selectedFrames.remove(frame);
    } else {
      _selectedFrames.add(frame);
    }

    notifyListeners();
  }

  // ============================================================
  // SELECT ALL
  // ============================================================

  void selectAll() {
    _selectionMode = true;

    _selectedFrames
      ..clear()
      ..addAll(
        bottomBarController.frames,
      );

    notifyListeners();
  }

  // ============================================================
  // CANCEL
  // ============================================================

  void cancelSelection() {
    if (!_selectionMode &&
        _selectedFrames.isEmpty) {
      return;
    }

    _selectionMode = false;
    _selectedFrames.clear();

    notifyListeners();
  }

  // ============================================================
  // CURRENT OPERATION FRAMES
  // ============================================================

  List<int> _currentOperationFrames() {
    if (_selectionMode &&
        _selectedFrames.isNotEmpty) {
      return selectedFrames;
    }

    return <int>[
      bottomBarController.selectedFrame,
    ];
  }

  // ============================================================
  // ADD BEFORE
  // ============================================================

  void addBefore() {
    bottomBarController.addFrameBefore();

    cancelSelection();
  }

  // ============================================================
  // ADD AFTER
  // ============================================================

  void addAfter() {
    bottomBarController.addFrameAfter();

    cancelSelection();
  }

  // ============================================================
  // COPY
  // ============================================================

  void copy() {
    bottomBarController.copyFrames(
      _currentOperationFrames(),
    );
  }

  // ============================================================
  // PASTE
  // ============================================================

  void paste() {
    bottomBarController.pasteFrames();

    cancelSelection();
  }

  // ============================================================
  // DUPLICATE
  // ============================================================

  void duplicate() {
    bottomBarController.duplicateFrames(
      _currentOperationFrames(),
    );

    cancelSelection();
  }

  // ============================================================
  // ERASE
  // ============================================================

  void erase() {
    bottomBarController.eraseFrames(
      _currentOperationFrames(),
    );

    cancelSelection();
  }

  // ============================================================
  // ADD MULTIPLE FRAMES
  // ============================================================
  //
  // Used by the existing 1–30 Add Frames sheet.
  // ============================================================

  void addFrames(int count) {
    bottomBarController.addFrames(count);
  }

  // ============================================================
  // BOTTOM BAR CHANGES
  // ============================================================

  void _onBottomBarChanged() {
    final validFrames =
        bottomBarController.frames.toSet();

    final oldLength =
        _selectedFrames.length;

    _selectedFrames.removeWhere(
      (frame) => !validFrames.contains(frame),
    );

    if (oldLength !=
        _selectedFrames.length) {
      notifyListeners();
      return;
    }

    notifyListeners();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    bottomBarController.removeListener(
      _onBottomBarChanged,
    );

    super.dispose();
  }
}