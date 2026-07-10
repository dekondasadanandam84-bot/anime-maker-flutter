import 'package:flutter/material.dart';
import '../../controllers/anime_editor_controller.dart';

void showAddFrameDialog(
  BuildContext context,
  AnimeEditorController controller, {
  required VoidCallback onUpdate,
}) {
  int selected = 1;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text("Add Frames"),
            content: SizedBox(
              width: 320,
              height: 260,
              child: Column(
                children: [
                  // HEADER TEXT
                  Text(
                    "$selected frame(s)",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // GRID
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        childAspectRatio: 1,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
                      ),
                      itemCount: 24,
                      itemBuilder: (context, index) {
                        final value = index + 1;
                        final isSelected = selected == value;

                        return GestureDetector(
                          onTap: () {
                            setStateDialog(() {
                              selected = value;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.pink
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                "$value",
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // ACTIONS
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);

                  controller.addFrames(selected);

                  onUpdate(); // refresh UI
                },
                child: const Text("Add"),
              ),
            ],
          );
        },
      );
    },
  );
}