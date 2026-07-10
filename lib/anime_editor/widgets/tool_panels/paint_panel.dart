import 'package:flutter/material.dart';

class PaintPanel extends StatelessWidget {
  final VoidCallback onOpenColourPicker;

  const PaintPanel({
    super.key,
    required this.onOpenColourPicker,
  });

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
        children: [
          Tooltip(
            message: "Colour Picker",
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: onOpenColourPicker,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.pink,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.palette_rounded,
                    color: Colors.pink,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}