import 'package:flutter/material.dart';

class MangaEditorScreen extends StatelessWidget {
  final String projectName;

  const MangaEditorScreen({
    super.key,
    required this.projectName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(projectName),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              "name": projectName,
              "type": "manga",
              "thumbnail": Icons.menu_book,
            });
          },
          child: const Text("Save"),
        ),
      ),
    );
  }
}