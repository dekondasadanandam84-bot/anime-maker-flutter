import 'package:flutter/material.dart';

import 'books_controller.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({
    super.key,
    this.seriesName = 'My Manga Series',
    this.controller,
    this.onOpenBook,
  });

  final String seriesName;
  final BooksController? controller;
  final ValueChanged<BookModel>? onOpenBook;

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  late final BooksController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();

    _ownsController = widget.controller == null;
    _controller = widget.controller ?? BooksController();
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }

    super.dispose();
  }

  // ============================================================
  // CREATE BOOK
  // ============================================================

  Future<void> _createBook() async {
    final number = _controller.nextBookNumber;
    final nameController = TextEditingController(
      text: 'Book $number',
    );

    final shouldCreate = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colorScheme =
            Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          backgroundColor: colorScheme.surfaceContainer,
          title: Text(
            'Create Book',
            style: TextStyle(
              color: colorScheme.onSurface,
            ),
          ),
          content: TextField(
            controller: nameController,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Book Name',
              hintText: 'Enter book name',
            ),
            onSubmitted: (_) {
              Navigator.of(dialogContext).pop(true);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Create Book'),
            ),
          ],
        );
      },
    );

    final name = nameController.text.trim();
    nameController.dispose();

    if (shouldCreate != true || !mounted) {
      return;
    }

    await _controller.createBook(
      name: name,
    );
  }

  // ============================================================
  // RENAME BOOK
  // ============================================================

  Future<void> _renameBook(
    BookModel book,
  ) async {
    final nameController = TextEditingController(
      text: book.name,
    );

    final shouldRename = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colorScheme =
            Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          backgroundColor: colorScheme.surfaceContainer,
          title: Text(
            'Rename Book ${book.number}',
            style: TextStyle(
              color: colorScheme.onSurface,
            ),
          ),
          content: TextField(
            controller: nameController,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Book Name',
              hintText: 'Enter a new name',
            ),
            onSubmitted: (_) {
              Navigator.of(dialogContext).pop(true);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    final name = nameController.text.trim();
    nameController.dispose();

    if (shouldRename != true || !mounted) {
      return;
    }

    await _controller.renameBook(
      bookId: book.id,
      newName: name,
    );
  }

  // ============================================================
  // DELETE BOOK
  // ============================================================

  Future<void> _deleteBook(
    BookModel book,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colorScheme =
            Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          backgroundColor: colorScheme.surfaceContainer,
          title: Text(
            'Delete Book?',
            style: TextStyle(
              color: colorScheme.onSurface,
            ),
          ),
          content: Text(
            'Are you sure you want to delete '
            '"${book.displayName}"? '
            'This action cannot be undone and will remove '
            'all pages within.',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    await _controller.deleteBook(book.id);
  }

  // ============================================================
  // BOOK MENU
  // ============================================================

  void _showBookMenu(
    BookModel book,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor:
          Theme.of(context).colorScheme.surface,
      builder: (sheetContext) {
        final colorScheme =
            Theme.of(sheetContext).colorScheme;

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.edit_outlined,
                  color: colorScheme.onSurface,
                ),
                title: Text(
                  'Rename',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                  ),
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _renameBook(book);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: colorScheme.error,
                ),
                title: Text(
                  'Delete',
                  style: TextStyle(
                    color: colorScheme.error,
                  ),
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _deleteBook(book);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: IconButton(
          tooltip: 'Back',
          onPressed: () {
            Navigator.of(context).maybePop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onSurface,
          ),
        ),

        centerTitle: true,

        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Books',
              style:
                  theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              widget.seriesName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  theme.textTheme.labelMedium?.copyWith(
                color:
                    colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),

        bottom: PreferredSize(
          preferredSize:
              const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: colorScheme.outlineVariant,
          ),
        ),
      ),

      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Column(
          children: [
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.fromLTRB(
                  16,
                  24,
                  16,
                  32,
                ),
                children: [
                  Text(
                    'Books',
                    style: theme
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                      color:
                          colorScheme.onSurface,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage the books in this manga series.',
                    style: theme
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                      color: colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_controller.bookCount} books',
                    style: theme
                        .textTheme
                        .labelMedium
                        ?.copyWith(
                      color: colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildBooksList(theme),
                ],
              ),
            ),
            _buildCreateAction(theme),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BOOKS LIST
  // ============================================================

  Widget _buildBooksList(
    ThemeData theme,
  ) {
    final colorScheme = theme.colorScheme;
    final books = _controller.books;

    if (books.isEmpty) {
      return Padding(
        padding:
            const EdgeInsets.symmetric(
          vertical: 64,
        ),
        child: Column(
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 48,
              color:
                  colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No books yet',
              style: theme
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                color:
                    colorScheme.onSurface,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Create the first book for this manga series.',
              textAlign: TextAlign.center,
              style: theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color: colorScheme
                    .onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color:
                colorScheme.outlineVariant,
          ),
        ),
      ),
      child: ReorderableListView.builder(
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(),
        itemCount: books.length,

        itemBuilder: (context, index) {
          final book = books[index];

          return Material(
            key: ValueKey(book.id),
            color: colorScheme.surface,
            child: InkWell(
              onTap: () =>
                  widget.onOpenBook?.call(book),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 16,
                ),
                decoration:
                    BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: colorScheme
                          .outlineVariant,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration:
                          BoxDecoration(
                        color: colorScheme
                            .primaryContainer,
                        borderRadius:
                            BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Icon(
                        Icons.menu_book_outlined,
                        color: colorScheme
                            .onPrimaryContainer,
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            book.displayName,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: theme
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                              color:
                                  colorScheme
                                      .onSurface,
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _controller
                                .getPageLabel(book),
                            style: theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              color: colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      tooltip: 'Rename',
                      onPressed: () =>
                          _renameBook(book),
                      icon: Icon(
                        Icons.edit_outlined,
                        color: colorScheme
                            .onSurfaceVariant,
                      ),
                    ),

                    IconButton(
                      tooltip: 'More options',
                      onPressed: () =>
                          _showBookMenu(book),
                      icon: Icon(
                        Icons.more_vert,
                        color: colorScheme
                            .onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(width: 4),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // CREATE ACTION
  // ============================================================

  Widget _buildCreateAction(
    ThemeData theme,
  ) {
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        16,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _controller.isBusy
                ? null
                : _createBook,
            icon: const Icon(Icons.add),
            label: const Text('Create Book'),
            style: FilledButton.styleFrom(
              minimumSize:
                  const Size.fromHeight(52),
              shape: const StadiumBorder(),
            ),
          ),
        ),
      ),
    );
  }
}