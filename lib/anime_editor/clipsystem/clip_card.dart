import 'package:flutter/material.dart';
import '../models/clip_model.dart';

class ClipCard extends StatelessWidget {
  final ClipModel clip;
  final VoidCallback? onTap;
  final bool isSelected;
  final int index;
  final VoidCallback? onRename;

  const ClipCard({
  super.key,
  required this.index,
  required this.clip,
  this.onTap,
  this.onRename,
  this.isSelected = false,
});

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

final thumbnailHeight =
    screenWidth < 600 ? 180.0 : 240.0;
    return ReorderableDelayedDragStartListener(
  index: index,
  child: Card(
      elevation: isSelected ? 4 : 1,
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [

    Container(
      height: thumbnailHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Icon(
          Icons.image,
          size: 60,
          color: Colors.grey,
        ),
      ),
    ),

    const SizedBox(height: 12),

    Row(
  children: [
    Expanded(
      child: Text(
        clip.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    IconButton(
      icon: const Icon(Icons.edit, size: 20),
      onPressed: onRename,
    ),
  ],
),

    const SizedBox(height: 6),

    Text(
      "${_formatDuration(clip.durationSeconds)} • ${clip.frameCount} Frames",
      style: TextStyle(
        color: Colors.grey.shade700,
      ),
    ),
  ],
)
        ),
      ),
        ),
);
  }
}