import 'package:flutter/material.dart';
import 'add_frames_dialog.dart';
import '../../anime_editor/controllers/frame_manager.dart';
import 'frame_popup_menu.dart';

class BottomBar extends StatelessWidget {
final FrameManager frameManager;

final VoidCallback onPrevious;
final VoidCallback onPlay;
final VoidCallback onNext;
final VoidCallback onLayers;

const BottomBar({
  super.key,
  required this.frameManager,
  required this.onPrevious,
  required this.onPlay,
  required this.onNext,
  required this.onLayers,
});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.black12,
          ),
        ),
      ),
      child: Row(
        children: [
          // Playback Controls
          IconButton(
            onPressed: onPrevious,
            icon: const Icon(Icons.skip_previous),
            tooltip: "Previous",
          ),
          IconButton(
            onPressed: onPlay,
            icon: const Icon(Icons.play_arrow),
            tooltip: "Play",
          ),
          IconButton(
            onPressed: onNext,
            icon: const Icon(Icons.skip_next),
            tooltip: "Next",
          ),

          const SizedBox(width: 8),

          // Layers
          IconButton(
            onPressed: onLayers,
            icon: const Icon(Icons.layers_outlined),
            tooltip: "Layers",
          ),

          const SizedBox(width: 12),

          // Timeline
          Expanded(
  child: AnimatedBuilder(
    animation: frameManager,
    builder: (context, child) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...List.generate(
  frameManager.frames.length,
  (index) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: GestureDetector(
  onTapDown: (details) async {
    if (index != frameManager.selectedFrame) {
      frameManager.selectFrame(index);
      return;
    }

    final action = await showFramePopupMenu(
      context,
      details.globalPosition,
    );

    switch (action) {
      case FrameAction.addBefore:
        frameManager.addFrameBefore(index);
        break;

      case FrameAction.addAfter:
        frameManager.addFrameAfter(index);
        break;

      case FrameAction.duplicate:
        frameManager.duplicateFrame(index);
        break;

      case FrameAction.delete:
        frameManager.deleteFrame(index);
        break;

      case null:
        break;
    }
  },

  child: _frameBox(
    number: "${frameManager.frames[index]}",
    selected: index == frameManager.selectedFrame,
  ),
)
  ),
),
            _addFrameBox(context),
          ],
        ),
      );
    },
  ),
),
        ],
      ),
    );
  }

  Widget _addFrameBox(BuildContext context) {
  return InkWell(
    onTap: () async {
      final count = await showDialog<int>(
        context: context,
        builder: (_) => const AddFramesDialog(),
      );

      if (count != null) {
        frameManager.addFrames(count);
      }
    },
    borderRadius: BorderRadius.circular(8),
    child: Container(
      width: 72,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black26,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(
          Icons.add,
          size: 28,
        ),
      ),
    ),
  );
}

  Widget _frameBox({
    required String number,
    bool selected = false,
  }) {
    return Container(
      width: 72,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: selected ? Colors.pink : Colors.black26,
          width: selected ? 3 : 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 4,
            right: 6,
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}