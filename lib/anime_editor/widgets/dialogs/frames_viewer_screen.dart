import 'package:flutter/material.dart';
import 'package:flutter_application_1/anime_editor/controllers/anime_editor_controller.dart';

class FramesViewerScreen extends StatefulWidget {
  final AnimeEditorController controller;

  const FramesViewerScreen({
    super.key,
    required this.controller,
  });

  @override
  State<FramesViewerScreen> createState() => _FramesViewerScreenState();
}

class _FramesViewerScreenState extends State<FramesViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Frames Viewer",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Text(
              "${widget.controller.frames.length} Frames",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),

          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: widget.controller.frames.length,
              onReorderItem: (oldIndex, newIndex) {
  setState(() {
    widget.controller.reorderFrames(
      oldIndex,
      newIndex,
    );
  });
},
              itemBuilder: (context, index) {
                final frame = widget.controller.frames[index];
                final selected =
                    widget.controller.selectedFrame == index;

                return Card(
                  key: ValueKey(frame),
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: selected ? 5 : 1,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: selected
                          ? Colors.pink
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),

                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),

                    onTap: () {
                      setState(() {
                        widget.controller.selectFrame(index);
                      });
                    },

                    leading: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.movie_creation_outlined,
                        size: 36,
                      ),
                    ),

                    title: Text(
                      "Frame ${index + 1}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),

                    subtitle: Text(
                      selected
                          ? "Currently Selected"
                          : "Tap to select",
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy_rounded),
                          onPressed: () {
                            
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded),
                          onPressed: () {
                            
                          },
                        ),
                        const Icon(Icons.drag_handle_rounded),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.check),
        label: const Text("Done"),
      ),
    );
  }
}