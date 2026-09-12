import 'package:flutter/material.dart';

class ProjectCardUI extends StatelessWidget {
  const ProjectCardUI({
    super.key,
    required this.title,
    required this.emoji,
    this.onEdit,
    this.onDelete,
    this.onDownload,
  });

  final String title;
  final String emoji;

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onDownload;

  void _showMenu(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: colorScheme.surface,
      builder: (sheetContext) {
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
                  'Edit',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                  ),
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  onEdit?.call();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: colorScheme.onSurface,
                ),
                title: Text(
                  'Delete',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                  ),
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  onDelete?.call();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.download_outlined,
                  color: colorScheme.onSurface,
                ),
                title: Text(
                  'Download',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                  ),
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  onDownload?.call();
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
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==========================================================
          // THUMBNAIL
          // ==========================================================
          Container(
            width: 160,
            height: 120,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(18),
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
              child: Text(
                emoji,
                style: const TextStyle(
                  fontSize: 48,
                ),
              ),
            ),
          ),

          const SizedBox(height: 9),

          // ==========================================================
          // TITLE + THREE DOTS
          // ==========================================================
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                    height: 1.25,
                  ),
                ),
              ),

              SizedBox(
                width: 30,
                height: 30,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  splashRadius: 18,
                  onPressed: () => _showMenu(context),
                  icon: Icon(
                    Icons.more_vert,
                    size: 21,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}