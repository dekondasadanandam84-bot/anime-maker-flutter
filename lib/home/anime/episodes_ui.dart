import 'package:flutter/material.dart';

import '../models/episode_model.dart';
import '../project_controller.dart';
import '../project_scope.dart';
import 'clips_ui.dart';

class EpisodesScreen extends StatefulWidget {
  const EpisodesScreen({
    super.key,
  });

  @override
  State<EpisodesScreen> createState() =>
      _EpisodesScreenState();
}

class _EpisodesScreenState extends State<EpisodesScreen> {
  // ============================================================
  // PROJECT CONTROLLER
  // ============================================================

  ProjectController get projectController =>
      ProjectScope.of(context);

  // ============================================================
  // CREATE EPISODE
  // ============================================================

  Future<void> _createEpisode() async {
    final season = projectController.currentSeason;

    if (season == null) {
      return;
    }

    final number = season.episodes.isEmpty
        ? 1
        : season.episodes
                .map(
                  (episode) => episode.episodeNumber,
                )
                .reduce(
                  (a, b) => a > b ? a : b,
                ) +
            1;

    final controller = TextEditingController();

    final create = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colorScheme =
            Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          backgroundColor: colorScheme.surfaceContainer,
          title: Text(
            'Create Episode',
            style: TextStyle(
              color: colorScheme.onSurface,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Episode Name',
              hintText: 'Leave empty for Episode $number',
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
              child: const Text(
                'Create Episode',
              ),
            ),
          ],
        );
      },
    );

    final name = controller.text.trim();
    controller.dispose();

    if (create != true || !mounted) {
      return;
    }

    projectController.createEpisode(
      name: name,
    );
  }

  // ============================================================
  // RENAME EPISODE
  // ============================================================

  Future<void> _renameEpisode(
    EpisodeModel episode,
  ) async {
    final controller = TextEditingController(
      text: episode.name,
    );

    final save = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colorScheme =
            Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          backgroundColor: colorScheme.surfaceContainer,
          title: Text(
            'Rename Episode ${episode.episodeNumber}',
            style: TextStyle(
              color: colorScheme.onSurface,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Episode Name',
              hintText: 'Episode ${episode.episodeNumber}',
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

    if (save != true || !mounted) {
      return;
    }

    projectController.renameEpisode(
      episodeId: episode.id,
      newName: name,
    );
  }

  // ============================================================
  // DELETE EPISODE
  // ============================================================

  Future<void> _deleteEpisode(
    EpisodeModel episode,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colorScheme =
            Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          backgroundColor: colorScheme.surfaceContainer,
          title: Text(
            'Delete Episode?',
            style: TextStyle(
              color: colorScheme.onSurface,
            ),
          ),
          content: Text(
            'Are you sure you want to delete '
            '"${episode.displayName}"? '
            'This action cannot be undone and will remove '
            'all clips within.',
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
                backgroundColor:
                    colorScheme.error,
                foregroundColor:
                    colorScheme.onError,
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

    projectController.deleteEpisode(
      episode.id,
    );
  }

  // ============================================================
  // EPISODE MENU
  // ============================================================

  void _showEpisodeMenu(
    EpisodeModel episode,
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

                  _renameEpisode(
                    episode,
                  );
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

                  _deleteEpisode(
                    episode,
                  );
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
  // SEASON MENU
  // ============================================================

  void _showSeasonMenu() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor:
          Theme.of(context).colorScheme.surface,
      builder: (sheetContext) {
        final colorScheme =
            Theme.of(sheetContext).colorScheme;

        return SafeArea(
          child: ListTile(
            leading: Icon(
              Icons.refresh_outlined,
              color: colorScheme.onSurface,
            ),
            title: Text(
              'Refresh',
              style: TextStyle(
                color: colorScheme.onSurface,
              ),
            ),
            onTap: () {
              Navigator.of(sheetContext).pop();
            },
          ),
        );
      },
    );
  }

  // ============================================================
  // OPEN EPISODE / CLIPS
  // ============================================================

  void _openEpisode(
    EpisodeModel episode,
  ) {
    final selected = projectController.selectEpisode(
      episode.id,
    );

    if (!selected) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ClipsScreen(),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // ProjectScope.of() makes this screen reactive to
    // ProjectController.notifyListeners().
    final controller = ProjectScope.of(context);

    final season = controller.currentSeason;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: IconButton(
          tooltip: 'Back',
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.close_rounded,
            color: colorScheme.onSurface,
          ),
        ),

        actions: [
          IconButton(
            tooltip: 'More options',
            onPressed: _showSeasonMenu,
            icon: Icon(
              Icons.more_vert,
              color: colorScheme.onSurface,
            ),
          ),
        ],

        bottom: PreferredSize(
          preferredSize:
              const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: colorScheme.outlineVariant,
          ),
        ),

        centerTitle: true,

        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Episodes',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              season?.displayName ?? 'Season',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                color:
                    colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),

      body: season == null
          ? Center(
              child: Text(
                'Season not found',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      32,
                      16,
                      120,
                    ),
                    children: [
                      Text(
                        'Episodes',
                        style:
                            theme.textTheme.headlineSmall
                                ?.copyWith(
                          color:
                              colorScheme.onSurface,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Manage the episodes in this season.',
                        style:
                            theme.textTheme.bodyLarge
                                ?.copyWith(
                          color: colorScheme
                              .onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 28),
                      _buildEpisodeList(
                        theme,
                        season.episodes,
                      ),
                    ],
                  ),
                ),
                _buildBottomAction(theme),
              ],
            ),
    );
  }

  // ============================================================
  // EPISODE LIST
  // ============================================================

  Widget _buildEpisodeList(
    ThemeData theme,
    List<EpisodeModel> episodes,
  ) {
    final colorScheme = theme.colorScheme;

    if (episodes.isEmpty) {
      return _buildEmptyState(theme);
    }

    return Column(
      children: [
        for (int i = 0;
            i < episodes.length;
            i++)
          _buildEpisodeRow(
            theme,
            episodes[i],
            isLast: i == episodes.length - 1,
          ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24,
          ),
          child: Text(
            'End of season',
            style: theme.textTheme.bodyMedium?.copyWith(
              color:
                  colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // EPISODE ROW
  // ============================================================

  Widget _buildEpisodeRow(
    ThemeData theme,
    EpisodeModel episode, {
    required bool isLast,
  }) {
    final colorScheme = theme.colorScheme;
    final empty = episode.clipCount == 0;

    return Material(
      color: colorScheme.surface,
      child: InkWell(
        onTap: () {
          _openEpisode(episode);
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            border: isLast
                ? null
                : Border(
                    bottom: BorderSide(
                      color:
                          colorScheme.outlineVariant,
                    ),
                  ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.video_library_outlined,
                  color: empty
                      ? colorScheme
                          .onPrimaryContainer
                          .withValues(alpha: 0.5)
                      : colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      episode.displayName,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          theme.textTheme.bodyLarge
                              ?.copyWith(
                        color:
                            colorScheme.onSurface,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      episode.clipCount == 1
                          ? '1 Clip'
                          : '${episode.clipCount} Clips',
                      style:
                          theme.textTheme.bodyMedium
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
                  _renameEpisode(episode);
                },
                icon: Icon(
                  Icons.edit_outlined,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              IconButton(
                tooltip: 'More options',
                onPressed: () {
                  _showEpisodeMenu(episode);
                },
                icon: Icon(
                  Icons.more_horiz,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
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
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 64,
      ),
      child: Column(
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 48,
            color:
                colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No episodes yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Create the first episode for this season.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color:
                  colorScheme.onSurfaceVariant,
            ),
          ),
        ],
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
            color: colorScheme.outlineVariant,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _createEpisode,
            icon: const Icon(Icons.add),
            label: const Text('Create Episode'),
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