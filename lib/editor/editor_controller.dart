import 'package:flutter/foundation.dart';

class EditorController extends ChangeNotifier {
  EditorController({
    required this.clipId,
    required this.clipName,
  });

  final String clipId;
  final String clipName;

  bool _isSaving = false;

  bool get isSaving => _isSaving;

  Future<void> save() async {
    if (_isSaving) return;

    _isSaving = true;
    notifyListeners();

    try {
      // Save logic will be added later.
      await Future<void>.delayed(const Duration(milliseconds: 500));
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}