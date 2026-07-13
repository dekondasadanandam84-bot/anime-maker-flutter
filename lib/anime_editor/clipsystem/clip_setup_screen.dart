import 'package:flutter/material.dart';
import 'package:flutter_application_1/anime_editor/screens/anime_editor_screen.dart';
import 'clip_card.dart';
import 'clip_controller.dart';
import '../models/project_model.dart';

class ClipSetupScreen extends StatefulWidget {
final ProjectModel project;

  const ClipSetupScreen({
  super.key,
  required this.project,
});

  @override
  State<ClipSetupScreen> createState() => _ClipSetupScreenState();
}

class _ClipSetupScreenState extends State<ClipSetupScreen> {
  late ClipController controller;

  @override
  void initState() {
    super.initState();

      controller = ClipController(
  project: widget.project,
);

  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clip Setup"),
        centerTitle: true,
        actions: [
    IconButton(
  icon: const Icon(Icons.save),
  onPressed: () {

   widget.project.clips = controller.clips;

    Navigator.pop(
      context,
      {
        "id": widget.project.id,
        "name": widget.project.name,
        "type": "anime",
        "ratio": widget.project.ratio,
        "fps": widget.project.fps,
        "clips": controller.clips,
      },
    );
  },
),
  ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _infoRow("Project", widget.project.name),
                    const SizedBox(height: 8),
                    _infoRow("Aspect Ratio", widget.project.ratio),
                    const SizedBox(height: 8),
                    _infoRow("FPS", "${widget.project.fps}"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Clips",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
  setState(() {
    controller.addClip();
  });
},
                  icon: const Icon(Icons.add),
                  label: const Text("Add Clip"),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Expanded(
            child: ReorderableListView.builder(
            itemCount: controller.clips.length,

            onReorderItem: (oldIndex, newIndex) {
            setState(() {
            controller.reorderClips(oldIndex, newIndex);
          });
        },

    itemBuilder: (context, index) {
      return ClipCard(
  key: ValueKey(controller.clips[index]),
  index: index,
  clip: controller.clips[index],
  isSelected: index == controller.selectedClipIndex,
  onTap: () async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => AnimeEditorScreen(
  project: widget.project,
)
    ),
  );

  setState(() {});
},
    onRename: () => _renameClip(index),
);
    },
  ),
),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Text(value),
      ],
    );
  }
  Future<void> _renameClip(int index) async {
  final textController = TextEditingController(
    text: controller.clips[index].name,
  );

  final newName = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Rename Clip"),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Clip name",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                context,
                textController.text.trim(),
              );
            },
            child: const Text("Rename"),
          ),
        ],
      );
    },
  );

  if (newName != null && newName.isNotEmpty) {
    setState(() {
      controller.renameClip(index, newName);
    });
  }
}
}