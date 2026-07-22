import 'package:flutter/material.dart';

import '../models/brush_model.dart';

class BrushEngine extends ChangeNotifier {
  BrushModel _currentBrush = const BrushModel(
    id: 'default_brush',
  );

  /// Currently selected brush.
  BrushModel get currentBrush => _currentBrush;

  /// Replace the entire brush.
  void setBrush(BrushModel brush) {
    _currentBrush = brush;
    notifyListeners();
  }

  /// Change brush color.
  void setColor(Color color) {
    _currentBrush = _currentBrush.copyWith(
      color: color,
    );
    notifyListeners();
  }

  /// Change brush size.
  void setSize(double size) {
    _currentBrush = _currentBrush.copyWith(
      size: size,
    );
    notifyListeners();
  }

  /// Change opacity.
  void setOpacity(double opacity) {
    _currentBrush = _currentBrush.copyWith(
      opacity: opacity.clamp(0.0, 1.0),
    );
    notifyListeners();
  }

  /// Enable/disable anti-aliasing.
  void setAntiAlias(bool enabled) {
    _currentBrush = _currentBrush.copyWith(
      antiAlias: enabled,
    );
    notifyListeners();
  }

  /// Enable/disable pressure sensitivity.
  void setPressureEnabled(bool enabled) {
    _currentBrush = _currentBrush.copyWith(
      pressureEnabled: enabled,
    );
    notifyListeners();
  }

  /// Restore default brush settings.
  void reset() {
    _currentBrush = const BrushModel(
      id: 'default_brush',
    );
    notifyListeners();
  }
}