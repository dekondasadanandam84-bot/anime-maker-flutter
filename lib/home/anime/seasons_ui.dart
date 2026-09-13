import 'package:flutter/material.dart';

import '../models/season_model.dart';
import '../project_controller.dart';
import '../project_scope.dart';
import 'episodes_ui.dart';

class SeasonsScreen extends StatefulWidget {
  const SeasonsScreen({
    super.key,
  });

  @override
  State<SeasonsScreen> createState() =>
      _SeasonsScreenState();
}

class _SeasonsScreenState extends State<SeasonsScreen> {
  // ============================================================
  // PROJECT CONTROLLER
  // ============================================================

  ProjectController get projectController =>
      ProjectScope.of(context);

  // ============================================================
  // CREATE SEASON
  // ============================================================

  Future<void> _createSeason() async {
    final series = projectController.currentAnimeSeries;

    if (series == null) {
      return;
    }

    final nextNumber = series.seasons.isEmpty
        ? 1
        : series.seasons
                .map((season) => season.number)
                .reduce(
                  (a, b) => a > b ? a : b,
                ) +
            1;

    final controller = TextEditingController(
      text: 'Season $nextNumber',
    );

    final shouldCreate = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colorScheme =
            Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          backgroundColor: colorScheme.surfaceContainer,
          title: Text(
            'Create Season',
            style: TextStyle(
              color: colorScheme.onSurface,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Season Name',
              hintText: 'Enter season name',
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
              child: const Text('Create Season'),
            ),
          ],
        );
      },
    );

    final name = controller.text.trim();
    controller.dispose();

    if (shouldCreate != true || !mounted) {
      return;
    }

    projectController.createSeason(
      name: name,
    );
  }

  // ============================================================
  // RENAME SEASON
  // ============================================================

  Future<void> _renameSeason(
    SeasonModel season,
  ) async {
    final controller = TextEditingController(
      text: season.name,
    );

    final shouldRename = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colorScheme =
            Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          backgroundColor: colorScheme.surfaceContainer,
          title: Text(
            'Rename Season ${season.number}',
            style: TextStyle(
              color: colorScheme.onSurface,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Season Name',
              hintText: 'Enter a new season name',
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

    if (shouldRename != true || !mounted) {
      return;
    }

    projectController.renameSeason(
      seasonId: season.id,
      newName: name,
    );
  }

  // ============================================================
  // DELETE SEASON
  // ============================================================

  Future<void> _deleteSeason(
    SeasonModel season,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colorScheme =
            Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          backgroundColor: colorScheme.surfaceContainer,
          title: Text(
            'Delete Season?',
            style: TextStyle(
              color: colorScheme.onSurface,
            ),
          ),
          content: Text(
            'Are you sure you want to delete '
            '"${season.displayName}"? '
            'This action cannot be undone and will remove '
            'all episodes within.',
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

    projectController.deleteSeason(
      season.id,
    );
  }

  // ============================================================
  // SEASON MENU
  // ============================================================

  void _showSeasonMenu(
    SeasonModel season,
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
                  _renameSeason(season);
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
                  _deleteSeason(season);
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
  // EPISODE LABEL
  // ============================================================

  String _episodeLabel(
    SeasonModel season,
  ) {
    return season.episodeCount == 1
        ? '1 Episode'
        : '${season.episodeCount} Episodes';
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // This creates the dependency on ProjectController.
    final controller = ProjectScope.of(context);

    final series = controller.currentAnimeSeries;

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
              'Seasons',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              series?.name ?? 'Anime Series',
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

      body: series == null
          ? Center(
              child: Text(
                'Anime series not found',
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
                        'Seasons',
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
                        'Manage the seasons in this anime series.',
                        style:
                            theme.textTheme.bodyLarge
                                ?.copyWith(
                          color: colorScheme
                              .onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildSeasonList(
                        theme,
                        series.seasons,
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
  // SEASON LIST
  // ============================================================

  Widget _buildSeasonList(
    ThemeData theme,
    List<SeasonModel> seasons,
  ) {
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
  color: Colors.white,
  border: Border.all(
    color: colorScheme.outlineVariant,
  ),
  borderRadius: BorderRadius.circular(12),
),
      clipBehavior: Clip.antiAlias,
      child: seasons.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 36,
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.auto_stories_outlined,
                    size: 42,
                    color:
                        colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No seasons yet',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(
                      color:
                          colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Create the first season for this series.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(
                      color: colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                for (int i = 0;
                    i < seasons.length;
                    i++)
                  _buildSeasonRow(
                    theme,
                    seasons[i],
                    isLast:
                        i == seasons.length - 1,
                  ),
              ],
            ),
    );
  }

  // ============================================================
  // SEASON ROW
  // ============================================================

  Widget _buildSeasonRow(
    ThemeData theme,
    SeasonModel season, {
    required bool isLast,
  }) {
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          if (!projectController.selectSeason(
            season.id,
          )) {
            return;
          }

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const EpisodesScreen(),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: isLast
                ? null
                : Border(
                    bottom: BorderSide(
                      color: colorScheme.outlineVariant,
                    ),
                  ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
border: Border.all(
  color: colorScheme.outlineVariant,
),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.movie_creation_outlined,
                  color:
                      colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      season.displayName,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge
                          ?.copyWith(
                        color:
                            colorScheme.onSurface,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _episodeLabel(season),
                      style: theme.textTheme.labelMedium
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
                onPressed: () {
                  _renameSeason(season);
                },
                icon: Icon(
                  Icons.edit_outlined,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              IconButton(
                tooltip: 'More options',
                onPressed: () {
                  _showSeasonMenu(season);
                },
                icon: Icon(
                  Icons.more_vert,
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
            onPressed: _createSeason,
            icon: const Icon(Icons.add),
            label: const Text('Create Season'),
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