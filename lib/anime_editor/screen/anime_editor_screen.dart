import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimeEditorScreen extends StatefulWidget {
  final String projectName;

  const AnimeEditorScreen({
    super.key,
    required this.projectName,
  });

  @override
  State<AnimeEditorScreen> createState() => _AnimeEditorScreenState();
}

class _AnimeEditorScreenState extends State<AnimeEditorScreen> {

  @override
  void initState() {
    super.initState();

    // 📱 LOCK LANDSCAPE ONLY ON MOBILE
    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  @override
  void dispose() {
    // 📱 RESET TO PORTRAIT ONLY ON MOBILE
    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🧠 TOP BAR
      appBar: AppBar(
        title: Text(widget.projectName),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              Navigator.pop(context, {
              "name": widget.projectName,
              "type": "anime",
               "thumbnail": Icons.movie,
              "location": "Local Storage",
               });
            }
          ),
        ],
      ),

      // 🎬 EDITOR LAYOUT
      body: Row(
        children: [
          // 🎨 TOOLBAR (LEFT)
          Container(
            width: 70,
            color: Colors.grey.shade900,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.brush, color: Colors.white),
                  onPressed: () {},
                ),
                const SizedBox(height: 20),

                IconButton(
                  icon: const Icon(Icons.auto_fix_off, color: Colors.white),
                  onPressed: () {},
                ),
                const SizedBox(height: 20),

                IconButton(
                  icon: const Icon(Icons.text_fields, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // 🎬 CANVAS AREA
          Expanded(
            child: Container(
              color: Colors.black12,
              child: const Center(
                child: Text(
                  "Canvas Area",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}