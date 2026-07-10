import 'package:flutter/material.dart';
import '../controllers/anime_editor_controller.dart';

class AnimeEditorScreen extends StatefulWidget {
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
  State<AnimeEditorScreen> createState() => _AnimeEditorScreenState();
}
class _AnimeEditorScreenState extends State<AnimeEditorScreen> {
  late AnimeEditorController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimeEditorController(
      projectName: widget.projectName,
      ratio: widget.ratio,
      fps: widget.fps,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.projectName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              controller.ratio,
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              "${controller.fps} FPS",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  controller.saveProject(),
                );
              },
              child: const Text(
                "Save Project",
              ),
            ),
          ],
        ),
      ),
    );
  }
}