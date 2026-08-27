import 'package:flutter/material.dart';

import '../models/anime_series_model.dart';
import 'seasons_controller.dart';
import '../models/season_model.dart';
import '../models/project_settings_model.dart';
import 'episodes_ui.dart';

class SeasonsScreen extends StatefulWidget {
  const SeasonsScreen({
    super.key,
    required this.series,
    required this.settings,
    this.controller,
     required this.projectName,
    this.onSeriesChanged,
  });

  final AnimeSeriesModel series;
  final ProjectSettingsModel settings;
  final SeasonsController? controller;
  final ValueChanged<AnimeSeriesModel>? onSeriesChanged;
  
   final String projectName;

  @override
  State<SeasonsScreen> createState() => _SeasonsScreenState();
}

class _SeasonsScreenState extends State<SeasonsScreen> {
  late final SeasonsController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();

    _ownsController = widget.controller == null;

    _controller = widget.controller ?? SeasonsController(series: widget.series);
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }

    super.dispose();
  }

  Future<void> _createSeason() async {
    final seasonNumber = _controller.nextSeasonNumber;

    final controller = TextEditingController(text: 'Season $seasonNumber');

    final shouldCreate = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create Season'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
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

    await _controller.createSeason(name: name);
  }

  Future<void> _renameSeason(SeasonModel season) async {
    final controller = TextEditingController(text: season.name);

    final shouldRename = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Rename Season ${season.number}'),
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

    await _controller.renameSeason(seasonId: season.id, newName: name);
  }

  Future<void> _deleteSeason(SeasonModel season) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Season?'),
          content: Text(
            'Are you sure you want to delete '
            '"${season.displayName}"? '
            'This action cannot be undone and will remove '
            'all episodes within.',
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
                backgroundColor: Theme.of(dialogContext).colorScheme.error,
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

    await _controller.deleteSeason(season.id);
  }

  void _showSeasonMenu(SeasonModel season) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Rename'),
                onTap: () {
                  Navigator.of(sheetContext).pop();

                  _renameSeason(season);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  'Delete',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () {
            Navigator.of(context).pop(_controller.series);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: theme.colorScheme.outlineVariant),
        ),
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Seasons',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              widget.series.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 120),
                  children: [
                    Text(
                      'Seasons',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage the seasons in this anime series.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildSeasonList(theme),
                  ],
                ),
              ),
              _buildBottomAction(theme),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSeasonList(ThemeData theme) {
    final seasons = _controller.seasons;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: seasons.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
              child: Column(
                children: [
                  Icon(
                    Icons.auto_stories_outlined,
                    size: 42,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No seasons yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Create the first season for this series.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                for (int i = 0; i < seasons.length; i++)
                  _buildSeasonRow(
                    theme,
                    seasons[i],
                    isLast: i == seasons.length - 1,
                  ),
              ],
            ),
    );
  }

  Widget _buildSeasonRow(
    ThemeData theme,
    SeasonModel season, {
    required bool isLast,
  }) {
    return Material(
      color: theme.colorScheme.surface,
      child: InkWell(
        onTap: () async {
          final updatedSeason = await Navigator.of(context).push<SeasonModel>(
            MaterialPageRoute(
              builder: (_) =>
                  EpisodesScreen(season: season, settings: widget.settings, projectName: widget.projectName,),
            ),
          );

          if (updatedSeason == null || !mounted) {
            return;
          }

          _controller.updateSeason(updatedSeason);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: isLast
                ? null
                : Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.surfaceContainerHighest,
                    ),
                  ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.movie_creation_outlined),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      season.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      _controller.getEpisodeLabel(season),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
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
                icon: const Icon(Icons.edit_outlined),
              ),

              IconButton(
                tooltip: 'More options',
                onPressed: () {
                  _showSeasonMenu(season);
                },
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomAction(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.96),
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _controller.isBusy ? null : _createSeason,
            icon: const Icon(Icons.add),
            label: const Text('Create Season'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: const StadiumBorder(),
            ),
          ),
        ),
      ),
    );
  }
}
