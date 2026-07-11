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

class AnimeEditorScreen extends StatefulWidget {
  final String projectName;
  final String ratio;
  final int fps;

  const AnimeEditorScreen({
    super.key,
    required this.projectName,
    required this.ratio,
    required this.fps,
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
    projectName: widget.projectName,
    ratio: widget.ratio,
    fps: widget.fps,
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
      MediaQuery.of(context).orientation ==
          Orientation.portrait;

  if (isPortrait) {
    return const Scaffold(
      body: RotateDeviceOverlay(),
    );
  }
  return Scaffold(
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
                      onSave: () {
                        Navigator.pop(
                          context,
                          controller.saveProject(),
                        );
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
                              child: Container(
                                margin: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius:
                                      BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(controller.ratio),
                                      Text(
                                        "${controller.fps} FPS",
                                      ),
                                    ],
                                  ),
                                ),
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
}