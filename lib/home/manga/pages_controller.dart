import 'package:flutter/foundation.dart';

class PageModel {
  PageModel({
    required this.id,
    required this.number,
  });

  final String id;
  int number;

  String get displayName => 'Page $number';
}

class PagesController extends ChangeNotifier {
  PagesController({List<PageModel>? initialPages})
      : _pages = initialPages ??
            List.generate(
              6,
              (index) => PageModel(
                id: 'page_${index + 1}',
                number: index + 1,
              ),
            );

  final List<PageModel> _pages;
  bool _isBusy = false;

  List<PageModel> get pages => List.unmodifiable(_pages);
  bool get isBusy => _isBusy;
  int get pageCount => _pages.length;

  /// Creates exactly 10 pages as one batch and appends them
  /// after the existing pages.
  Future<List<PageModel>> createPageSet() async {
    _setBusy(true);

    try {
      final created = <PageModel>[];
      final startNumber = _pages.length + 1;

      for (var i = 0; i < 10; i++) {
        final number = startNumber + i;
        final page = PageModel(
          id: _createId(number),
          number: number,
        );

        _pages.add(page);
        created.add(page);
      }

      notifyListeners();
      return List.unmodifiable(created);
    } finally {
      _setBusy(false);
    }
  }

  PageModel? findPage(String pageId) {
    for (final page in _pages) {
      if (page.id == pageId) return page;
    }
    return null;
  }

  Future<bool> deletePage(String pageId) async {
    _setBusy(true);

    try {
      final index = _pages.indexWhere((page) => page.id == pageId);
      if (index == -1) return false;

      _pages.removeAt(index);
      _renumberPages();
      notifyListeners();
      return true;
    } finally {
      _setBusy(false);
    }
  }

  void reorderPages(int oldIndex, int newIndex) {
    if (oldIndex < 0 ||
        oldIndex >= _pages.length ||
        newIndex < 0 ||
        newIndex > _pages.length ||
        oldIndex == newIndex) {
      return;
    }

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final page = _pages.removeAt(oldIndex);
    _pages.insert(newIndex, page);
    _renumberPages();
    notifyListeners();
  }

  void clearPages() {
    if (_pages.isEmpty) return;
    _pages.clear();
    notifyListeners();
  }

  void _renumberPages() {
    for (var i = 0; i < _pages.length; i++) {
      _pages[i].number = i + 1;
    }
  }

  String _createId(int number) {
    return 'page_${number}_${DateTime.now().microsecondsSinceEpoch}_${_pages.length}';
  }

  void _setBusy(bool value) {
    if (_isBusy == value) return;
    _isBusy = value;
    notifyListeners();
  }
}
