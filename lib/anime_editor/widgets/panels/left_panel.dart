import 'package:flutter/material.dart';

import '../../controllers/anime_editor_controller.dart';
import '../../models/tool_type.dart';

class LeftPanel extends StatelessWidget {
  final AnimeEditorController controller;
  final VoidCallback onChanged;

  const LeftPanel({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tools = <_ToolItem>[
      const _ToolItem(
        tool: ToolType.brush,
        icon: Icons.brush_rounded,
        tooltip: "Brush",
      ),
      const _ToolItem(
        tool: ToolType.eraser,
        icon: Icons.auto_fix_normal_rounded,
        tooltip: "Eraser",
      ),
      const _ToolItem(
        tool: ToolType.text,
        icon: Icons.title_rounded,
        tooltip: "Text",
      ),
      const _ToolItem(
        tool: ToolType.selection,
        icon: Icons.ads_click_rounded,
        tooltip: "Selection",
      ),
      const _ToolItem(
        tool: ToolType.fill,
        icon: Icons.format_color_fill_rounded,
        tooltip: "Fill",
      ),
    ];

    return SizedBox(
      width: 90,
      child: Center(
        child: Container(
          width: 64,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: tools.map((tool) {
              final selected = controller.selectedTool == tool.tool;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Tooltip(
                  message: tool.tooltip,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      if (controller.selectedTool == tool.tool) {
                        controller.selectTool(null);
                      } else {
                        controller.selectTool(tool.tool);
                      }

                      onChanged();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: selected
                            ? Colors.pink
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        tool.icon,
                        color: selected
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _ToolItem {
  final ToolType tool;
  final IconData icon;
  final String tooltip;

  const _ToolItem({
    required this.tool,
    required this.icon,
    required this.tooltip,
  });
}