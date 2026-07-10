import 'package:flutter/material.dart';
import '../controllers/manga_editor_controller.dart';

class MangaEditorScreen extends StatefulWidget {
  final String projectName;
  final int pages;
  final String size;
  const MangaEditorScreen({
    super.key,
    required this.projectName,
    required this.pages,
    required this.size,
  });
  @override
  State<MangaEditorScreen> createState() =>
      _MangaEditorScreenState();
}
class _MangaEditorScreenState extends State<MangaEditorScreen> {
  late MangaEditorController controller;
  @override
  void initState() {
    super.initState();

    controller = MangaEditorController(
      projectName: widget.projectName,
      pages: widget.pages,
      size: widget.size,
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
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Text(
              controller.size,
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              "${controller.pages} Pages",
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