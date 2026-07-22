import 'package:flutter/foundation.dart';

import '../models/brush_model.dart';
import '../models/canvas_model.dart';
import '../models/point_model.dart';
import '../models/stroke_model.dart';
import 'canvas_manager.dart';

class CanvasController extends ChangeNotifier {
  final CanvasManager canvasManager;

  CanvasController({
    required this.canvasManager,
  }) {
    canvasManager.addListener(notifyListeners);
  }

  CanvasModel get canvas => canvasManager.canvas;

  StrokeModel? _currentStroke;

  /// Starts a new stroke.
  void startStroke({
    required PointModel point,
    required BrushModel brush,
  }) {

    if (kDebugMode) {
      print("Stroke started at: ${point.x}, ${point.y}");
    }



    _currentStroke = StrokeModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      brush: brush,
      points: [point],
    );

    notifyListeners();
  }

  /// Adds a point to the current stroke.
  void addPoint(PointModel point) {
    if (_currentStroke == null) return;

    _currentStroke = _currentStroke!.addPoint(point);

    notifyListeners();
  }

  /// Finishes the stroke and saves it into the current canvas.
  void endStroke() {
    if (_currentStroke == null) return;

    canvas.strokes = [
  ...canvas.strokes,
  _currentStroke!,
];

    _currentStroke = null;

    notifyListeners();
  }

  /// Removes every stroke from the current frame.
  void clearCanvas() {
    canvas.strokes.clear();

    notifyListeners();
  }

  /// Returns the stroke currently being drawn.
  StrokeModel? get currentStroke => _currentStroke;

  @override
  void dispose() {
    canvasManager.removeListener(notifyListeners);
    super.dispose();
  }
}