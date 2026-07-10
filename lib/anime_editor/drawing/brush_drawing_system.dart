import 'package:flutter/material.dart';

import '../models/point_model.dart';
import '../models/stroke_model.dart';

/// Handles all brush drawing logic.
///
/// Responsibilities:
/// - Store strokes
/// - Create new strokes
/// - Add points
/// - Finish strokes
/// - Clear canvas
/// - Notify listeners
class BrushDrawingSystem extends ChangeNotifier {
  BrushDrawingSystem();

  /// All completed strokes.
  List<StrokeModel> _strokes = [];

  /// Stroke currently being drawn.
  StrokeModel? _currentStroke;

  /// Brush settings.
  Color _brushColor = Colors.black;
  double _brushSize = 4.0;

  //==================================================
  // Getters
  //==================================================

  List<StrokeModel> get strokes => List.unmodifiable(_strokes);

  StrokeModel? get currentStroke => _currentStroke;

  Color get brushColor => _brushColor;

  double get brushSize => _brushSize;

  //==================================================
  // Brush Settings
  //==================================================

  void setBrushColor(Color color) {
    if (_brushColor == color) return;

    _brushColor = color;
    notifyListeners();
  }

  void setBrushSize(double size) {
    if (size <= 0) return;

    _brushSize = size;
    notifyListeners();
  }

  //==================================================
  // Drawing
  //==================================================

  void startStroke(Offset position) {
  _currentStroke = StrokeModel(
    color: _brushColor,
    strokeWidth: _brushSize,
    points: [
      PointModel(
        offset: position,
      ),
    ],
  );

  _strokes.add(_currentStroke!);

  notifyListeners();
}

  static const double _minDistance = 1.5;

void addPoint(Offset position) {
  if (_currentStroke == null) return;

  final last = _currentStroke!.points.last.offset;

  if ((position - last).distance < _minDistance) {
    return;
  }

  _currentStroke!.points.add(
    PointModel(
      offset: position,
    ),
  );

  notifyListeners();
}

  void endStroke() {
    _currentStroke = null;
    notifyListeners();
  }

  //==================================================
  // Canvas
  //==================================================

  void clear() {
    _strokes.clear();
    _currentStroke = null;
    notifyListeners();
  }

  //==================================================
  // Future Features
  //==================================================

  //==================================================
// Frame Management
//==================================================

void loadFrame(List<StrokeModel> frameStrokes) {
  _strokes = frameStrokes;
  _currentStroke = null;

  notifyListeners();
}

  void undo() {
    
  }

  void redo() {
    
  }

  void erase() {
    
  }
}