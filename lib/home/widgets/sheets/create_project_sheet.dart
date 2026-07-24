import 'package:flutter/material.dart';

Future<String?> showCreateProjectSheet(
  BuildContext context,
) {
  return showModalBottomSheet<String>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Create Project",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            ListTile(
  leading: const Icon(Icons.tv),
  title: const Text("Anime Series"),
  onTap: () {
    Navigator.pop(context, "anime_series");
  },
),

ListTile(
  leading: const Icon(Icons.movie_creation),
  title: const Text("Anime Movie"),
  onTap: () {
    Navigator.pop(context, "anime_movie");
  },
),

ListTile(
  leading: const Icon(Icons.menu_book),
  title: const Text("Manga Series"),
  onTap: () {
    Navigator.pop(context, "manga_series");
  },
),

ListTile(
  leading: const Icon(Icons.book),
  title: const Text("Manga Book"),
  onTap: () {
    Navigator.pop(context, "manga_book");
  },
),
          ],
        ),
      );
    },
  );
}