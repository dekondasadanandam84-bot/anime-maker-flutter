import 'package:flutter/material.dart';
import '../../controllers/anime_editor_controller.dart';

void showFrameActionsDialog(
  BuildContext context,
  AnimeEditorController controller, {
  required VoidCallback onUpdate,
}) {
  showDialog(
    context: context,
    builder: (_) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_left),
                onPressed: () {
                  Navigator.pop(context);
                  controller.addBefore(controller.selectedFrame);
                  onUpdate();
                },
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Navigator.pop(context);
                  controller.duplicateFrame(controller.selectedFrame);
                  onUpdate();
                },
              ),
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_right),
                onPressed: () {
                  Navigator.pop(context);
                  controller.addAfter(controller.selectedFrame);
                  onUpdate();
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  Navigator.pop(context);
                  controller.deleteFrame(controller.selectedFrame);
                  onUpdate();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}