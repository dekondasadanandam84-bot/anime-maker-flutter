import 'package:flutter/material.dart';

import '../models/clip_model.dart';
import '../project_controller.dart';
import '../project_scope.dart';

import '../../editor/editor_ui.dart';

import 'movie_clips_controller.dart';

class MovieClipsScreen extends StatefulWidget {
  const MovieClipsScreen({
    super.key,
    this.controller,
  });

  final MovieClipsController? controller;

  @override
  State<MovieClipsScreen> createState() =>
      _MovieClipsScreenState();
}

class _MovieClipsScreenState
    extends State<MovieClipsScreen> {
  late MovieClipsController _controller;
  bool _controllerInitialized = false;
  bool _ownsController = false;

  // ============================================================
  // PROJECT CONTROLLER
  // ============================================================

  ProjectController get projectController =>
      ProjectScope.of(context);

  // ============================================================
  // CONTROLLER INITIALIZATION
  // ============================================================

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_controllerInitialized) {
      return;
    }

    _controllerInitialized = true;

    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      _controller = MovieClipsController(
        projectController: projectController,
      );
      _ownsController = true;
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }

    super.dispose();
  }



  // ============================================================
  // CREATE CLIP
  // ============================================================

  Future<void> _createClip() async {
    final movie = projectController.currentAnimeMovie;

    if (movie == null) {
      return;
    }

    final nameController = TextEditingController();

    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create Clip'),
          content: TextField(
            controller: nameController,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Clip Name',
              hintText: 'Enter clip name',
            ),
            onSubmitted: (_) {
              Navigator.of(dialogContext).pop(
                nameController.text.trim(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(
                  nameController.text.trim(),
                );
              },
              child: const Text('Create Clip'),
            ),
          ],
        );
      },
    );

    nameController.dispose();

    if (name == null || !mounted) {
      return;
    }

    await _controller.createClip(
      name: name,
    );
  }

  // ============================================================
  // RENAME CLIP
  // ============================================================

  Future<void> _renameClip(
    ClipModel clip,
  ) async {
    final controller = TextEditingController(
      text: clip.name,
    );

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Rename Clip ${clip.number}',
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Clip Name',
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

    final name = controller.text.trim();

    controller.dispose();

    if (shouldSave != true || !mounted) {
      return;
    }

    await _controller.renameClip(
      clipId: clip.id,
      newName: name,
    );
  }

  // ============================================================
  // DELETE CLIP
  // ============================================================

  Future<void> _deleteClip(
    ClipModel clip,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Clip?'),
          content: Text(
            'Are you sure you want to delete '
            '"${clip.name}"? '
            'This action cannot be undone.',
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
                backgroundColor:
                    Theme.of(dialogContext)
                        .colorScheme
                        .error,
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

    await _controller.deleteClip(
      clip.id,
    );
  }

  // ============================================================
  // CLIP MENU
  // ============================================================

  void _showClipMenu(
    ClipModel clip,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final errorColor =
            Theme.of(context).colorScheme.error;

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.edit_outlined,
                ),
                title: const Text('Rename'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _renameClip(clip);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: errorColor,
                ),
                title: Text(
                  'Delete',
                  style: TextStyle(
                    color: errorColor,
                  ),
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _deleteClip(clip);
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
  // OPEN CLIP / EDITOR
  // ============================================================

  Future<void> _openClip(
  ClipModel clip,
) async {
  final controller = projectController;

  final currentProject = controller.currentProject;

  if (currentProject == null ||
      currentProject.animeMovie == null) {
    return;
  }

  // Re-read the latest clip from ProjectController.
  final currentClip =
      controller.findCurrentClipById(clip.id);

  if (currentClip == null) {
    return;
  }

  // Make this clip the active clip in the central controller.
  final selected = controller.selectClip(
    currentClip.id,
  );

  if (!selected) {
    return;
  }

  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => EditorScreen(
        clipId: currentClip.id,
      ),
    ),
  );
}

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Reactive connection to the central ProjectController.
    final controller = ProjectScope.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: IconButton(
          tooltip: 'Back',
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),

        actions: [
          IconButton(
            tooltip: 'More options',
            onPressed: _showScreenMenu,
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],

        bottom: PreferredSize(
          preferredSize:
              const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color:
                theme.colorScheme.outlineVariant,
          ),
        ),

        centerTitle: true,

        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Clips',
              style:
                  theme.textTheme.titleLarge
                      ?.copyWith(
                fontWeight:
                    FontWeight.w700,
              ),
            ),
            Text(
              controller.currentAnimeMovie?.name ??
                  'Anime Movie',
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              style:
                  theme.textTheme.labelMedium
                      ?.copyWith(
                color: theme
                    .colorScheme
                    .onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),

      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final movie =
              controller.currentAnimeMovie;

          if (movie == null) {
            return const Center(
              child: Text(
                'Anime movie not found',
              ),
            );
          }

          final clips =
              controller.currentClips;

          return Stack(
            children: [
              if (clips.isEmpty)
                _buildEmptyState(theme)
              else
                CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding:
                          const EdgeInsets.fromLTRB(
                        16,
                        32,
                        16,
                        140,
                      ),
                      sliver:
                          SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              'Clips',
                              style: theme
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                fontWeight:
                                    FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Manage and reorder the clips in this movie.',
                              style: theme
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                color: theme
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(
                              height: 28,
                            ),
                            Container(
                              width:
                                  double.infinity,
                              padding:
                                  const EdgeInsets
                                      .only(
                                bottom: 12,
                              ),
                              decoration:
                                  BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(
                                    color: theme
                                        .colorScheme
                                        .outlineVariant,
                                  ),
                                ),
                              ),
                              child: Text(
                                '${clips.length} '
                                '${clips.length == 1 ? 'clip' : 'clips'}',
                                style: theme
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                  color: theme
                                      .colorScheme
                                      .onSurfaceVariant,
                                  fontWeight:
                                      FontWeight.w600,
                                  letterSpacing:
                                      1.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverReorderableList(
                      itemCount: clips.length,

                      onReorderItem:
                          (oldIndex, newIndex) {
                        _controller.reorderClip(
                          oldIndex: oldIndex,
                          newIndex: newIndex,
                        );
                      },

                      itemBuilder:
                          (context, index) {
                        final clip =
                            clips[index];

                        return _buildClipRow(
                          theme,
                          clip,
                          index,
                          key: ValueKey(
                            clip.id,
                          ),
                        );
                      },
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding:
                            const EdgeInsets
                                .fromLTRB(
                          16,
                          24,
                          16,
                          40,
                        ),
                        child: Center(
                          child: Text(
                            'End of movie',
                            style: theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              color: theme
                                  .colorScheme
                                  .onSurfaceVariant,
                              fontStyle:
                                  FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              _buildBottomAction(theme),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // CLIP ROW
  // ============================================================

  Widget _buildClipRow(
    ThemeData theme,
    ClipModel clip,
    int index, {
    required Key key,
  }) {
    return ReorderableDelayedDragStartListener(
      key: key,
      index: index,

      child: Material(
        color: theme.colorScheme.surface,

        child: InkWell(
          onTap: () {
            _openClip(clip);
          },

          child: Container(
            margin:
                const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            padding:
                const EdgeInsets.symmetric(
              vertical: 16,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme
                      .colorScheme
                      .outlineVariant,
                ),
              ),
            ),

            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 40,
                  alignment:
                      Alignment.center,
                  child: const Icon(
                    Icons.drag_indicator,
                    size: 18,
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  width: 48,
                  height: 48,
                  decoration:
                      BoxDecoration(
                    color: theme
                        .colorScheme
                        .surfaceContainer,
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Icon(
                    Icons.movie_outlined,
                    color: theme
                        .colorScheme
                        .onSurfaceVariant,
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
                        clip.name,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: theme
                            .textTheme
                            .labelLarge
                            ?.copyWith(
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        clip.metadataLabel,
                        style: theme
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                          color: theme
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  tooltip: 'Rename',
                  onPressed: () {
                    _renameClip(clip);
                  },
                  icon: const Icon(
                    Icons.edit_outlined,
                  ),
                ),

                IconButton(
                  tooltip: 'More options',
                  onPressed: () {
                    _showClipMenu(clip);
                  },
                  icon: const Icon(
                    Icons.more_horiz,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState(
    ThemeData theme,
  ) {
    return ListView(
      padding:
          const EdgeInsets.fromLTRB(
        24,
        64,
        24,
        140,
      ),
      children: [
        const SizedBox(height: 36),

        Icon(
          Icons.movie_outlined,
          size: 52,
          color:
              theme.colorScheme.onSurfaceVariant,
        ),

        const SizedBox(height: 16),

        Text(
          'No clips yet',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium
              ?.copyWith(
            fontWeight:
                FontWeight.w600,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          'Create the first clip for this movie.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium
              ?.copyWith(
            color: theme
                .colorScheme
                .onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BOTTOM ACTION
  // ============================================================

  Widget _buildBottomAction(
    ThemeData theme,
  ) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,

      child: Container(
        padding:
            const EdgeInsets.fromLTRB(
          16,
          18,
          16,
          16,
        ),

        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface
                  .withValues(alpha: 0.0),
              theme.colorScheme.surface
                  .withValues(alpha: 0.98),
            ],
          ),
        ),

        child: SafeArea(
          top: false,

          child: Center(
            child: FilledButton.icon(
              onPressed:
                  _controller.isBusy
                      ? null
                      : _createClip,
              icon: const Icon(
                Icons.add,
              ),
              label:
                  const Text('Create Clip'),
              style:
                  FilledButton.styleFrom(
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape:
                    const StadiumBorder(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SCREEN MENU
  // ============================================================

  void _showScreenMenu() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.sort,
                ),
                title: const Text(
                  'Reorder Clips',
                ),
                subtitle: const Text(
                  'Drag and hold a clip to move it',
                ),
                onTap: () {
                  Navigator.of(
                    sheetContext,
                  ).pop();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}