import 'package:flutter/material.dart';
import 'package:flutter_application_1/editor/bottom_bar/bottom_bar_controller.dart';

class BottomBarUI extends StatelessWidget {
  const BottomBarUI({
  super.key,
  required this.controller,
  required this.onPreviousFrame,
  required this.onPlayPause,
  required this.onNextFrame,
  required this.onAddFrame,
  required this.onFrameSelected,
});

final BottomBarController controller;
final VoidCallback onPreviousFrame;
final VoidCallback onPlayPause;
final VoidCallback onNextFrame;
final VoidCallback onAddFrame;
final ValueChanged<int> onFrameSelected;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: false,
      child: SizedBox(
        width: double.infinity,
        height: 100,
        child: Stack(
          children: [
            // =========================================================
            // PLAYBACK FLOATING GROUP
            // =========================================================
            Positioned(
              left: 16,
              bottom: 14,
              child: _FloatingGroup(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _BottomIconButton(
                      icon: Icons.skip_previous_rounded,
                      onTap: () {},
                    ),
                    _BottomIconButton(
                      icon: Icons.play_arrow_rounded,
                      onTap: () {},
                    ),
                    _BottomIconButton(
                      icon: Icons.skip_next_rounded,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            // =========================================================
            // FRAMES FLOATING GROUP
            // =========================================================
            Positioned(
              left: 190,
              right: 110,
              bottom: 14,
              child: _FloatingGroup(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    // -------------------------------------------------
                    // FRAME 01
                    // -------------------------------------------------
                    _FrameBox(
                      selected: true,
                      child: const Center(
                        child: Text(
                          '01',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // -------------------------------------------------
                    // FRAME LENGTH RECTANGLE
                    // -------------------------------------------------
                    Expanded(
                      child: _FrameLengthBox(),
                    ),

                    const SizedBox(width: 8),

                    // -------------------------------------------------
                    // ADD FRAME
                    // -------------------------------------------------
                    _AddFrameButton(
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            // =========================================================
            // LAYERS FLOATING BUTTON
            // =========================================================
            Positioned(
              right: 16,
              bottom: 14,
              child: _FloatingGroup(
                child: _BottomIconButton(
                  icon: Icons.layers_outlined,
                  onTap: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// FLOATING GROUP
// =====================================================================

class _FloatingGroup extends StatelessWidget {
  const _FloatingGroup({
    required this.child,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 6,
      vertical: 6,
    ),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFEAEAEA),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// =====================================================================
// BOTTOM ICON BUTTON
// =====================================================================

class _BottomIconButton extends StatelessWidget {
  const _BottomIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            icon,
            size: 22,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// FRAME BOX
// =====================================================================

class _FrameBox extends StatelessWidget {
  const _FrameBox({
    required this.child,
    required this.selected,
  });

  final Widget child;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 42,
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFFEAF2FF)
            : const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected
              ? Colors.blue
              : const Color(0xFFE2E2E2),
          width: selected ? 1.5 : 1,
        ),
      ),
      child: child,
    );
  }
}

// =====================================================================
// FRAME LENGTH RECTANGLE
// =====================================================================

class _FrameLengthBox extends StatelessWidget {
  const _FrameLengthBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE2E2E2),
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 120,
          margin: const EdgeInsets.symmetric(
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(7),
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// ADD FRAME BUTTON
// =====================================================================

class _AddFrameButton extends StatelessWidget {
  const _AddFrameButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: const SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            Icons.add_rounded,
            size: 22,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}