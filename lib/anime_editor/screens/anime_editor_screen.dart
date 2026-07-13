import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/editor/top_bar.dart';
import '../controllers/anime_editor_controller.dart';
import '../../widgets/editor/left_bar.dart';
import '../../widgets/editor/right_panel.dart';
import '../../widgets/editor/brush_panel.dart';
import '../../widgets/editor/eraser_panel.dart';
import '../../widgets/editor/text_panel.dart';
import '../../widgets/editor/paint_panel.dart';
import '../../widgets/editor/rotate_device_overlay.dart';
import 'package:flutter_application_1/widgets/editor/bottom_bar.dart';
import 'package:flutter_application_1/widgets/editor/canvas_panel.dart';
import '../models/project_model.dart';

class AnimeEditorScreen extends StatefulWidget {
final ProjectModel project;

const AnimeEditorScreen({
  super.key,
  required this.project,
});

  @override
  State<AnimeEditorScreen> createState() =>
      _AnimeEditorScreenState();
}

class _AnimeEditorScreenState extends State<AnimeEditorScreen> {
  late AnimeEditorController controller;

  @override
void initState() {
  super.initState();

  controller = AnimeEditorController(
  project: widget.project,
);
}

  Widget getRightPanel() {
    switch(controller.selectedTool) {

      case EditorTool.brush:
        return BrushPanel(controller: controller,
);

      case EditorTool.eraser:
  return EraserPanel(
    controller: controller,
  );

      case EditorTool.text:
  return TextPanel(
    controller: controller,
  );

      default:
        return const SizedBox();
    }

  }




  @override
Widget build(BuildContext context) {
  final bool isPortrait =
      MediaQuery.of(context).orientation == Orientation.portrait;

  if (isPortrait) {
    return const Scaffold(
      body: RotateDeviceOverlay(),
    );
  }

  return AnimatedBuilder(
    animation: controller,
    builder: (context, child) {
      return Scaffold(
        bottomNavigationBar: controller.selectedTool == EditorTool.paint
            ? null
            : BottomBar(
                frameManager: controller.frameManager,
                onPrevious: controller.frameManager.previousFrame,
                onPlay: () {},
                onNext: controller.frameManager.nextFrame,
                onLayers: () {},
              ),

  body: SafeArea(
    child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Stack(
            children: [

              // NORMAL EDITOR
              Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TopBar(
                      projectName: controller.projectName,
                      onBack: () {
                      Navigator.pop(context);
                      },
                      onGoPro: () {
                        Navigator.pushNamed(
                          context,
                          '/premium',
                        );
                      },
                    ),
                  ),

                  Expanded(
                    child: Stack(
                      children: [

                        Row(
  children: [
    SizedBox(
      width: 90,
      child: Center(
        child: LeftBar(
          controller: controller,
        ),
      ),
    ),

    Expanded(
      child: CanvasPanel(
        canvasManager: controller.canvasManager,
      ),
    ),
  ],
),

                        if (controller.selectedTool != null &&
                            controller.selectedTool != EditorTool.paint)
                          Positioned(
                            right: 20,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: RightPanel(
                                child: getRightPanel(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              // FULL SCREEN PAINT
              if (controller.selectedTool ==
                  EditorTool.paint)
                Positioned.fill(
                  child: PaintPanel(
                    onClose: () {
                      controller.clearTool();
                    },
                  ),
                ),
            ],
          );
        },
      ),
    ),
  );
}
);
}
}