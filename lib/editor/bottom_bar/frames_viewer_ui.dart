import 'package:flutter/material.dart';

import 'bottom_bar_controller.dart';
import 'frames_viewer_controller.dart';

class FramesViewerUI extends StatefulWidget {
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
  State<FramesViewerUI> createState() =>
      _FramesViewerUIState();
}

class _FramesViewerUIState
    extends State<FramesViewerUI> {
  // ============================================================
  // FRAME ACTIONS
  // ============================================================

  bool _showFrameActions = false;

  // ============================================================
  // SHORTCUTS
  // ============================================================

  BottomBarController get bottomBarController =>
      widget.bottomBarController;

  FramesViewerController get controller =>
      widget.controller;

  // ============================================================
  // BUILD
  // ============================================================

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
            _closeFrameActions();

            if (controller.selectionMode) {
              controller.cancelSelection();
            }

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
                    onCancel: () {
                      controller.cancelSelection();
                      _closeFrameActions();
                    },
                    onSelectAll:
                        controller.selectAll,
                  ),

                // ==================================================
                // FRAME AREA
                // ==================================================

                Expanded(
                  child: _FramesArea(
                    bottomBarController:
                        bottomBarController,
                    controller:
                        controller,
                    onAddFrames:
                        widget.onAddFrames,
                    onFrameTap:
                        _handleFrameTap,
                    onFrameLongPress:
                        _handleFrameLongPress,
                  ),
                ),

                // ==================================================
                // NORMAL SELECTED FRAME ACTIONS
                // ==================================================

                if (_showFrameActions &&
                    !controller.selectionMode)
                  _FrameActionsBar(
                    controller:
                        controller,
                    bottomBarController:
                        bottomBarController,
                    onClose:
                        _closeFrameActions,
                  ),

                // ==================================================
                // MULTI-SELECTION DELETE BAR
                // ==================================================

                if (controller.selectionMode)
                  _SelectionActionsBar(
                    controller:
                        controller,
                    bottomBarController:
                        bottomBarController,
                    onClose:
                        _closeSelection,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // FRAME TAP
  // ============================================================

  void _handleFrameTap(
    int frame,
  ) {
    final showActions =
        controller.onFrameTap(frame);

    // ----------------------------------------------------------
    // Selection mode is handled by controller.
    // ----------------------------------------------------------

    if (controller.selectionMode) {
      _closeFrameActions();
      return;
    }

    // ----------------------------------------------------------
    // First tap.
    // ----------------------------------------------------------

    if (!showActions) {
      _closeFrameActions();
      return;
    }

    // ----------------------------------------------------------
    // Second tap on selected frame.
    // ----------------------------------------------------------

    setState(() {
      _showFrameActions = true;
    });
  }

  // ============================================================
  // LONG PRESS
  // ============================================================

  void _handleFrameLongPress(
    int frame,
  ) {
    _closeFrameActions();

    controller.onFrameLongPress(frame);
  }

  // ============================================================
  // CLOSE FRAME ACTIONS
  // ============================================================

  void _closeFrameActions() {
    if (!_showFrameActions) {
      return;
    }

    setState(() {
      _showFrameActions = false;
    });
  }

  // ============================================================
  // CLOSE SELECTION
  // ============================================================

  void _closeSelection() {
    controller.cancelSelection();
    _closeFrameActions();
  }
}

// =====================================================================
// SELECTION HEADER
// =====================================================================

class _SelectionHeader
    extends StatelessWidget {
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
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration:
          const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:
                Color(0xFFEAEAEA),
          ),
        ),
      ),
      child: Row(
        children: [
          TextButton(
            onPressed:
                onCancel,
            child:
                const Text(
              'Cancel',
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                '$selectedCount selected',
                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),
          ),

          TextButton(
            onPressed:
                onSelectAll,
            child:
                const Text(
              'Select All',
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// FRAMES AREA
// =====================================================================

class _FramesArea
    extends StatelessWidget {
  const _FramesArea({
    required this.bottomBarController,
    required this.controller,
    required this.onAddFrames,
    required this.onFrameTap,
    required this.onFrameLongPress,
  });

  final BottomBarController bottomBarController;
  final FramesViewerController controller;

  final VoidCallback onAddFrames;

  final ValueChanged<int> onFrameTap;
  final ValueChanged<int> onFrameLongPress;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        const double minCardWidth = 120;
        const double cardHeight = 80;
        const double spacing = 12;

        final availableWidth =
            constraints.maxWidth;

        int columns =
            ((availableWidth + spacing) /
                    (minCardWidth + spacing))
                .floor();

        if (columns < 1) {
          columns = 1;
        }

        return GridView.builder(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            30,
          ),
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                columns,
            crossAxisSpacing:
                spacing,
            mainAxisSpacing:
                spacing,
            childAspectRatio:
                minCardWidth /
                    cardHeight,
          ),
          itemCount:
              bottomBarController
                      .frames
                      .length +
                  1,
          itemBuilder:
              (context, index) {
            // =========================================================
            // PLUS CARD
            // =========================================================

            if (index ==
                bottomBarController
                    .frames
                    .length) {
              return _AddFrameCard(
                onTap:
                    onAddFrames,
              );
            }

            // =========================================================
            // FRAME
            // =========================================================

            final frame =
                bottomBarController
                    .frames[index];

            final selected =
                controller.selectionMode
                    ? controller
                        .isFrameSelected(
                        frame,
                      )
                    : bottomBarController
                            .selectedFrame ==
                        frame;

            return _FrameCard(
              frameNumber:
                  frame,
              selected:
                  selected,
              selectionMode:
                  controller.selectionMode,
              onTap: () {
                onFrameTap(frame);
              },
              onLongPress: () {
                onFrameLongPress(
                  frame,
                );
              },
            );
          },
        );
      },
    );
  }
}

// =====================================================================
// NORMAL FRAME ACTIONS BAR
// =====================================================================
//
// Appears when the already-selected frame is tapped again.
//
// =====================================================================

class _FrameActionsBar
    extends StatelessWidget {
  const _FrameActionsBar({
    required this.controller,
    required this.bottomBarController,
    required this.onClose,
  });

  final FramesViewerController controller;
  final BottomBarController bottomBarController;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.fromLTRB(
        8,
        8,
        8,
        8,
      ),
      decoration:
          const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color:
                Color(0xFFE0E0E0),
          ),
        ),
        boxShadow:
            [
          BoxShadow(
            color:
                Color(0x18000000),
            blurRadius: 12,
            offset:
                Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child:
            SingleChildScrollView(
          scrollDirection:
              Axis.horizontal,
          child:
              Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              _ActionButton(
                icon:
                    Icons.vertical_align_top_rounded,
                label:
                    'Add Before',
                onTap: () {
                  controller
                      .addBefore();
                  onClose();
                },
              ),

              _ActionButton(
                icon:
                    Icons.vertical_align_bottom_rounded,
                label:
                    'Add After',
                onTap: () {
                  controller
                      .addAfter();
                  onClose();
                },
              ),

              _ActionButton(
                icon:
                    Icons.content_copy_outlined,
                label:
                    'Copy',
                onTap: () {
                  controller.copy();
                  onClose();
                },
              ),

              _ActionButton(
                icon:
                    Icons.content_paste_outlined,
                label:
                    'Paste',
                onTap:
                    bottomBarController
                            .canPaste
                        ? () {
                            controller
                                .paste();
                            onClose();
                          }
                        : null,
              ),

              _ActionButton(
                icon:
                    Icons.copy_all_outlined,
                label:
                    'Duplicate',
                onTap: () {
                  controller
                      .duplicate();
                  onClose();
                },
              ),

              _ActionButton(
                icon:
                    Icons.backspace_outlined,
                label:
                    'Erase',
                onTap:
                    bottomBarController
                                .frameCount >
                            1
                        ? () {
                            controller
                                .erase();
                            onClose();
                          }
                        : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// MULTI-SELECTION ACTIONS BAR
// =====================================================================
//
// Appears after long-press selection.
//
// Contains DELETE only.
// "Select All" remains in the header.
//
// =====================================================================

class _SelectionActionsBar
    extends StatelessWidget {
  const _SelectionActionsBar({
    required this.controller,
    required this.bottomBarController,
    required this.onClose,
  });

  final FramesViewerController controller;
  final BottomBarController bottomBarController;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final hasSelection =
        controller.hasSelection;

    final canDelete =
        hasSelection &&
        bottomBarController.frameCount > 1;

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.fromLTRB(
        8,
        8,
        8,
        8,
      ),
      decoration:
          const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color:
                Color(0xFFE0E0E0),
          ),
        ),
        boxShadow:
            [
          BoxShadow(
            color:
                Color(0x18000000),
            blurRadius: 12,
            offset:
                Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Center(
          child: _DeleteActionButton(
            enabled:
                canDelete,
            selectedCount:
                controller
                    .selectedFrames
                    .length,
            onTap:
                canDelete
                    ? () {
                        controller.erase();
                        onClose();
                      }
                    : null,
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// DELETE ACTION BUTTON
// =====================================================================

class _DeleteActionButton
    extends StatelessWidget {
  const _DeleteActionButton({
    required this.enabled,
    required this.selectedCount,
    required this.onTap,
  });

  final bool enabled;
  final int selectedCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color:
          Colors.transparent,
      borderRadius:
          BorderRadius.circular(
        12,
      ),
      child: InkWell(
        onTap:
            onTap,
        borderRadius:
            BorderRadius.circular(
          12,
        ),
        child: Container(
          width: 130,
          height: 58,
          padding:
              const EdgeInsets
                  .symmetric(
            horizontal: 16,
          ),
          decoration:
              BoxDecoration(
            color: enabled
                ? const Color(
                    0xFFFFF3F3,
                  )
                : const Color(
                    0xFFF5F5F5,
                  ),
            borderRadius:
                BorderRadius.circular(
              12,
            ),
            border:
                Border.all(
              color: enabled
                  ? const Color(
                      0xFFFFCDD2,
                    )
                  : const Color(
                      0xFFE0E0E0,
                    ),
            ),
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(
                Icons.delete_outline,
                size: 20,
                color: enabled
                    ? Colors.red
                    : Colors.black26,
              ),

              const SizedBox(
                width: 7,
              ),

              Text(
                selectedCount > 0
                    ? 'Delete'
                    : 'Delete',
                style:
                    TextStyle(
                  fontSize: 10,
                  fontWeight:
                      FontWeight.w700,
                  color: enabled
                      ? Colors.red
                      : Colors.black26,
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
// ACTION BUTTON
// =====================================================================

class _ActionButton
    extends StatelessWidget {
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
    final enabled =
        onTap != null;

    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 2,
      ),
      child: Material(
        color:
            Colors.transparent,
        borderRadius:
            BorderRadius.circular(
          10,
        ),
        child:
            InkWell(
          onTap:
              onTap,
          borderRadius:
              BorderRadius.circular(
            10,
          ),
          child:
              SizedBox(
            width: 82,
            height: 58,
            child:
                Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 19,
                  color: enabled
                      ? Colors.black87
                      : Colors.black26,
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  label,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  textAlign:
                      TextAlign.center,
                  style:
                      TextStyle(
                    fontSize: 9,
                    fontWeight:
                        FontWeight.w600,
                    color: enabled
                        ? Colors.black54
                        : Colors.black26,
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
// FRAME CARD
// =====================================================================

class _FrameCard
    extends StatelessWidget {
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
      onLongPress:
          onLongPress,
      child:
          Material(
        color:
            Colors.transparent,
        borderRadius:
            BorderRadius.circular(
          8,
        ),
        child:
            InkWell(
          onTap:
              onTap,
          borderRadius:
              BorderRadius.circular(
            8,
          ),
          child:
              Container(
            width: 120,
            height: 80,
            decoration:
                BoxDecoration(
              color:
                  Colors.white,
              borderRadius:
                  BorderRadius.circular(
                8,
              ),
              border:
                  Border.all(
                color: selected
                    ? Colors.blue
                    : const Color(
                        0xFFD9D9D9,
                      ),
                width:
                    selected ? 2 : 1,
              ),
              boxShadow:
                  const [
                BoxShadow(
                  color:
                      Color(
                    0x14000000,
                  ),
                  blurRadius:
                      5,
                  offset:
                      Offset(0, 2),
                ),
              ],
            ),
            child:
                Stack(
              children: [
                // ==================================================
                // THUMBNAIL
                // ==================================================

                Positioned.fill(
                  child:
                      Padding(
                    padding:
                        const EdgeInsets
                            .all(
                      3,
                    ),
                    child:
                        ClipRRect(
                      borderRadius:
                          BorderRadius
                              .circular(
                        5,
                      ),
                      child:
                          Container(
                        color:
                            const Color(
                          0xFFF7F7F7,
                        ),
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
                  child:
                      Container(
                    constraints:
                        const BoxConstraints(
                      minWidth:
                          22,
                    ),
                    height: 21,
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal:
                          5,
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
                    child:
                        Text(
                      '$frameNumber',
                      style:
                          const TextStyle(
                        color:
                            Colors.white,
                        fontSize:
                            10,
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
                    child:
                        Icon(
                      Icons.check_circle,
                      size: 19,
                      color:
                          Colors.blue,
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
// ADD FRAME CARD
// =====================================================================

class _AddFrameCard
    extends StatelessWidget {
  const _AddFrameCard({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color:
          Colors.transparent,
      borderRadius:
          BorderRadius.circular(
        8,
      ),
      child:
          InkWell(
        onTap:
            onTap,
        borderRadius:
            BorderRadius.circular(
          8,
        ),
        child:
            Container(
          width: 120,
          height: 80,
          decoration:
              BoxDecoration(
            color:
                Colors.white,
            borderRadius:
                BorderRadius.circular(
              8,
            ),
            border:
                Border.all(
              color:
                  const Color(
                0xFFD9D9D9,
              ),
            ),
            boxShadow:
                const [
              BoxShadow(
                color:
                    Color(
                  0x14000000,
                ),
                blurRadius:
                    5,
                offset:
                    Offset(0, 2),
              ),
            ],
          ),
          child:
              const Center(
            child:
                Icon(
              Icons.add_rounded,
              size: 34,
              color:
                  Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}