import 'package:flutter/material.dart';

class TextPanel extends StatefulWidget {
  const TextPanel({super.key});

  @override
  State<TextPanel> createState() => _TextPanelState();
}

class _TextPanelState extends State<TextPanel> {
  int selectedIndex = 0;

  final List<_TextItem> items = const [
    _TextItem(
      icon: Icons.post_add_rounded,
      tooltip: "Insert Text",
    ),
    _TextItem(
      icon: Icons.font_download_rounded,
      tooltip: "Font",
    ),
    _TextItem(
      icon: Icons.format_size_rounded,
      tooltip: "Text Size",
    ),
    _TextItem(
      icon: Icons.palette_rounded,
      tooltip: "Colour",
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
        children: List.generate(items.length, (index) {
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
                    // Insert Text
                    break;

                  case 1:
                    // Font
                    break;

                  case 2:
                    // Size
                    break;

                  case 3:
                    // Colour
                    break;
                }
              },
            ),
          );
        }),
      ),
    );
  }
}

class _TextItem {
  final IconData icon;
  final String tooltip;

  const _TextItem({
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