import 'package:flutter/foundation.dart';

class LeftPanelController extends ChangeNotifier {
  static const int brush = 0;
  static const int eraser = 1;
  static const int font = 2;
  static const int paint = 3;
  static const int select = 4;
  static const int more = 5;
  static const int smudge = 6;
  static const int blur = 7;

  int _selectedTool = -1;
  bool _moreToolsOpen = false;
  bool _rightPanelOpen = false;
  bool _paintSheetOpen = false;

int get selectedTool => _selectedTool;
bool get moreToolsOpen => _moreToolsOpen;
bool get rightPanelOpen => _rightPanelOpen;
bool get paintSheetOpen => _paintSheetOpen;

  void selectTool(int toolId) {
  // ------------------------------------------------------------
  // PAINT
  // ------------------------------------------------------------
  if (toolId == paint) {
    _selectedTool = paint;
    _rightPanelOpen = false;
    _moreToolsOpen = false;
    _paintSheetOpen = true;

    notifyListeners();
    return;
  }

  // ------------------------------------------------------------
  // BRUSH, ERASER AND FONT
  // ------------------------------------------------------------
  if (toolId == brush ||
      toolId == eraser ||
      toolId == font) {
    if (_selectedTool == toolId) {
      // Same tool tapped again -> toggle right panel.
      _rightPanelOpen = !_rightPanelOpen;
    } else {
      // New tool -> select it and open its right panel.
      _selectedTool = toolId;
      _rightPanelOpen = true;
    }

    _paintSheetOpen = false;
    _moreToolsOpen = false;

    notifyListeners();
    return;
  }

  // ------------------------------------------------------------
  // OTHER TOOLS
  // ------------------------------------------------------------
  _selectedTool = toolId;
  _rightPanelOpen = false;
  _paintSheetOpen = false;

  if (toolId == smudge || toolId == blur) {
    _moreToolsOpen = true;
  } else if (toolId != more) {
    _moreToolsOpen = false;
  }

  notifyListeners();
}

void closePaintSheet() {
  _paintSheetOpen = false;

  notifyListeners();
}

  void toggleMoreTools() {
  _moreToolsOpen = !_moreToolsOpen;

  if (_moreToolsOpen) {
    _selectedTool = more;
    _rightPanelOpen = false;
  } else {
    _selectedTool = brush;
    _rightPanelOpen = true;
  }

  notifyListeners();
}

}