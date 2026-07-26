import 'package:flutter/foundation.dart';

import '../../models/canvas_model.dart';
import 'canvas_manager.dart';

class CanvasController extends ChangeNotifier {
  final CanvasManager canvasManager;

  CanvasController({
    required this.canvasManager,
  }) {
    canvasManager.addListener(notifyListeners);
  }

  CanvasModel get canvas => canvasManager.canvas;

  @override
  void dispose() {
    canvasManager.removeListener(notifyListeners);
    super.dispose();
  }
}