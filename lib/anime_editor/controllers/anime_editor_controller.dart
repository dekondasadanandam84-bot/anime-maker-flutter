import 'package:flutter/material.dart';
import '../controllers/frame_manager.dart';
import '../canvas_system/controllers/canvas_manager.dart';
import '../models/project_model.dart';
import '../canvas_system/controllers/canvas_controller.dart';
import '../canvas_system/tools/brush_engine.dart';

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

final ProjectModel project;


  

  late final FrameManager frameManager;

late final CanvasController canvasController;
  

late final CanvasManager canvasManager;
late final BrushEngine brushEngine;



  // ======================
  // LEFT TOOLBAR
  // ======================

  EditorTool? selectedTool;



  // ======================
  // BRUSH PANEL
  // ======================

  BrushTool? selectedBrushTool;



  // ======================
  // ERASER PANEL
  // ======================

  EraserTool? selectedEraserTool;



  // ======================
  // TEXT PANEL
  // ======================

  TextTool? selectedTextTool;

bool brushActive = false;

  AnimeEditorController({
  required this.project,
}) {

  frameManager = FrameManager(
    frames: project.currentClip.frames,
    selectedFrame: project.currentClip.selectedFrame,
    project: project,
  );

  frameManager.addListener(notifyListeners);



  canvasManager = CanvasManager(
    project: project,
  );

  canvasManager.addListener(notifyListeners);



  brushEngine = BrushEngine();



  canvasController = CanvasController(
    canvasManager: canvasManager,
  );



  brushEngine.addListener(notifyListeners);

  canvasController.addListener(notifyListeners);

}

 String get projectName => project.name;



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

  brushActive = true;

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
  // PROJECT SAVE
  // ======================

  Map<String, dynamic> saveProject() {

    return project.toJson();

  }



  // ======================
  // RESET
  // ======================

  void reset() {


    frameManager.clear();


    selectedTool = null;

    selectedBrushTool = null;

    selectedEraserTool = null;

    selectedTextTool = null;


    notifyListeners();

  }
@override
void dispose() {

  if (hasListeners) {
    frameManager.removeListener(notifyListeners);
    canvasManager.removeListener(notifyListeners);
  }

  frameManager.dispose();
  canvasManager.dispose();
  brushEngine.dispose();

canvasController.dispose();

  super.dispose();
}
}