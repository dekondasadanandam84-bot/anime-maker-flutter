import 'package:flutter/material.dart';
import '../models/frame_model.dart';

class FrameManager extends StatelessWidget {
  final List<FrameModel> frames;
  final int selectedFrame;
  final VoidCallback onAddFrame;
  final Function(int) onSelectFrame;
  final Function(int) onFrameDoubleTap;
 

  const FrameManager({
    super.key,
    required this.frames,
    required this.selectedFrame,
    required this.onAddFrame,
    required this.onSelectFrame,
    required this.onFrameDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    const frameWidth = 78.0;
    const spacing = 12.0;

    return SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
        ...List.generate(frames.length, (index) {
          final isSelected = selectedFrame == index;

          return GestureDetector(
  onTap: () => onSelectFrame(index),
  onDoubleTap: () {
    if (selectedFrame == index) {
      onFrameDoubleTap(index);
    }
  },
            child: Container(
  width: frameWidth,
  height: 56,
  margin: const EdgeInsets.only(right: spacing),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      color: isSelected ? Colors.pink : Colors.black26,
      width: isSelected ? 2 : 1,
    ),
  ),
  child: Stack(
    children: [
      Positioned(
        top: 4,
        right: 6,
        child: Text(
          "${frames[index].number}",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.pink : Colors.black54,
          ),
        ),
      ),
    ],
  ),
),
          );
        }),

        GestureDetector(
  onTap: onAddFrame,
  child: Container(
    width: 78,
    height: 56,
    margin: const EdgeInsets.only(left: 12),
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.black26),
    ),
    child: const Icon(Icons.add),
  ),
),
            ],
    ),
  );
  }
}