import 'package:flutter_application_1/anime_editor/drawing/brush_drawing_system.dart';

import '../canvas/canvas_controller.dart';
import '../models/frame_model.dart';
import '../models/tool_type.dart';

class AnimeEditorController {
  final String projectName;
  final String ratio;
  final int fps;

  AnimeEditorController({
  required this.projectName,
  required this.ratio,
  required this.fps,
}) {
  // Load the first frame when the editor opens.
  brushDrawingSystem.loadFrame(frames.first.strokes);
}

  // ================= CANVAS =================
  final CanvasController canvasController = CanvasController();

  // ================= DRAWING =================

final BrushDrawingSystem brushDrawingSystem = BrushDrawingSystem();

  // ================= FRAMES =================
  final List<FrameModel> frames = [FrameModel(number: 1)];
  int selectedFrame = 0;

  // ================= TOOLS =================
  ToolType? selectedTool = ToolType.brush;

  // Brush
  int brushPanelIndex = 0;

  // Eraser
  int eraserPanelIndex = 0;
  double eraserSize = 20;
  double eraserOpacity = 1.0;
  bool softEraser = false;

  // ================= HISTORY =================
  final List<List<FrameModel>> _undoStack = [];
  final List<List<FrameModel>> _redoStack = [];

  void _saveState() {
    _undoStack.add(List.from(frames));
    _redoStack.clear();
  }

  void undo() {
    if (_undoStack.isEmpty) return;

    _redoStack.add(List.from(frames));

    frames
      ..clear()
      ..addAll(_undoStack.removeLast());
  }

  void redo() {
    if (_redoStack.isEmpty) return;

    _undoStack.add(List.from(frames));

    frames
      ..clear()
      ..addAll(_redoStack.removeLast());
  }

  // ================= TOOLS =================

  void selectTool(ToolType? tool) {
    selectedTool = tool;
  }

  // ================= FRAMES =================

  void reorderFrames(int oldIndex, int newIndex) {
    final frame = frames.removeAt(oldIndex);
    frames.insert(newIndex, frame);

    if (selectedFrame == oldIndex) {
      selectedFrame = newIndex;
    }
  }

  void addFrames(int count) {
    _saveState();

    for (int i = 0; i < count.clamp(1, 24); i++) {
      frames.add(FrameModel(number: frames.length + 1));
    }

    selectedFrame = frames.length - 1;

    brushDrawingSystem.loadFrame(
  currentFrame.strokes,
);
  }

  void addBefore(int index) {
    _saveState();

    frames.insert(index, FrameModel(number: 0));

    _renumber();

    selectedFrame = index;

    brushDrawingSystem.loadFrame(
  currentFrame.strokes,
);
  }

  void addAfter(int index) {
    _saveState();

    frames.insert(index + 1, FrameModel(number: 0));

    _renumber();

    selectedFrame = index + 1;
    brushDrawingSystem.loadFrame(
  currentFrame.strokes,
);
  }

  void duplicateFrame(int index) {
    _saveState();

    frames.insert(index + 1, FrameModel(number: 0));

    _renumber();

    selectedFrame = index + 1;

    brushDrawingSystem.loadFrame(
  currentFrame.strokes,
);
  }

  void deleteFrame(int index) {
    if (frames.length == 1) return;

    _saveState();

    frames.removeAt(index);

    _renumber();

    if (selectedFrame >= frames.length) {
      selectedFrame = frames.length - 1;

      brushDrawingSystem.loadFrame(
  currentFrame.strokes,
);
    }
  }

  void selectFrame(int index) {
  if (index < 0 || index >= frames.length) return;

  selectedFrame = index;

  brushDrawingSystem.loadFrame(
    frames[index].strokes,
  );
}

  void _renumber() {
    for (int i = 0; i < frames.length; i++) {
      frames[i] = FrameModel(number: i + 1);
    }
  }

  FrameModel get currentFrame => frames[selectedFrame];

  void dispose() {
  brushDrawingSystem.dispose();
  canvasController.dispose();
}
}