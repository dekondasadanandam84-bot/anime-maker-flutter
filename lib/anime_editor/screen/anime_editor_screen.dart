import 'package:flutter/material.dart';
import 'package:flutter_application_1/anime_editor/widgets/panels/right_panel.dart';

import '../controllers/anime_editor_controller.dart';
import '../widgets/panels/top_bar.dart';
import '../widgets/panels/left_panel.dart';
import '../widgets/panels/canvas_panel.dart';
import '../widgets/panels/bottom_panel.dart';
import '../widgets/dialogs/add_frame_dialog.dart';
import '../widgets/dialogs/frame_actions_dialog.dart';

class AnimeEditorScreen extends StatefulWidget {
  final String ratio;
  final int fps;
  final String projectName;

  const AnimeEditorScreen({
    super.key,
    required this.ratio,
    required this.projectName,
    required this.fps,
  });

  @override
  State<AnimeEditorScreen> createState() => _AnimeEditorScreenState();
}

class _AnimeEditorScreenState extends State<AnimeEditorScreen> {
  late final AnimeEditorController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimeEditorController(
      projectName: widget.projectName,
      ratio: widget.ratio,
      fps: widget.fps,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _saveProject() {
    Navigator.pop(context, {
      "name": controller.projectName,
      "type": "anime",
      "ratio": controller.ratio,
      "fps": controller.fps,
      "thumbnail": Icons.movie,
    });
  }

  void _showAddFrame() {
    showAddFrameDialog(context, controller, onUpdate: () => setState(() {}));
  }

  void _showFrameActions() {
    showFrameActionsDialog(context, controller, onUpdate: () => setState(() {}));
  }

  @override
Widget build(BuildContext context) {
  return OrientationBuilder(
    builder: (context, orientation) {
      // Show rotate screen when phone is in portrait.
      if (orientation == Orientation.portrait) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.screen_rotation,
                      size: 120,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 32),
                    Text(
                      "Rotate your device",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Rotate your phone to landscape\nfor the best editing experience.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      // Landscape: show the editor.
      return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: SafeArea(
          child: Column(
            children: [
              TopBar(
                controller: controller,
                projectName: controller.projectName,
                onSave: _saveProject,
              ),

              Expanded(
  child: Stack(
    children: [
      Row(
        children: [
          LeftPanel(
            controller: controller,
            onChanged: () => setState(() {}),
          ),
          Expanded(
            child: CanvasPanel(
              controller: controller,
              ratio: widget.ratio,
            ),
          ),
        ],
      ),

      RightPanel(
        controller: controller,
      ),
    ],
  ),
),

              BottomPanel(
  controller: controller,
  onAddFrame: _showAddFrame,
  onFrameLongPress: _showFrameActions,
  onUpdate: () => setState(() {}),
),
            ],
          ),
        ),
      );
    },
  );
}
}