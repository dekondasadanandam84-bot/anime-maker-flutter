
import 'package:flutter/material.dart';


class AnimeEditorScreen extends StatefulWidget {
  final String projectName;
 final String ratio;

  const AnimeEditorScreen({
    super.key,
    required this.projectName,
    this.ratio = "16:9",
  });

  @override
  State<AnimeEditorScreen> createState() => _AnimeEditorScreenState();
}

class _AnimeEditorScreenState extends State<AnimeEditorScreen> {


@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        // Background
        Container(
          color: Colors.grey.shade300,
        ),

        // Center Canvas
        Center(
          child: Container(
            width: widget.ratio == "16:9"
                ? 500
                : widget.ratio == "9:16"
                    ? 220
                    : widget.ratio == "1:1"
                        ? 350
                        : 420,
            height: widget.ratio == "16:9"
                ? 280
                : widget.ratio == "9:16"
                    ? 400
                    : widget.ratio == "1:1"
                        ? 350
                        : 315,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.black12,
                ),
              ],
            ),
            child: Center(
              child: Text(
                "${widget.ratio} Canvas",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),

        // Top Right Toolbar
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.undo, color: Colors.white),
                const SizedBox(width: 12),
                const Icon(Icons.redo, color: Colors.white),
                const SizedBox(width: 12),
                const Icon(Icons.music_note, color: Colors.white),
                const SizedBox(width: 12),
                const Icon(Icons.copy, color: Colors.white),
                const SizedBox(width: 12),
                const Icon(Icons.control_point_duplicate, color: Colors.white),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.save, color: Colors.white),
                  onPressed: () {


  Navigator.pop(context, {
    "name": widget.projectName,
    "type": "anime",
    "thumbnail": Icons.movie,
    "location": "Local Storage",
    "ratio": widget.ratio,
  });
}
                ),
                const SizedBox(width: 12),
                const Icon(Icons.workspace_premium, color: Colors.amber),
              ],
            ),
          ),
        ),

        // Left Tools
        Positioned(
          left: 16,
          top: 110,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            width: 70,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.brush, color: Colors.white),
                SizedBox(height: 20),
                Icon(Icons.auto_fix_off, color: Colors.white),
                SizedBox(height: 20),
                Icon(Icons.text_fields, color: Colors.white),
                SizedBox(height: 20),
                Icon(Icons.select_all, color: Colors.white),
                SizedBox(height: 20),
                Icon(Icons.format_color_fill, color: Colors.white),
              ],
            ),
          ),
        ),

        // Right Properties Panel
        Positioned(
          right: 16,
          top: 110,
          child: Container(
            width: 220,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text("Properties Panel"),
            ),
          ),
        ),

        // Bottom Timeline
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Container(
            height: 90,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.add, color: Colors.white),
                const SizedBox(width: 20),
                Expanded(
                  child: ListView(
                    reverse: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      _frameBox("Frame 1"),
                      _frameBox("Frame 2"),
                      _frameBox("Frame 3"),
                    ],
                  ),
                ),
                const Icon(Icons.skip_previous, color: Colors.white),
                const SizedBox(width: 12),
                const Icon(Icons.play_arrow, color: Colors.white),
                const SizedBox(width: 12),
                const Icon(Icons.skip_next, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

 Widget _frameBox(String text) {
  return Container(
    width: 90,
    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
    decoration: BoxDecoration(
      color: Colors.grey.shade700,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}
}