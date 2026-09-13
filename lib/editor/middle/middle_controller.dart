import 'dart:ui';

import 'package:flutter/foundation.dart';

class MiddleController extends ChangeNotifier {
  MiddleController({double? aspectRatio, String? resolution})
    : _aspectRatio = aspectRatio ?? 16 / 9,
      _resolution = resolution ?? '1920 × 1080';
  double _zoom = 1.0;
  Offset _panOffset = Offset.zero;
  bool _showFit = false;

  double _aspectRatio;
  String _resolution;

  double get zoom => _zoom;

  Offset get panOffset => _panOffset;

  bool get showFit => _showFit;

  double get aspectRatio => _aspectRatio;

  String get resolution => _resolution;

  void updateCanvasSettings({
    required double aspectRatio,
    required String resolution,
  }) {
    _aspectRatio = aspectRatio;
    _resolution = resolution;

    notifyListeners();
  }

  void updateViewport({
    required double zoom,
    required Offset panOffset,
    required bool showFit,
  }) {
    _zoom = zoom;
    _panOffset = panOffset;
    _showFit = showFit;

    notifyListeners();
  }

  void fitToScreen() {
    _zoom = 1.0;
    _panOffset = Offset.zero;
    _showFit = false;

    notifyListeners();
  }
}
