import 'package:flutter/material.dart';
import '../../controllers/anime_editor_controller.dart';
import '../frame_manager.dart';

class BottomPanel extends StatelessWidget {
  final AnimeEditorController controller;
  final VoidCallback onAddFrame;
  final VoidCallback onFrameLongPress;
  final VoidCallback onUpdate;

  const BottomPanel({
    super.key,
    required this.controller,
    required this.onAddFrame,
    required this.onFrameLongPress,
    required this.onUpdate
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
  height: 90,
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          // Playback Controls
          IconButton(
            icon: const Icon(Icons.skip_previous_rounded),
            onPressed: () {
              
            },
          ),

          IconButton(
            icon: const Icon(Icons.play_arrow_rounded),
            onPressed: () {
              
            },
          ),

          IconButton(
            icon: const Icon(Icons.skip_next_rounded),
            onPressed: () {
              
            },
          ),

          const SizedBox(width: 12),

          // Layers Button
          IconButton(
            icon: const Icon(Icons.layers_rounded),
            onPressed: () {
              
            },
          ),

          const SizedBox(width: 16),

          // Timeline
          Expanded(
            child: FrameManager(
  frames: controller.frames,
  selectedFrame: controller.selectedFrame,
  onAddFrame: onAddFrame,
  onSelectFrame: (i) {
  if (controller.selectedFrame == i) {
    onFrameLongPress();
    return;
  }

  controller.selectFrame(i);
  onUpdate();
},
  onFrameDoubleTap: (i) {
    onFrameLongPress();
  },
)
      )],
      ),
    ));
  }
}