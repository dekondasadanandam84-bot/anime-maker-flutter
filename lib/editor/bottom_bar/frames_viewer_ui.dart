
import 'package:flutter/material.dart';

import 'bottom_bar_controller.dart';
import 'frames_viewer_controller.dart';

class FramesViewerUI extends StatelessWidget {
  const FramesViewerUI({
    super.key,
    required this.bottomBarController,
    required this.controller,
    required this.onAddFrames,
  });

  final BottomBarController bottomBarController;
  final FramesViewerController controller;
  final VoidCallback onAddFrames;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ============================================================
      // APP BAR
      // ============================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Frames Viewer',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // ============================================================
      // BODY
      // ============================================================

      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            bottomBarController,
            controller,
          ]),
          builder: (context, _) {
            return Column(
              children: [
                // ==================================================
                // SELECTION HEADER
                // ==================================================

                if (controller.selectionMode)
                  _SelectionHeader(
                    selectedCount:
                        controller.selectedFrames.length,
                    onCancel:
                        controller.cancelSelection,
                    onSelectAll:
                        controller.selectAll,
                  ),

                // ==================================================
                // RESPONSIVE FRAMES GRID
                // ==================================================

                Expanded(
                  child: _FramesArea(
                    bottomBarController:
                        bottomBarController,
                    controller: controller,
                    onAddFrames: onAddFrames,
                  ),
                ),

                // ==================================================
                // FRAME ACTIONS
                // ==================================================

                _FrameActionsBar(
                  controller: controller,
                  bottomBarController:
                      bottomBarController,
                ),

                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }
}

// =====================================================================
// SELECTION HEADER
// =====================================================================

class _SelectionHeader extends StatelessWidget {
  const _SelectionHeader({
    required this.selectedCount,
    required this.onCancel,
    required this.onSelectAll,
  });

  final int selectedCount;
  final VoidCallback onCancel;
  final VoidCallback onSelectAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFEAEAEA),
          ),
        ),
      ),
      child: Row(
        children: [
          TextButton(
            onPressed: onCancel,
            child: const Text(
              'Cancel',
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '$selectedCount selected',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: onSelectAll,
            child: const Text(
              'Select All',
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// RESPONSIVE FRAMES AREA
// =====================================================================
//
// Wide horizontal frame cards.
//
// Example:
//
// [    1    ] [    2    ] [    3    ] [    +    ]
//
// The number of columns adapts to the available screen width.
// =====================================================================

class _FramesArea extends StatelessWidget {
  const _FramesArea({
    required this.bottomBarController,
    required this.controller,
    required this.onAddFrames,
  });

  final BottomBarController bottomBarController;
  final FramesViewerController controller;
  final VoidCallback onAddFrames;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // =============================================================
        // CARD DIMENSIONS
        // =============================================================

        const double minCardWidth = 120;
        const double cardHeight = 80;
        const double spacing = 12;

        final availableWidth =
            constraints.maxWidth;

        // =============================================================
        // RESPONSIVE COLUMN COUNT
        // =============================================================

        int columns =
            ((availableWidth + spacing) /
                    (minCardWidth + spacing))
                .floor();

        if (columns < 1) {
          columns = 1;
        }

        // =============================================================
        // GRID
        // =============================================================

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            30,
          ),
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,

            // Wide horizontal rectangle.
            childAspectRatio:
                minCardWidth / cardHeight,
          ),
          itemCount:
              bottomBarController.frames.length + 1,
          itemBuilder: (context, index) {
            // =========================================================
            // PLUS CARD
            // =========================================================

            if (index ==
                bottomBarController.frames.length) {
              return _AddFrameCard(
                onTap: onAddFrames,
              );
            }

            // =========================================================
            // FRAME
            // =========================================================

            final frame =
                bottomBarController.frames[index];

            final selected =
                controller.selectionMode
                    ? controller.isFrameSelected(frame)
                    : bottomBarController
                            .selectedFrame ==
                        frame;

            return _FrameCard(
              frameNumber: frame,
              selected: selected,
              selectionMode:
                  controller.selectionMode,
              onTap: () {
                controller.onFrameTap(frame);
              },
              onLongPress: () {
                controller.onFrameLongPress(frame);
              },
            );
          },
        );
      },
    );
  }
}

// =====================================================================
// FRAME ACTIONS
// =====================================================================

class _FrameActionsBar extends StatelessWidget {
  const _FrameActionsBar({
    required this.controller,
    required this.bottomBarController,
  });

  final FramesViewerController controller;
  final BottomBarController bottomBarController;

  @override
  Widget build(BuildContext context) {
    final hasSelection =
        !controller.selectionMode ||
        controller.hasSelection;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            _ActionButton(
              icon:
                  Icons.vertical_align_top_rounded,
              label: 'Add Before',
              onTap: controller.addBefore,
            ),
            _ActionButton(
              icon:
                  Icons.vertical_align_bottom_rounded,
              label: 'Add After',
              onTap: controller.addAfter,
            ),
            _ActionButton(
              icon:
                  Icons.content_copy_outlined,
              label: 'Copy',
              onTap:
                  hasSelection
                      ? controller.copy
                      : null,
            ),
            _ActionButton(
              icon:
                  Icons.content_paste_outlined,
              label: 'Paste',
              onTap:
                  bottomBarController.canPaste
                      ? controller.paste
                      : null,
            ),
            _ActionButton(
              icon:
                  Icons.copy_all_outlined,
              label: 'Duplicate',
              onTap:
                  hasSelection
                      ? controller.duplicate
                      : null,
            ),
            _ActionButton(
              icon:
                  Icons.backspace_outlined,
              label: 'Erase',
              onTap:
                  hasSelection &&
                          bottomBarController
                                  .frameCount >
                              1
                      ? controller.erase
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// ACTION BUTTON
// =====================================================================

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 2,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius:
            BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(10),
          child: SizedBox(
            width: 82,
            height: 56,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 19,
                  color: onTap == null
                      ? Colors.black26
                      : Colors.black87,
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight:
                        FontWeight.w600,
                    color: onTap == null
                        ? Colors.black26
                        : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// HORIZONTAL FRAME CARD
// =====================================================================

class _FrameCard extends StatelessWidget {
  const _FrameCard({
    required this.frameNumber,
    required this.selected,
    required this.selectionMode,
    required this.onTap,
    required this.onLongPress,
  });

  final int frameNumber;
  final bool selected;
  final bool selectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Material(
        color: Colors.transparent,
        borderRadius:
            BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(8),
          child: Container(
            // ========================================================
            // WIDE + SHORT RECTANGLE
            // ========================================================

            width: 120,
            height: 80,

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(8),
              border: Border.all(
                color: selected
                    ? Colors.blue
                    : const Color(0xFFD9D9D9),
                width:
                    selected ? 2 : 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color:
                      Color(0x14000000),
                  blurRadius: 5,
                  offset:
                      Offset(0, 2),
                ),
              ],
            ),

            child: Stack(
              children: [
                // ==================================================
                // THUMBNAIL
                // ==================================================

                Positioned.fill(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(3),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(5),
                      child: Container(
                        color:
                            const Color(0xFFF7F7F7),
                      ),
                    ),
                  ),
                ),

                // ==================================================
                // FRAME NUMBER
                // ==================================================

                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    constraints:
                        const BoxConstraints(
                      minWidth: 22,
                    ),
                    height: 21,
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    alignment:
                        Alignment.center,
                    decoration:
                        BoxDecoration(
                      color: selected
                          ? Colors.blue
                          : Colors.black54,
                      borderRadius:
                          BorderRadius.circular(
                        5,
                      ),
                    ),
                    child: Text(
                      '$frameNumber',
                      style:
                          const TextStyle(
                        color:
                            Colors.white,
                        fontSize: 10,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                // ==================================================
                // SELECTION CHECK
                // ==================================================

                if (selectionMode &&
                    selected)
                  const Positioned(
                    left: 5,
                    top: 5,
                    child: Icon(
                      Icons.check_circle,
                      size: 19,
                      color: Colors.blue,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// HORIZONTAL ADD FRAME CARD
// =====================================================================

class _AddFrameCard extends StatelessWidget {
  const _AddFrameCard({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius:
          BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(8),
        child: Container(
          width: 120,
          height: 80,
          decoration:
              BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(8),
            border: Border.all(
              color:
                  const Color(0xFFD9D9D9),
            ),
            boxShadow: const [
              BoxShadow(
                color:
                    Color(0x14000000),
                blurRadius: 5,
                offset:
                    Offset(0, 2),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.add_rounded,
              size: 34,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}

