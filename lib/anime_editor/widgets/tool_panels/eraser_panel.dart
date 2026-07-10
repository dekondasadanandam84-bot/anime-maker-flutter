import 'package:flutter/material.dart';

class EraserPanel extends StatefulWidget {
  const EraserPanel({super.key});

  @override
  State<EraserPanel> createState() => _EraserPanelState();
}

class _EraserPanelState extends State<EraserPanel> {
  int selectedIndex = 0;

  final List<_EraserItem> items = const [
    _EraserItem(
      icon: Icons.auto_fix_normal_rounded,
      tooltip: "Eraser Size",
    ),
    _EraserItem(
      icon: Icons.blur_on_rounded,
      tooltip: "Fade",
    ),
    _EraserItem(
      icon: Icons.opacity_rounded,
      tooltip: "Alpha",
    ),
    _EraserItem(
      icon: Icons.straighten_rounded,
      tooltip: "Ruler",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 20),
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          items.length,
          (index) {
            final item = items[index];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: _ToolButton(
                icon: item.icon,
                tooltip: item.tooltip,
                selected: selectedIndex == index,
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });

                  switch (index) {
                    case 0:
                      // Eraser Size
                      break;

                    case 1:
                      // Fade
                      break;

                    case 2:
                      // Alpha
                      break;

                    case 3:
                      // Ruler
                      break;
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EraserItem {
  final IconData icon;
  final String tooltip;

  const _EraserItem({
    required this.icon,
    required this.tooltip,
  });
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final String tooltip;
  final VoidCallback onTap;

  const _ToolButton({
    required this.icon,
    required this.selected,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: selected ? Colors.pink : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected
                    ? Colors.pink
                    : Colors.grey.shade300,
              ),
            ),
            child: Icon(
              icon,
              size: 28,
              color: selected
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}