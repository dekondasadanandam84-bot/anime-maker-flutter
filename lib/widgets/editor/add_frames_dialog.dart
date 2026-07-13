import 'package:flutter/material.dart';

class AddFramesDialog extends StatefulWidget {
  const AddFramesDialog({super.key});

  @override
  State<AddFramesDialog> createState() => _AddFramesDialogState();
}

class _AddFramesDialogState extends State<AddFramesDialog> {
  int frameCount = 1;

  static const int maxFrames = 30;

  void _increase() {
    if (frameCount < maxFrames) {
      setState(() {
        frameCount++;
      });
    }
  }

  void _decrease() {
    if (frameCount > 1) {
      setState(() {
        frameCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text(
        "Add Frames",
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Number of Frames",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _decrease,
                icon: const Icon(Icons.remove_circle_outline),
              ),

              Container(
                width: 70,
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "$frameCount",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              IconButton(
                onPressed: _increase,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            "Maximum: 30 frames",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),

        FilledButton(
          onPressed: () {
            Navigator.pop(context, frameCount);
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}