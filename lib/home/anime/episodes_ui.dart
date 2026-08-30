
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
  //
  // ProjectController is the single source of truth.
  // This screen does not store project/season/episode data.
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
        return AlertDialog(
          title: const Text(
            'Create Episode',
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
        return AlertDialog(
          title: Text(
            'Rename Episode ${episode.episodeNumber}',
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
        return AlertDialog(
          title: const Text(
            'Delete Episode?',
          ),
          content: Text(
            'Are you sure you want to delete '
            '"${episode.displayName}"? '
            'This action cannot be undone and will remove '
            'all clips within.',
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

                  _renameEpisode(
                    episode,
                  );
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
      builder: (sheetContext) {
        return SafeArea(
          child: ListTile(
            leading: const Icon(
              Icons.refresh_outlined,
            ),
            title: const Text('Refresh'),
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

    // ProjectScope.of() makes this screen reactive to
    // ProjectController.notifyListeners().
    final controller = ProjectScope.of(context);

    final season = controller.currentSeason;

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
            onPressed: _showSeasonMenu,
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
            color: theme.colorScheme.outlineVariant,
          ),
        ),

        centerTitle: true,

        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Episodes',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              season?.displayName ?? 'Season',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                color:
                    theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),

      body: season == null
          ? const Center(
              child: Text(
                'Season not found',
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
                          color: theme
                              .colorScheme
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
                  theme.colorScheme.onSurfaceVariant,
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
    final empty = episode.clipCount == 0;

    return Material(
      color: theme.colorScheme.surface,
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
                      color: theme
                          .colorScheme
                          .surfaceContainerHighest,
                    ),
                  ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme
                      .colorScheme
                      .surfaceContainerHigh,
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.video_library_outlined,
                  color: empty
                      ? theme.colorScheme.onSurface
                          .withValues(alpha: 0.5)
                      : theme.colorScheme.onSurface,
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
                icon: const Icon(
                  Icons.edit_outlined,
                ),
              ),
              IconButton(
                tooltip: 'More options',
                onPressed: () {
                  _showEpisodeMenu(episode);
                },
                icon: const Icon(
                  Icons.more_horiz,
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
                theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No episodes yet',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Create the first episode for this season.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color:
                  theme.colorScheme.onSurfaceVariant,
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
    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        16,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(
          alpha: 0.96,
        ),
        border: Border(
          top: BorderSide(
            color:
                theme.colorScheme.surfaceContainerHighest,
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

