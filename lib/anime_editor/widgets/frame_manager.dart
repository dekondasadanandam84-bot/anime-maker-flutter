import 'package:flutter/material.dart';
import '../models/frame_model.dart';

class FrameManager extends StatelessWidget {
  final List<FrameModel> frames;
  final int selectedFrame;
  final VoidCallback onAddFrame;
  final Function(int) onSelectFrame;

  const FrameManager({
    super.key,
    required this.frames,
    required this.selectedFrame,
    required this.onAddFrame,
    required this.onSelectFrame,
  });

  @override
  Widget build(BuildContext context) {
    const frameWidth = 78.0;
    const spacing = 12.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(frames.length, (index) {
          final isSelected = selectedFrame == index;

          return GestureDetector(
            onTap: () => onSelectFrame(index),
            child: Container(
              width: frameWidth,
              height: 56,
              margin: const EdgeInsets.only(right: spacing),
              decoration: BoxDecoration(
                color: isSelected ? Colors.deepPurple : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black26),
              ),
              child: Center(
                child: Text(
                  "${frames[index].number}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        }),

        GestureDetector(
          onTap: onAddFrame,
          child: Container(
            width: frameWidth,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black26),
            ),
            child: const Center(
              child: Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}