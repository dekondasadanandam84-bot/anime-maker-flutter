import 'package:flutter/foundation.dart';

class BookModel {
  BookModel({
    required this.id,
    required this.number,
    required this.name,
    this.pageCount = 0,
  });

  final String id;
  int number;
  String name;
  int pageCount;

  String get displayName {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'Book $number';

    final prefix = RegExp(
      r'^book\s+\d+\s*:?\s*',
      caseSensitive: false,
    );
    final customName = trimmed.replaceFirst(prefix, '').trim();

    return customName.isEmpty
        ? 'Book $number'
        : 'Book $number: $customName';
  }

  BookModel copyWith({
    String? id,
    int? number,
    String? name,
    int? pageCount,
  }) {
    return BookModel(
      id: id ?? this.id,
      number: number ?? this.number,
      name: name ?? this.name,
      pageCount: pageCount ?? this.pageCount,
    );
  }
}

class BooksController extends ChangeNotifier {
  BooksController({List<BookModel>? initialBooks})
      : _books = initialBooks ?? [
          BookModel(
            id: 'book_1',
            number: 1,
            name: 'The Awakening',
            pageCount: 24,
          ),
          BookModel(
            id: 'book_2',
            number: 2,
            name: 'Whispers in the Dark',
            pageCount: 28,
          ),
          BookModel(
            id: 'book_3',
            number: 3,
            name: 'Shadows of the Past',
            pageCount: 32,
          ),
          BookModel(
            id: 'book_4',
            number: 4,
            name: 'The Final Stand',
            pageCount: 20,
          ),
        ];

  final List<BookModel> _books;
  bool _isBusy = false;

  List<BookModel> get books => List.unmodifiable(_books);
  bool get isBusy => _isBusy;
  int get bookCount => _books.length;

  int get nextBookNumber {
    if (_books.isEmpty) return 1;
    return _books
            .map((book) => book.number)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }

  BookModel? findBook(String id) {
    for (final book in _books) {
      if (book.id == id) return book;
    }
    return null;
  }

  Future<BookModel> createBook({
    String? name,
    int pageCount = 0,
  }) async {
    _setBusy(true);
    try {
      final number = nextBookNumber;
      final cleaned = _stripBookPrefix(name?.trim() ?? '');
      final book = BookModel(
        id: _createId(number),
        number: number,
        name: cleaned.isEmpty ? 'Book $number' : cleaned,
        pageCount: pageCount < 0 ? 0 : pageCount,
      );
      _books.add(book);
      notifyListeners();
      return book;
    } finally {
      _setBusy(false);
    }
  }

  Future<bool> renameBook({
    required String bookId,
    required String newName,
  }) async {
    final book = findBook(bookId);
    if (book == null) return false;

    final cleaned = _stripBookPrefix(newName.trim());
    book.name = cleaned.isEmpty ? 'Book ${book.number}' : cleaned;
    notifyListeners();
    return true;
  }

  Future<bool> deleteBook(String bookId) async {
    _setBusy(true);
    try {
      final index = _books.indexWhere((book) => book.id == bookId);
      if (index == -1) return false;
      _books.removeAt(index);
      _renumberBooks();
      notifyListeners();
      return true;
    } finally {
      _setBusy(false);
    }
  }

  void updatePageCount({
    required String bookId,
    required int pageCount,
  }) {
    final book = findBook(bookId);
    if (book == null) return;
    book.pageCount = pageCount < 0 ? 0 : pageCount;
    notifyListeners();
  }

  String getPageLabel(BookModel book) {
    if (book.pageCount == 1) return '1 Page';
    return '${book.pageCount} Pages';
  }

  void reorderBooks(int oldIndex, int newIndex) {
    if (oldIndex < 0 ||
        oldIndex >= _books.length ||
        newIndex < 0 ||
        newIndex > _books.length ||
        _books.length < 2) {
      return;
    }

    if (oldIndex < newIndex) newIndex -= 1;

    final book = _books.removeAt(oldIndex);
    _books.insert(newIndex, book);
    _renumberBooks();
    notifyListeners();
  }

  String _stripBookPrefix(String value) {
    if (value.isEmpty) return '';
    return value
        .replaceFirst(
          RegExp(r'^book\s+\d+\s*:?\s*', caseSensitive: false),
          '',
        )
        .trim();
  }

  void _renumberBooks() {
    for (var i = 0; i < _books.length; i++) {
      _books[i].number = i + 1;
    }
  }

  String _createId(int number) =>
      'book_${number}_${DateTime.now().microsecondsSinceEpoch}';

  void _setBusy(bool value) {
    if (_isBusy == value) return;
    _isBusy = value;
    notifyListeners();
  }
}
