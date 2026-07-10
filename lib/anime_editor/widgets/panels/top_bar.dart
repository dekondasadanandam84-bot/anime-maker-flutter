import 'package:flutter/material.dart';
import 'package:flutter_application_1/anime_editor/controllers/anime_editor_controller.dart';
import 'package:flutter_application_1/anime_editor/widgets/panels/more_options_sheet.dart';

class TopBar extends StatelessWidget {
  final AnimeEditorController controller;
  final VoidCallback onSave;
  final String projectName;

  const TopBar({
    super.key,
    required this.controller,
    required this.projectName,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: [
            // LEFT
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                projectName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // CENTER
            Align(
           alignment: Alignment.center,
           child: _btn(
           Icons.fit_screen_rounded,
           onPressed: controller.canvasController.fitToScreen,
           ),
          ),

            // RIGHT
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _btn(Icons.undo),
                  _btn(Icons.redo),
                  _btn(Icons.content_copy_rounded),
                  _btn(Icons.content_paste_rounded),
                  _btn(Icons.audiotrack_rounded),

                  IconButton(
                    icon: const Icon(Icons.save_rounded),
                    splashRadius: 22,
                    onPressed: onSave,
                  ),

                  _btn(
                    Icons.diamond_rounded,
                    color: Colors.amber,
                  ),

                  IconButton(
                    icon: const Icon(Icons.more_vert_rounded),
                    splashRadius: 22,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        showDragHandle: true,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        builder: (_) => MoreOptionsSheet(
                        controller: controller,
                       ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _btn(
  IconData icon, {
  Color? color,
  VoidCallback? onPressed,
}) {
  return IconButton(
    splashRadius: 22,
    icon: Icon(
      icon,
      color: color ?? Colors.black87,
    ),
    onPressed: onPressed,
  );
}
}