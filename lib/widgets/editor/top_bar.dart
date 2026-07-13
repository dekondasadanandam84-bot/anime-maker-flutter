import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final String projectName;
  final VoidCallback onBack;
  final VoidCallback onGoPro;

  const TopBar({
    super.key,
    required this.projectName,
    required this.onBack,
    required this.onGoPro
  });

  @override
  Widget build(BuildContext context) {
    return Material(
  elevation: 6,
  borderRadius: BorderRadius.circular(12),
  child: Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  border: Border.all(
    color: const Color(0xFFE0E0E0),
  ),
),
      child: Stack(
  alignment: Alignment.center,
  children: [
    Row(
      children: [
        // Left - Project Name
        Expanded(
  child: Row(
    children: [
      IconButton(
        onPressed: onBack,
        icon: const Icon(Icons.arrow_back),
      ),
      Expanded(
        child: Text(
          projectName,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  ),
),

        // Empty space for center button
        const SizedBox(width: 48),

        // Right Actions
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
  onPressed: () {},
  icon: const Icon(
    Icons.undo,
    color: Colors.orange,
  ),
),
                IconButton(
  onPressed: () {},
  icon: const Icon(
    Icons.redo,
    color: Colors.green,
  ),
),
                IconButton(
  onPressed: () {},
  icon: const Icon(
    Icons.copy,
    color: Colors.purple,
  ),
),
                IconButton(
  onPressed: () {},
  icon: const Icon(
    Icons.paste,
    color: Colors.indigo,
  ),
),
                IconButton(
  onPressed: () {},
  icon: const Icon(
    Icons.audiotrack,
    color: Colors.pink,
  ),
),
                IconButton(
  onPressed: onGoPro,
  icon: const Icon(
    Icons.diamond,
    color: Colors.amber,
  ),
),
                IconButton(
  onPressed: () {},
  icon: const Icon(
    Icons.more_vert,
    color: Colors.black54,
  ),
),
              ],
            ),
          ),
        ),
      ],
    ),

    // Perfectly centered Fit Screen button
    IconButton(
  onPressed: () {},
  icon: const Icon(
    Icons.fit_screen,
    color: Colors.blue,
  ),
),
  ],
),
    ));
  }
}