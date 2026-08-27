import 'package:flutter/foundation.dart';

class MiddleController extends ChangeNotifier {
  MiddleController({
    double? aspectRatio,
    String? resolution,
  })  : _aspectRatio = aspectRatio ?? 16 / 9,
        _resolution = resolution ?? '1920 × 1080';

  double _aspectRatio;
  String _resolution;

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
}