import 'package:flutter/material.dart';

import 'episodes_controller.dart';
import '../models/season_model.dart';
import '../models/episode_model.dart';
import 'clips_ui.dart';
import '../models/project_settings_model.dart';

class EpisodesScreen extends StatefulWidget {
  const EpisodesScreen({
  super.key,
  required this.season,
  required this.settings,
  this.controller,
  this.onSeasonChanged,
  required this.projectName,
});

final SeasonModel season;
final ProjectSettingsModel settings;
final EpisodesController? controller;
final ValueChanged<SeasonModel>? onSeasonChanged;

   final String projectName;
  

  @override
  State<EpisodesScreen> createState() => _EpisodesScreenState();
}

class _EpisodesScreenState extends State<EpisodesScreen> {
  late final EpisodesController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();

    _ownsController = widget.controller == null;

    _controller =
        widget.controller ?? EpisodesController(season: widget.season);
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  Future<void> _createEpisode() async {
    final number = _controller.nextEpisodeNumber;
    final nameController = TextEditingController();

    final create = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Create Episode'),
        content: TextField(
          controller: nameController,
          autofocus: true,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: 'Episode Name',
            hintText: 'Leave empty for Episode $number',
          ),
          onSubmitted: (_) => Navigator.of(dialogContext).pop(true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Create Episode'),
          ),
        ],
      ),
    );

    final name = nameController.text.trim();
    nameController.dispose();

    if (create != true || !mounted) return;
    await _controller.createEpisode(name: name);
  }

  Future<void> _renameEpisode(EpisodeModel episode) async {
    final controller = TextEditingController(text: episode.name);

    final save = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Rename Episode ${episode.episodeNumber}'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: 'Episode Name',
            hintText: 'Episode ${episode.episodeNumber}',
          ),
          onSubmitted: (_) => Navigator.of(dialogContext).pop(true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    final name = controller.text.trim();
    controller.dispose();
    if (save != true || !mounted) return;

    await _controller.renameEpisode(episodeId: episode.id, newName: name);
  }

  Future<void> _deleteEpisode(EpisodeModel episode) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Episode?'),
        content: Text(
          'Are you sure you want to delete "${episode.displayName}"? '
          'This action cannot be undone and will remove all clips within.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    await _controller.deleteEpisode(episode.id);
  }

  void _showEpisodeMenu(EpisodeModel episode) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Rename'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _renameEpisode(episode);
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
                _deleteEpisode(episode);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showSeasonMenu() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListTile(
          leading: const Icon(Icons.refresh_outlined),
          title: const Text('Refresh'),
          onTap: () => Navigator.of(sheetContext).pop(),
        ),
      ),
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
  Navigator.of(context).pop(
    _controller.season,
  );
},
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            tooltip: 'More options',
            onPressed: _showSeasonMenu,
            icon: const Icon(Icons.more_vert),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: theme.colorScheme.outlineVariant),
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
              widget.season.displayName,
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
        builder: (context, _) => Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 120),
                children: [
                  _controller.episodes.isEmpty
                      ? _buildEmptyState(theme)
                      : _buildEpisodeList(theme),
                ],
              ),
            ),
            _buildBottomAction(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildEpisodeList(ThemeData theme) {
    final episodes = _controller.episodes;

    return Column(
      children: [
        for (int i = 0; i < episodes.length; i++)
          _buildEpisodeRow(
            theme,
            episodes[i],
            isLast: i == episodes.length - 1,
          ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text(
            'End of season',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEpisodeRow(
  ThemeData theme,
  EpisodeModel episode, {
  required bool isLast,
}) {
  final empty = episode.clipCount == 0;

  return Material(
    color: theme.colorScheme.surface,
    child: InkWell(
      onTap: () async {
        final updatedEpisode =
            await Navigator.of(context).push<EpisodeModel>(
          MaterialPageRoute(
            builder: (_) => ClipsScreen(
              projectName: widget.projectName,
              episode: episode,
              settings: widget.settings,
            ),
          ),
        );

        if (updatedEpisode == null || !mounted) {
          return;
        }

        _controller.updateEpisode(updatedEpisode);
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
                color: theme.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.video_library_outlined,
                color: empty
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                    : theme.colorScheme.onSurface,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _controller.getClipLabel(episode),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              tooltip: 'Rename',
              onPressed: () => _renameEpisode(episode),
              icon: const Icon(Icons.edit_outlined),
            ),

            IconButton(
              tooltip: 'More options',
              onPressed: () => _showEpisodeMenu(episode),
              icon: const Icon(Icons.more_horiz),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildEmptyState(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant,
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
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.96),
        border: Border(
          top: BorderSide(color: theme.colorScheme.surfaceContainerHighest),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _controller.isBusy ? null : _createEpisode,
            icon: const Icon(Icons.add),
            label: const Text('Create Episode'),
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
