import 'package:flutter/material.dart';
import 'package:flutter_application_1/editor/bottom_bar/bottom_bar_controller.dart';

class BottomBarUI extends StatelessWidget {
  const BottomBarUI({
    super.key,
    required this.controller,
    required this.onPreviousFrame,
    required this.onPlayPause,
    required this.onNextFrame,
    required this.onAddFrames,
    required this.onFrameSelected,
    required this.onCopy,
    required this.onPaste,
    required this.controlsHidden,
  });

  final BottomBarController controller;
  final VoidCallback onPreviousFrame;
  final VoidCallback onPlayPause;
  final VoidCallback onNextFrame;
  final ValueChanged<int> onAddFrames;
  final ValueChanged<int> onFrameSelected;
  final VoidCallback onCopy;
  final VoidCallback onPaste;
  final bool controlsHidden;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 90,
      child: Stack(
        children: [
          // =========================================================
          // COPY / PASTE
          // =========================================================
          Positioned(
            left: 12,
            bottom: 10,
            child: _CopyPasteGroup(onCopy: onCopy, onPaste: onPaste),
          ),

          // =========================================================
          // FRAME GROUP
          // =========================================================
          Positioned(
            left: controlsHidden ? 0 : 180,
            right: controlsHidden ? 0 : 150,
            bottom: 10,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: controlsHidden
                    ? MediaQuery.sizeOf(context).width * 0.45
                    : null,
                height: 64,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: controller.frames.length + 1,
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 6);
                  },
                  itemBuilder: (context, index) {
                    // ---------------------------------------------------------
                    // ADD FRAME BUTTON
                    // ---------------------------------------------------------
                    if (index == controller.frames.length) {
                      return _AddFrameCard(
                        onTap: () {
                          _showAddFramesSheet(context);
                        },
                      );
                    }

                    // ---------------------------------------------------------
                    // INDIVIDUAL FRAME
                    // ---------------------------------------------------------
                    final frame = controller.frames[index];

                    return _FrameCard(
                      frameNumber: frame,
                      selected: controller.selectedFrame == frame,
                      onTap: () {
                        onFrameSelected(frame);
                      },
                    );
                  },
                ),
              ),
            ),
          ),

          // =========================================================
          // PLAYBACK
          // =========================================================
          Positioned(
            left: controlsHidden ? null : 16,
            right: controlsHidden ? 72 : null,
            bottom: 10,
            child: _PlaybackGroup(
              isPlaying: controller.isPlaying,
              onPreviousFrame: onPreviousFrame,
              onPlayPause: onPlayPause,
              onNextFrame: onNextFrame,
            ),
          ),

          // =========================================================
          // LAYERS
          // =========================================================
          Positioned(right: 16, bottom: 10, child: _LayersButton(onTap: () {})),
        ],
      ),
    );
  }

  // ===================================================================
  // ADD FRAMES BOTTOM SHEET
  // ===================================================================

  void _showAddFramesSheet(BuildContext context) {
    showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const _AddFramesSheet();
      },
    ).then((count) {
      if (count == null) return;

      onAddFrames(count);
    });
  }
}
// =====================================================================
// COPY / PASTE GROUP
// =====================================================================

class _CopyPasteGroup extends StatelessWidget {
  const _CopyPasteGroup({required this.onCopy, required this.onPaste});

  final VoidCallback onCopy;
  final VoidCallback onPaste;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAEAEA)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CopyPasteButton(
            icon: Icons.content_copy_outlined,
            label: 'Copy',
            onTap: onCopy,
          ),
          _CopyPasteButton(
            icon: Icons.content_paste_outlined,
            label: 'Paste',
            onTap: onPaste,
          ),
        ],
      ),
    );
  }
}

class _CopyPasteButton extends StatelessWidget {
  const _CopyPasteButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: SizedBox(
          width: 48,
          height: 36,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: Colors.black87),
              const SizedBox(height: 1),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 8,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// =====================================================================
// ADD FRAMES SHEET
// =====================================================================

class _AddFramesSheet extends StatelessWidget {
  const _AddFramesSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 520),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ---------------------------------------------------------
              // HANDLE
              // ---------------------------------------------------------
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD8D8D8),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 14),

              // ---------------------------------------------------------
              // TITLE
              // ---------------------------------------------------------
              const Text(
                'Add Frames',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 16),

              // ---------------------------------------------------------
              // 1 - 30 GRID
              // ---------------------------------------------------------
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 30,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.25,
                ),
                itemBuilder: (context, index) {
                  final int count = index + 1;

                  return Material(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop(count);
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Center(
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// PLAYBACK GROUP
// =====================================================================

class _PlaybackGroup extends StatelessWidget {
  const _PlaybackGroup({
    required this.isPlaying,
    required this.onPreviousFrame,
    required this.onPlayPause,
    required this.onNextFrame,
  });

  final bool isPlaying;
  final VoidCallback onPreviousFrame;
  final VoidCallback onPlayPause;
  final VoidCallback onNextFrame;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAEAEA)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PlaybackButton(
            icon: Icons.skip_previous_rounded,
            onTap: onPreviousFrame,
          ),
          _PlaybackButton(
            icon: isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            onTap: onPlayPause,
          ),
          _PlaybackButton(icon: Icons.skip_next_rounded, onTap: onNextFrame),
        ],
      ),
    );
  }
}

// =====================================================================
// PLAYBACK BUTTON
// =====================================================================

class _PlaybackButton extends StatelessWidget {
  const _PlaybackButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 38,
          height: 46,
          child: Icon(icon, size: 20, color: Colors.black87),
        ),
      ),
    );
  }
}

// =====================================================================
// CLIP / FRAME CARD
// =====================================================================

class _FrameCard extends StatelessWidget {
  const _FrameCard({
    required this.frameNumber,
    required this.selected,
    required this.onTap,
  });

  final int frameNumber;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 72,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? Colors.blue : const Color(0xFFE0E0E0),
              width: selected ? 1.8 : 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Frame thumbnail area
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Container(color: const Color(0xFFF9F9F9)),
                  ),
                ),
              ),

              // Frame number
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 20),
                  height: 20,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '$frameNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// ADD FRAME CARD
// =====================================================================

class _AddFrameCard extends StatelessWidget {
  const _AddFrameCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: const Color(0xFFE0E0E0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(Icons.add_rounded, size: 32, color: Colors.blue),
        ),
      ),
    );
  }
}

// =====================================================================
// LAYERS BUTTON
// =====================================================================

class _LayersButton extends StatelessWidget {
  const _LayersButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEAEAEA)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x18000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.layers_outlined,
            size: 22,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
