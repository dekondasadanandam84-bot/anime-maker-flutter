import 'package:flutter/material.dart';

class AnimeEditorScreen extends StatelessWidget {
  final String projectName;
  final String ratio;
  final int fps;

  const AnimeEditorScreen({
    super.key,
    required this.projectName,
    required this.ratio,
    required this.fps,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(projectName),
      ),

      body: Center(
        child: ElevatedButton(
          onPressed: () {

            Navigator.pop(context, {
  "name": projectName,
  "type": "anime",
  "ratio": ratio,
  "fps": fps,
  "thumbnail": Icons.animation,
});

          },
          child: const Text("Save"),
        ),
      ),
    );
  }
}