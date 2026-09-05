import 'package:flutter/material.dart';

import 'package:flutter_application_1/editor/editor_responsive.dart';
import 'package:flutter_application_1/editor/left_panel/left_panel_controller.dart';

class LeftPanelUI extends StatelessWidget {
  const LeftPanelUI({
    super.key,
    required this.controller,
    required this.metrics,
    this.compact = false,
  });

  final LeftPanelController controller;
  final EditorResponsiveData metrics;
  final bool compact;

  // ============================================================
  // MAIN TOOLS
  // ============================================================

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

  // ============================================================
  // MORE TOOLS
  // ============================================================

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

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // ==========================================================
        // COMPACT / HIDDEN CONTROLS MODE
        // ==========================================================

        if (compact) {
          final tool = _findTool(controller.selectedTool);

          if (tool == null) {
            return const SizedBox.shrink();
          }

          return _ToolbarContainer(
            metrics: metrics,
            child: _ToolButton(
              icon: tool.icon,
              label: tool.label,
              selected: true,
              metrics: metrics,
              onTap: () {
                controller.selectTool(tool.id);
              },
            ),
          );
        }

        // ==========================================================
        // NORMAL MODE
        // ==========================================================

        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ======================================================
            // MAIN TOOLBAR
            // ======================================================
            _ToolbarContainer(
              metrics: metrics,
              child: SizedBox(
                height: _toolAreaHeight,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_tools.length, (index) {
                      final tool = _tools[index];

                      final isLast = index == _tools.length - 1;

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: isLast ? 0 : _toolSpacing,
                        ),
                        child: _ToolButton(
                          icon: tool.icon,
                          label: tool.label,
                          selected: controller.selectedTool == tool.id,
                          metrics: metrics,
                          onTap: () {
                            if (tool.id == LeftPanelController.more) {
                              controller.toggleMoreTools();
                            } else {
                              controller.selectTool(tool.id);
                            }
                          },
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),

            // ======================================================
            // SECONDARY TOOLBAR
            // ======================================================
            if (controller.moreToolsOpen) ...[
              SizedBox(width: metrics.panelGap),

              _ToolbarContainer(
                metrics: metrics,
                child: SizedBox(
                  height: _toolAreaHeight,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(_moreTools.length, (index) {
                        final tool = _moreTools[index];

                        final isLast = index == _moreTools.length - 1;

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: isLast ? 0 : _toolSpacing,
                          ),
                          child: _ToolButton(
                            icon: tool.icon,
                            label: tool.label,
                            selected: controller.selectedTool == tool.id,
                            metrics: metrics,
                            onTap: () {
                              controller.selectTool(tool.id);
                            },
                          ),
                        );
                      }),
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

  // ============================================================
  // RESPONSIVE TOOL AREA
  // ============================================================

  double get _toolAreaHeight {
    if (metrics.isSmall) {
      return 156;
    }

    if (metrics.isCompact) {
      return 178;
    }

    return 206;
  }

  double get _toolSpacing {
    if (metrics.isSmall) {
      return 4;
    }

    if (metrics.isCompact) {
      return 6;
    }

    return 8;
  }

  // ============================================================
  // FIND TOOL
  // ============================================================

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

// ==================================================================
// TOOLBAR CONTAINER
// ==================================================================

class _ToolbarContainer extends StatelessWidget {
  const _ToolbarContainer({required this.metrics, required this.child});

  final EditorResponsiveData metrics;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: metrics.leftPanelWidth,
      padding: EdgeInsets.symmetric(
        horizontal: metrics.panelPadding,
        vertical: metrics.panelPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(metrics.isSmall ? 13 : 16),
        border: Border.all(color: const Color(0xFFEAEAEA)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ==================================================================
// TOOL BUTTON
// ==================================================================

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.metrics,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final EditorResponsiveData metrics;

  @override
  Widget build(BuildContext context) {
    final showLabel = !metrics.isSmall;

    return Material(
      color: selected ? Colors.blue : Colors.transparent,
      borderRadius: BorderRadius.circular(metrics.isSmall ? 10 : 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(metrics.isSmall ? 10 : 12),
        child: SizedBox(
          width: double.infinity,
          height: metrics.toolButtonHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: metrics.toolIconSize,
                color: selected ? Colors.white : Colors.black87,
              ),

              if (showLabel) ...[
                SizedBox(height: metrics.isCompact ? 2 : 3),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: metrics.toolLabelSize,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : Colors.black54,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ==================================================================
// TOOL MODEL
// ==================================================================

class _LeftTool {
  const _LeftTool({required this.id, required this.icon, required this.label});

  final int id;
  final IconData icon;
  final String label;
}
