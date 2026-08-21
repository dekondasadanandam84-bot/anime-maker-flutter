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
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  onEdit?.call();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  onDelete?.call();
                },
              ),
              ListTile(
                leading: const Icon(Icons.download_outlined),
                title: const Text('Download'),
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
              color: const Color(0xffF7F7F7),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xffEAEAEA)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 48)),
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
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
                  icon: const Icon(
                    Icons.more_vert,
                    size: 21,
                    color: Colors.black,
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
