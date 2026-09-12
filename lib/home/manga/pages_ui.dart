import 'package:flutter/material.dart';

import 'pages_controller.dart';

class PagesScreen extends StatefulWidget {
  const PagesScreen({
    super.key,
    this.bookName = 'Volume 1',
    this.controller,
    this.onOpenPage,
  });

  final String bookName;
  final PagesController? controller;
  final ValueChanged<PageModel>? onOpenPage;

  @override
  State<PagesScreen> createState() => _PagesScreenState();
}

class _PagesScreenState extends State<PagesScreen> {
  late final PagesController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();

    _ownsController = widget.controller == null;
    _controller = widget.controller ?? PagesController();
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }

    super.dispose();
  }

  // ============================================================
  // CREATE PAGE SET
  // ============================================================

  Future<void> _createPageSet() async {
    await _controller.createPageSet();
  }

  // ============================================================
  // DELETE PAGE
  // ============================================================

  Future<void> _confirmDelete(
    PageModel page,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colorScheme =
            Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          backgroundColor: colorScheme.surfaceContainer,
          title: Text(
            'Delete Page?',
            style: TextStyle(
              color: colorScheme.onSurface,
            ),
          ),
          content: Text(
            'Delete ${page.displayName}? '
            'The remaining pages will be renumbered.',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () =>
                  Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      await _controller.deletePage(page.id);
    }
  }

  // ============================================================
  // PAGE MENU
  // ============================================================

  void _showPageMenu(
    PageModel page,
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
                  Icons.open_in_new_outlined,
                  color: colorScheme.onSurface,
                ),
                title: Text(
                  'Open Page',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                  ),
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  widget.onOpenPage?.call(page);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: colorScheme.error,
                ),
                title: Text(
                  'Delete Page',
                  style: TextStyle(
                    color: colorScheme.error,
                  ),
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _confirmDelete(page);
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
          onPressed: () =>
              Navigator.of(context).maybePop(),
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
              'Pages',
              style:
                  theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              widget.bookName,
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
        builder: (context, _) {
          return Column(
            children: [
              Expanded(
                child: _buildContent(theme),
              ),
              _buildBottomAction(theme),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // CONTENT
  // ============================================================

  Widget _buildContent(
    ThemeData theme,
  ) {
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding =
            constraints.maxWidth >= 700
                ? 48.0
                : 16.0;

        final crossAxisCount =
            constraints.maxWidth >= 1000
                ? 4
                : constraints.maxWidth >= 700
                    ? 3
                    : 2;

        final pages = _controller.pages;

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                24,
                horizontalPadding,
                12,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pages',
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
                      'Manage the pages in this manga book. '
                      '${_controller.pageCount} pages',
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
            ),

            if (pages.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildEmptyState(theme),
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  16,
                  horizontalPadding,
                  120,
                ),
                sliver: SliverGrid(
                  delegate:
                      SliverChildBuilderDelegate(
                    (context, index) {
                      final page = pages[index];

                      return _PageDragTarget(
                        key: ValueKey(page.id),
                        index: index,
                        child: _buildPageCard(
                          theme,
                          page,
                        ),
                        onDrop: (from, to) {
                          _controller
                              .reorderPages(
                            from,
                            to,
                          );
                        },
                      );
                    },
                    childCount: pages.length,
                  ),
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 18,
                    childAspectRatio: 0.69,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // ============================================================
  // PAGE CARD
  // ============================================================

  Widget _buildPageCard(
    ThemeData theme,
    PageModel page,
  ) {
    return LongPressDraggable<int>(
      data: page.number - 1,
      feedback: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: 150),
          child: _buildPagePreview(
            theme,
            page,
            isDragging: true,
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildPagePreview(
          theme,
          page,
        ),
      ),
      child: _buildPagePreview(
        theme,
        page,
      ),
    );
  }

  // ============================================================
  // PAGE PREVIEW
  // ============================================================

  Widget _buildPagePreview(
    ThemeData theme,
    PageModel page, {
    bool isDragging = false,
  }) {
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Expanded(
          child: Material(
            color: colorScheme.surfaceContainer,
            borderRadius:
                BorderRadius.circular(10),
            child: InkWell(
              onTap: () =>
                  widget.onOpenPage?.call(page),
              borderRadius:
                  BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      colorScheme.surfaceContainer,
                  border: Border.all(
                    color: isDragging
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                    width: isDragging ? 2 : 1,
                  ),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.article_outlined,
                        size: 34,
                        color: colorScheme
                            .onSurfaceVariant
                            .withValues(
                          alpha: 0.55,
                        ),
                      ),
                    ),

                    // PAGE NUMBER
                    Positioned(
                      top: 8,
                      left: 8,
                      child: DecoratedBox(
                        decoration:
                            BoxDecoration(
                          color: colorScheme.surface
                              .withValues(
                            alpha: 0.9,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            6,
                          ),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 7,
                            vertical: 4,
                          ),
                          child: Text(
                            '${page.number}',
                            style: theme
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                              color:
                                  colorScheme
                                      .onSurface,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // MORE OPTIONS
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Material(
                        color: colorScheme
                            .surface
                            .withValues(
                          alpha: 0.92,
                        ),
                        shape:
                            const CircleBorder(),
                        child: IconButton(
                          tooltip:
                              'More options',
                          onPressed: () =>
                              _showPageMenu(
                            page,
                          ),
                          constraints:
                              const BoxConstraints
                                  .tightFor(
                            width: 34,
                            height: 34,
                          ),
                          padding:
                              EdgeInsets.zero,
                          icon: Icon(
                            Icons.more_vert,
                            size: 18,
                            color: colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 9),

        Text(
          page.displayName,
          maxLines: 1,
          overflow:
              TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: theme
              .textTheme
              .labelLarge
              ?.copyWith(
            color: colorScheme.onSurface,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState(
    ThemeData theme,
  ) {
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.article_outlined,
              size: 52,
              color:
                  colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No pages yet',
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
              'Create a batch of 10 pages to start this book.',
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
      ),
    );
  }

  // ============================================================
  // BOTTOM ACTION
  // ============================================================

  Widget _buildBottomAction(
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
            color:
                colorScheme.outlineVariant,
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
                : _createPageSet,
            icon: const Icon(Icons.add),
            label: const Text(
              'Create 10 Pages',
            ),
            style: FilledButton.styleFrom(
              minimumSize:
                  const Size.fromHeight(54),
              shape:
                  const StadiumBorder(),
            ),
          ),
        ),
      ),
    );
  }
}

// ================================================================
// PAGE DRAG TARGET
// ================================================================

class _PageDragTarget extends StatefulWidget {
  const _PageDragTarget({
    super.key,
    required this.index,
    required this.child,
    required this.onDrop,
  });

  final int index;
  final Widget child;
  final void Function(
    int fromIndex,
    int toIndex,
  ) onDrop;

  @override
  State<_PageDragTarget> createState() =>
      _PageDragTargetState();
}

class _PageDragTargetState
    extends State<_PageDragTarget> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return DragTarget<int>(
      onWillAcceptWithDetails: (details) {
        final accept =
            details.data != widget.index;

        if (accept) {
          setState(() {
            _hovering = true;
          });
        }

        return accept;
      },
      onLeave: (_) {
        setState(() {
          _hovering = false;
        });
      },
      onAcceptWithDetails: (details) {
        setState(() {
          _hovering = false;
        });

        widget.onDrop(
          details.data,
          widget.index,
        );
      },
      builder: (
        context,
        candidateData,
        rejectedData,
      ) {
        return AnimatedContainer(
          duration:
              const Duration(milliseconds: 120),
          transform: _hovering
              ? (Matrix4.identity()
                ..scaleByDouble(
                  1.025,
                  1.025,
                  1.025,
                  1.0,
                ))
              : Matrix4.identity(),
          child: widget.child,
        );
      },
    );
  }
}