import 'package:flutter/material.dart';
import 'package:flutter_application_1/anime_editor/controllers/anime_editor_controller.dart';
import 'package:flutter_application_1/anime_editor/widgets/dialogs/frames_viewer_screen.dart';

class MoreOptionsSheet extends StatefulWidget {
  final AnimeEditorController controller;

  const MoreOptionsSheet({
    super.key,
    required this.controller,
  });

  @override
  State<MoreOptionsSheet> createState() => _MoreOptionsSheetState();
}
class _MoreOptionsSheetState extends State<MoreOptionsSheet> {
  bool onionSkin = false;
  bool showGrid = true;
  bool framesViewer = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "More Options",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            ListTile(
              leading: const Icon(Icons.folder_open_rounded),
              title: const Text("Import Project"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.image_rounded),
              title: const Text("Add Image"),
              onTap: () {},
            ),

            SwitchListTile(
              secondary: const Icon(Icons.visibility_rounded),
              title: const Text("Onion Skin"),
              value: onionSkin,
              onChanged: (v) => setState(() => onionSkin = v),
            ),

            SwitchListTile(
              secondary: const Icon(Icons.grid_on_rounded),
              title: const Text("Show Grid"),
              value: showGrid,
              onChanged: (v) => setState(() => showGrid = v),
            ),

            ListTile(
  leading: const Icon(Icons.video_library_rounded),
  title: const Text("Frames Viewer"),
  trailing: const Icon(Icons.chevron_right_rounded),
  onTap: () {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FramesViewerScreen(
          controller: widget.controller,
        ),
      ),
    );
  },
),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
