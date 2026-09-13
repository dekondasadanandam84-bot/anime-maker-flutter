import 'package:flutter/material.dart';

import 'create_project_screen.dart';
import 'project_controller.dart';
import 'project_scope.dart';

class CreateProjectButton extends StatelessWidget {
  const CreateProjectButton({super.key});

  // ==========================================================================
  // OPEN CREATE SHEET
  // ==========================================================================

  void _openCreateProjectSheet(BuildContext context) {
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: isLandscape ? const BoxConstraints.expand() : null,
      builder: (_) => const _CreateProjectSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: () => _openCreateProjectSheet(context),
        customBorder: const CircleBorder(),
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.add_rounded,
            color: colorScheme.onPrimary,
            size: 32,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// CREATE PROJECT SHEET
// ============================================================================

class _CreateProjectSheet extends StatelessWidget {
  const _CreateProjectSheet();

  // ==========================================================================
  // SELECT PROJECT TYPE
  // ==========================================================================

  void _selectProjectType(BuildContext context, CreateProjectOption type) {
    final projectController = ProjectScope.read(context);

    Navigator.of(context).pop();

    switch (type) {
      case CreateProjectOption.animeSeries:
        projectController.beginCreateProject(ProjectFlowType.animeSeries);

        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const CreateProjectScreen()));

      case CreateProjectOption.animeMovie:
        projectController.beginCreateProject(ProjectFlowType.animeMovie);

        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const CreateProjectScreen()));

      case CreateProjectOption.mangaSeries:
        projectController.beginCreateProject(ProjectFlowType.mangaSeries);

        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const CreateProjectScreen()));

      case CreateProjectOption.mangaBook:
        projectController.beginCreateProject(ProjectFlowType.mangaBook);

        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const CreateProjectScreen()));

      case CreateProjectOption.importProject:
        debugPrint('Import Project');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final size = MediaQuery.sizeOf(context);

    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;

    final isCompact = size.width < 380;

    final sheetHorizontalPadding = isCompact
        ? 16.0
        : isLandscape
        ? 20.0
        : 20.0;

    final sheetVerticalPadding = isLandscape ? 10.0 : 12.0;

    final titleSize = isCompact
        ? 20.0
        : isLandscape
        ? 20.0
        : 22.0;

    final subtitleSize = isCompact ? 13.0 : 14.0;

    final optionSpacing = isLandscape ? 8.0 : 10.0;

    final optionPadding = isLandscape ? 11.0 : 14.0;

    final iconBoxSize = isLandscape ? 42.0 : 48.0;

    final iconSize = isLandscape ? 22.0 : 25.0;

    return Container(
      width: double.infinity,
      height: isLandscape ? size.height : null,
      constraints: BoxConstraints(
        maxHeight: isLandscape ? size.height : size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: isLandscape
            ? BorderRadius.zero
            : const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          sheetHorizontalPadding,
          sheetVerticalPadding,
          sheetHorizontalPadding,
          20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ==========================================================
            // HANDLE
            // ==========================================================
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            SizedBox(height: isLandscape ? 12 : 18),

            // ==========================================================
            // TITLE
            // ==========================================================
            Text(
              'Create Project',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: titleSize,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              'Choose a project type',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: subtitleSize,
                height: 1.3,
              ),
            ),

            SizedBox(height: isLandscape ? 14 : 20),

            // ==========================================================
            // ANIME SERIES
            // ==========================================================
            _CreateProjectOption(
              icon: Icons.tv_outlined,
              iconColor: colorScheme.primary,
              title: 'Anime Series',
              description:
                  'Create an episodic anime project with seasons and episodes.',
              padding: optionPadding,
              iconBoxSize: iconBoxSize,
              iconSize: iconSize,
              compact: isCompact,
              onTap: () =>
                  _selectProjectType(context, CreateProjectOption.animeSeries),
            ),

            SizedBox(height: optionSpacing),

            // ==========================================================
            // ANIME MOVIE
            // ==========================================================
            _CreateProjectOption(
              icon: Icons.movie_outlined,
              iconColor: colorScheme.primary,
              title: 'Anime Movie',
              description: 'Create a long-form animated movie project.',
              padding: optionPadding,
              iconBoxSize: iconBoxSize,
              iconSize: iconSize,
              compact: isCompact,
              onTap: () =>
                  _selectProjectType(context, CreateProjectOption.animeMovie),
            ),

            SizedBox(height: optionSpacing),

            // ==========================================================
            // MANGA SERIES
            // ==========================================================
            _CreateProjectOption(
              icon: Icons.auto_stories_outlined,
              iconColor: colorScheme.primary,
              title: 'Manga Series',
              description: 'Create a manga series containing multiple books.',
              padding: optionPadding,
              iconBoxSize: iconBoxSize,
              iconSize: iconSize,
              compact: isCompact,
              onTap: () =>
                  _selectProjectType(context, CreateProjectOption.mangaSeries),
            ),

            SizedBox(height: optionSpacing),

            // ==========================================================
            // MANGA BOOK
            // ==========================================================
            _CreateProjectOption(
              icon: Icons.menu_book_outlined,
              iconColor: colorScheme.primary,
              title: 'Manga Book',
              description: 'Create a standalone manga book project.',
              padding: optionPadding,
              iconBoxSize: iconBoxSize,
              iconSize: iconSize,
              compact: isCompact,
              onTap: () =>
                  _selectProjectType(context, CreateProjectOption.mangaBook),
            ),

            SizedBox(height: optionSpacing),

            // ==========================================================
            // IMPORT
            // ==========================================================
            _CreateProjectOption(
              icon: Icons.file_upload_outlined,
              iconColor: colorScheme.primary,
              title: 'Import Project',
              description: 'Import an existing AnimeClip project file.',
              padding: optionPadding,
              iconBoxSize: iconBoxSize,
              iconSize: iconSize,
              compact: isCompact,
              onTap: () => _selectProjectType(
                context,
                CreateProjectOption.importProject,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// PROJECT OPTION
// ============================================================================

class _CreateProjectOption extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final VoidCallback onTap;

  final double padding;
  final double iconBoxSize;
  final double iconSize;
  final bool compact;

  const _CreateProjectOption({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.onTap,
    required this.padding,
    required this.iconBoxSize,
    required this.iconSize,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: compact ? 9 : 12,
            horizontal: 4,
          ),
          child: Row(
            children: [
              Container(
                width: iconBoxSize,
                height: iconBoxSize,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(compact ? 10 : 12),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: iconColor, size: iconSize),
              ),

              SizedBox(width: compact ? 11 : 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: compact ? 14 : 15,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      description,
                      maxLines: compact ? 2 : 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: compact ? 11 : 12.5,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
                size: compact ? 21 : 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// CREATE PROJECT OPTIONS
// ============================================================================

enum CreateProjectOption {
  animeSeries,
  animeMovie,
  mangaSeries,
  mangaBook,
  importProject,
}
