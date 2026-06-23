import 'package:flutter/material.dart';

class AnimeEditorScreen extends StatelessWidget {
  final String projectName;

  const AnimeEditorScreen({
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
      "thumbnail": Icons.movie,
    });
  },
  child: const Text("Save"),
),
      ),
    );
  }
}