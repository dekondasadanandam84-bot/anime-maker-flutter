import 'package:flutter/material.dart';
import 'package:flutter_application_1/editor/left_panel/left_panel_controller.dart';

class LeftPanelUI extends StatelessWidget {
const LeftPanelUI({
  super.key,
  required this.controller,
  this.compact = false,
});

final LeftPanelController controller;
final bool compact;

  static const List<_LeftTool> _tools = [
    _LeftTool(
      id: LeftPanelController.brush,
      icon: Icons.brush_outlined,
      label: 'Brush',
    ),
    _LeftTool(
      id: LeftPanelController.eraser,
      icon: Icons.auto_fix_high_outlined,
      label: 'Eraser',
    ),
    _LeftTool(
      id: LeftPanelController.font,
      icon: Icons.font_download_outlined,
      label: 'Font',
    ),
    _LeftTool(
      id: LeftPanelController.paint,
      icon: Icons.format_color_fill_outlined,
      label: 'Paint',
    ),
    _LeftTool(
      id: LeftPanelController.select,
      icon: Icons.ads_click_outlined,
      label: 'Select',
    ),
    _LeftTool(
      id: LeftPanelController.more,
      icon: Icons.more_horiz_rounded,
      label: 'More',
    ),
  ];

  static const List<_LeftTool> _moreTools = [
    _LeftTool(
      id: LeftPanelController.smudge,
      icon: Icons.blur_on_outlined,
      label: 'Smudge',
    ),
    _LeftTool(
      id: LeftPanelController.blur,
      icon: Icons.blur_circular_outlined,
      label: 'Blur',
    ),
  ];

  static const double _visibleToolAreaHeight = 206;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        if (compact) {
  final tool = _findTool(controller.selectedTool);

  if (tool == null) {
    return const SizedBox.shrink();
  }

  return Container(
    width: 72,
    padding: const EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 10,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: const Color(0xFFEAEAEA),
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x18000000),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: _ToolButton(
      icon: tool.icon,
      label: tool.label,
      selected: true,
      onTap: () {
        controller.selectTool(tool.id);
      },
    ),
  );
}
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // =========================================================
            // MAIN FLOATING TOOLBAR
            // =========================================================
            Container(
              width: 72,
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFEAEAEA),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x18000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SizedBox(
                height: _visibleToolAreaHeight,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      _tools.length,
                      (index) {
                        final tool = _tools[index];

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom:
                                index == _tools.length - 1 ? 0 : 8,
                          ),
                          child: _ToolButton(
                            icon: tool.icon,
                            label: tool.label,
                            selected:
                                controller.selectedTool == tool.id,
                            onTap: () {
                              if (tool.id ==
                                  LeftPanelController.more) {
                                controller.toggleMoreTools();
                              } else {
                                controller.selectTool(tool.id);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // =========================================================
            // SECONDARY FLOATING TOOLBAR
            // =========================================================
            if (controller.moreToolsOpen) ...[
              const SizedBox(width: 10),

              Container(
                width: 72,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFEAEAEA),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x18000000),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: _visibleToolAreaHeight,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        _moreTools.length,
                        (index) {
                          final tool = _moreTools[index];

                          return Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  index == _moreTools.length - 1
                                      ? 0
                                      : 8,
                            ),
                            child: _ToolButton(
                              icon: tool.icon,
                              label: tool.label,
                              selected:
                                  controller.selectedTool ==
                                      tool.id,
                              onTap: () {
                                controller.selectTool(tool.id);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
  
  _LeftTool? _findTool(int id) {
  for (final tool in _tools) {
    if (tool.id == id) {
      return tool;
    }
  }

  for (final tool in _moreTools) {
    if (tool.id == id) {
      return tool;
    }
  }

  return null;
}
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Colors.blue : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: double.infinity,
          height: 58,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: selected
                    ? Colors.white
                    : Colors.black87,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? Colors.white
                      : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeftTool {
  const _LeftTool({
    required this.id,
    required this.icon,
    required this.label,
  });

  final int id;
  final IconData icon;
  final String label;
}