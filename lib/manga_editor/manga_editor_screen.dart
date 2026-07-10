import 'package:flutter/material.dart';

class MangaEditorScreen extends StatelessWidget {

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
  "type": "manga",
  "pages": pages,
  "size": size,
  "thumbnail": Icons.menu_book,
});

          },

          child: const Text("Save"),

        ),
      ),
    );
  }
}