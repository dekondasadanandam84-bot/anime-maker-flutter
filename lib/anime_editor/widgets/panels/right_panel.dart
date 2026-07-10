import 'package:flutter/material.dart';

import '../../controllers/anime_editor_controller.dart';
import '../../models/tool_type.dart';
import '../tool_panels/brush_panel.dart';
import '../tool_panels/eraser_panel.dart';
import '../tool_panels/text_panel.dart';
import '../tool_panels/paint_panel.dart';
import '../../screen/colour_picker_screen.dart';

class RightPanel extends StatelessWidget {
  final AnimeEditorController controller;

  const RightPanel({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    Widget? panel;

    switch (controller.selectedTool) {
  case ToolType.brush:
    panel = const BrushPanel();
    break;

  case ToolType.eraser:
    panel = const EraserPanel();
    break;

  case ToolType.text:
    panel = const TextPanel();
    break;

  case ToolType.fill:
  panel = PaintPanel(
    onOpenColourPicker: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ColourPickerScreen(),
        ),
      );
    },
  );
  break;

  case ToolType.selection:
  case null:
    panel = null;
    break;
}

    final visible = panel != null;

    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          offset: visible ? Offset.zero : const Offset(1, 0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: panel ?? const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}