import 'package:flutter/material.dart';

class ProjectCardUI extends StatelessWidget {
  const ProjectCardUI({
    super.key,
    required this.title,
    required this.icon,

    // Kept temporarily so your current HomeUI call does not break.
    // It is no longer displayed.
    this.emoji,

    this.onEdit,
    this.onDelete,
    this.onDownload,
  });

  final String title;
  final IconData icon;

  /// Legacy compatibility with the previous HomeUI implementation.
  /// The UI no longer uses emojis.
  final String? emoji;

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onDownload;

  // ==========================================================================
  // MENU
  // ==========================================================================

  void _showMenu(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: colorScheme.surface,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 8,
            ),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ProjectActionTile(
                  icon: Icons.edit_outlined,
                  title: 'Edit',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    onEdit?.call();
                  },
                ),

                _ProjectActionTile(
                  icon: Icons.delete_outline_rounded,
                  title: 'Delete',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    onDelete?.call();
                  },
                ),

                _ProjectActionTile(
                  icon: Icons.download_outlined,
                  title: 'Download',
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    onDownload?.call();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ==================================================================
          // PROJECT THUMBNAIL
          // FIXED 160 × 120
          // ==================================================================

          SizedBox(
            width: 160,
            height: 120,
            child: Material(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(
                        alpha: 0.06,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 42,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 6),

          // ==================================================================
          // PROJECT TITLE + MENU
          // ==================================================================

          SizedBox(
            height: 32,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                  ),
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                      height: 1.15,
                    ),
                  ),
                ),

                Positioned(
                  right: 0,
                  top: 0,
                  child: SizedBox(
                    width: 30,
                    height: 32,
                    child: IconButton(
                      onPressed: () => _showMenu(context),
                      padding: EdgeInsets.zero,
                      tooltip: 'Project options',
                      constraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 32,
                      ),
                      icon: Icon(
                        Icons.more_vert_rounded,
                        size: 20,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PROJECT ACTION TILE
// ============================================================================

class _ProjectActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProjectActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 13,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: colorScheme.onSurface,
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),

              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}