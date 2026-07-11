import 'package:flutter/material.dart';


enum EditorTool {
  brush,
  eraser,
  text,
  paint,
  selection,
}

enum BrushTool {
  brush,
  pressure,
  opacity,
  color,
  size,
}

enum EraserTool {
  size,
  opacity,
  softness,
  strength,
}

enum TextTool {
  add,
  font,
  size,
  color,
}

class AnimeEditorController extends ChangeNotifier {
  String projectName;
  String ratio;
  int fps;
  int frames;

  // Left toolbar
  EditorTool? selectedTool;

  // Brush panel
  BrushTool? selectedBrushTool;

  // Eraser panel
  EraserTool? selectedEraserTool;

  // Text panel
  TextTool? selectedTextTool;

  AnimeEditorController({
    required this.projectName,
    required this.ratio,
    required this.fps,
    this.frames = 1,
  });

  // ======================
  // LEFT TOOLBAR
  // ======================

  void selectTool(EditorTool tool) {
    selectedTool = tool;
    notifyListeners();
  }

  void clearTool() {
    selectedTool = null;
    notifyListeners();
  }

  // ======================
  // BRUSH PANEL
  // ======================

  void selectBrushTool(BrushTool tool) {
    selectedBrushTool = tool;
    notifyListeners();
  }

  void clearBrushTool() {
    selectedBrushTool = null;
    notifyListeners();
  }

  // ======================
  // ERASER PANEL
  // ======================

  void selectEraserTool(EraserTool tool) {
    selectedEraserTool = tool;
    notifyListeners();
  }

  void clearEraserTool() {
    selectedEraserTool = null;
    notifyListeners();
  }

  // ======================
  // TEXT PANEL
  // ======================

  void selectTextTool(TextTool tool) {
    selectedTextTool = tool;
    notifyListeners();
  }

  void clearTextTool() {
    selectedTextTool = null;
    notifyListeners();
  }

  // ======================
  // PROJECT
  // ======================

  Map<String, dynamic> saveProject() {
    return {
      "name": projectName,
      "type": "anime",
      "ratio": ratio,
      "fps": fps,
      "frames": frames,
    };
  }

  void addFrames(int value) {
    frames += value;
    notifyListeners();
  }

  void reset() {
    frames = 1;

    selectedTool = null;
    selectedBrushTool = null;
    selectedEraserTool = null;
    selectedTextTool = null;

    notifyListeners();
  }
}