import 'package:flutter/material.dart';

import 'package:flutter_application_1/home/project_controller.dart';
import 'package:flutter_application_1/home/project_scope.dart';

class EditorTopBar extends StatefulWidget {
  const EditorTopBar({
    super.key,
    required this.onBack,
    required this.onDiamond,
    required this.onAudio,
    required this.onCopy,
    required this.onPaste,
    required this.onDuplicate,
    required this.onUndo,
    required this.onRedo,
    required this.onMore,
    required this.onFitToScreen,
    required this.onHidePanels,
    required this.onProjectSettings,
    required this.onFramesViewer,
  });

  // ============================================================
  // UI ACTION CALLBACKS
  // ============================================================

  final VoidCallback onBack;
  final VoidCallback onDiamond;
  final VoidCallback onAudio;
  final VoidCallback onCopy;
  final VoidCallback onPaste;
  final VoidCallback onDuplicate;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onMore;
  final VoidCallback onFitToScreen;
  final VoidCallback onHidePanels;
  final VoidCallback onProjectSettings;
  final VoidCallback onFramesViewer;

  @override
  State<EditorTopBar> createState() =>
      _EditorTopBarState();
}

class _EditorTopBarState extends State<EditorTopBar> {
  // ============================================================
  // TEMPORARY UI STATE
  // ============================================================

  bool _onionSkinEnabled = false;
  bool _gridEnabled = false;

  // ============================================================
  // PROJECT CONTROLLER
  // ============================================================

  ProjectController get projectController =>
      ProjectScope.of(context);

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final controller = ProjectScope.of(context);

    final projectName =
        controller.currentProjectName ??
            'AnimeClip';

    return Container(
      height: 56,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFEAEAEA),
            width: 1,
          ),
        ),
      ),
      child: Stack(
        children: [
          // =========================================================
          // LEFT SIDE
          // =========================================================

          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: widget.onBack,
                  tooltip: 'Back',
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.black,
                  ),
                ),

                ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: 260,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment:
                        Alignment.centerLeft,
                    child: Text(
                      projectName,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // =========================================================
          // EXACT CENTER FIT-TO-SCREEN ICON
          // =========================================================

          Positioned.fill(
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onFitToScreen,
                  borderRadius:
                      BorderRadius.circular(8),
                  splashColor:
                      Colors.blue.withValues(
                    alpha: 0.18,
                  ),
                  highlightColor:
                      Colors.blue.withValues(
                    alpha: 0.10,
                  ),
                  child: SizedBox(
                    width: 50,
                    height: 56,
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 26,
                          height: 26,
                          child: _FitScreenIcon(),
                        ),
                        const Text(
                          'Fit',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight:
                                FontWeight.w500,
                            color:
                                Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // =========================================================
          // RIGHT SIDE
          // =========================================================

          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _topBarAction(
                  icon: Icons.fit_screen_outlined,
                  label: 'Hide',
                  onPressed:
                      widget.onHidePanels,
                  tooltip: 'Hide Controls',
                ),

                _topBarAction(
                  icon: Icons.undo_rounded,
                  label: 'Undo',
                  onPressed: widget.onUndo,
                  tooltip: 'Undo',
                ),

                _topBarAction(
                  icon: Icons.redo_rounded,
                  label: 'Redo',
                  onPressed: widget.onRedo,
                  tooltip: 'Redo',
                ),

                _topBarAction(
                  icon:
                      Icons.content_copy_outlined,
                  label: 'Copy',
                  onPressed: widget.onCopy,
                  tooltip: 'Copy',
                ),

                _topBarAction(
                  icon:
                      Icons.content_paste_outlined,
                  label: 'Paste',
                  onPressed: widget.onPaste,
                  tooltip: 'Paste',
                ),

                _topBarAction(
                  icon: Icons
                      .control_point_duplicate_outlined,
                  label: 'Duplicate',
                  onPressed:
                      widget.onDuplicate,
                  tooltip: 'Duplicate',
                ),

                _topBarAction(
                  icon:
                      Icons.volume_up_outlined,
                  label: 'Audio',
                  onPressed:
                      widget.onAudio,
                  tooltip: 'Audio',
                ),

                _topBarAction(
                  icon: Icons.diamond_outlined,
                  label: 'Diamond',
                  onPressed:
                      widget.onDiamond,
                  tooltip: 'Diamond',
                ),

                _topBarAction(
                  icon:
                      Icons.more_vert_rounded,
                  label: 'More',
                  onPressed: () {
                    _showToolsBottomSheet(
                      context,
                    );

                    widget.onMore();
                  },
                  tooltip: 'More',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // TOP BAR ACTION
  // ================================================================

  Widget _topBarAction({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return SizedBox(
      width: 44,
      height: 52,
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: Colors.transparent,
          borderRadius:
              BorderRadius.circular(8),
          child: InkWell(
            onTap: onPressed,
            borderRadius:
                BorderRadius.circular(8),
            splashColor:
                Colors.blue.withValues(
              alpha: 0.18,
            ),
            highlightColor:
                Colors.blue.withValues(
              alpha: 0.10,
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9,
                    color:
                        Colors.black54,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // TOOLS SHEET
  // ================================================================

  void _showToolsBottomSheet(
    BuildContext context,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        bool onionSkinEnabled =
            _onionSkinEnabled;

        bool gridEnabled =
            _gridEnabled;

        return StatefulBuilder(
          builder: (
            context,
            setSheetState,
          ) {
            return SizedBox(
              height:
                  MediaQuery.sizeOf(
                    context,
                  ).height,
              width: double.infinity,
              child: Material(
                color: Colors.white,
                child: SafeArea(
                  child: Column(
                    children: [
                      // =================================================
                      // SHEET HEADER
                      // =================================================

                      SizedBox(
                        height: 64,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).pop();
                              },
                              tooltip: 'Close',
                              icon:
                                  const Icon(
                                Icons
                                    .close_rounded,
                                color:
                                    Colors.black,
                              ),
                            ),

                            const SizedBox(
                              width: 8,
                            ),

                            const Text(
                              'Tools',
                              style:
                                  TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight
                                        .w700,
                                color:
                                    Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Divider(
                        height: 1,
                        color:
                            Color(0xFFEAEAEA),
                      ),

                      // =================================================
                      // TOOLS
                      // =================================================

                      Expanded(
                        child: ListView(
                          padding:
                              const EdgeInsets
                                  .all(20),
                          children: [
                            _toolAction(
                              icon: Icons
                                  .settings_outlined,
                              title:
                                  'Project Settings',
                              onTap: () {
                                Navigator.of(
                                  context,
                                ).pop();

                                widget
                                    .onProjectSettings();
                              },
                            ),

                            // =================================================
                            // FRAMES VIEWER
                            // =================================================
                            //
                            // Navigation itself is handled by the
                            // onFramesViewer callback from EditorUI.
                            // =================================================

                            _toolAction(
                              icon: Icons
                                  .movie_outlined,
                              title:
                                  'Frames Viewer',
                              onTap: () {
                                Navigator.of(
                                  context,
                                ).pop();

                                widget
                                    .onFramesViewer();
                              },
                            ),

                            _toolAction(
                              icon: Icons
                                  .image_outlined,
                              title:
                                  'Add Image',
                              onTap: () {
                                Navigator.of(
                                  context,
                                ).pop();
                              },
                            ),

                            _toolAction(
                              icon: Icons
                                  .video_library_outlined,
                              title:
                                  'Add Video',
                              onTap: () {
                                Navigator.of(
                                  context,
                                ).pop();
                              },
                            ),

                            _toolToggle(
                              icon: Icons
                                  .layers_outlined,
                              title:
                                  'Onion Skin',
                              value:
                                  onionSkinEnabled,
                              onEdit: () {},
                              onChanged:
                                  (value) {
                                setSheetState(
                                  () {
                                    onionSkinEnabled =
                                        value;
                                  },
                                );

                                setState(
                                  () {
                                    _onionSkinEnabled =
                                        value;
                                  },
                                );
                              },
                            ),

                            _toolToggle(
                              icon: Icons
                                  .grid_on_outlined,
                              title: 'Grid',
                              value:
                                  gridEnabled,
                              onEdit: () {},
                              onChanged:
                                  (value) {
                                setSheetState(
                                  () {
                                    gridEnabled =
                                        value;
                                  },
                                );

                                setState(
                                  () {
                                    _gridEnabled =
                                        value;
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ================================================================
  // TOOL ACTION
  // ================================================================

  Widget _toolAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 12,
      ),
      child: Material(
        color:
            const Color(0xFFF7F7F7),
        borderRadius:
            BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(14),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.black,
                  size: 22,
                ),

                const SizedBox(
                  width: 14,
                ),

                Expanded(
                  child: Text(
                    title,
                    style:
                        const TextStyle(
                      fontSize: 15,
                      fontWeight:
                          FontWeight.w600,
                      color:
                          Colors.black,
                    ),
                  ),
                ),

                const Icon(
                  Icons
                      .chevron_right_rounded,
                  color:
                      Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // TOOL TOGGLE
  // ================================================================

  Widget _toolToggle({
    required IconData icon,
    required String title,
    required bool value,
    required VoidCallback onEdit,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 12,
      ),
      child: Container(
        decoration:
            BoxDecoration(
          color:
              const Color(0xFFF7F7F7),
          borderRadius:
              BorderRadius.circular(
            14,
          ),
        ),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.black,
              size: 22,
            ),

            const SizedBox(
              width: 14,
            ),

            Expanded(
              child: Text(
                title,
                style:
                    const TextStyle(
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w600,
                  color:
                      Colors.black,
                ),
              ),
            ),

            TextButton(
              onPressed: onEdit,
              style:
                  TextButton.styleFrom(
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 10,
                ),
                minimumSize:
                    Size.zero,
                tapTargetSize:
                    MaterialTapTargetSize
                        .shrinkWrap,
              ),
              child: const Text(
                'Edit',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      FontWeight.w600,
                  color:
                      Colors.black,
                ),
              ),
            ),

            const SizedBox(
              width: 8,
            ),

            GestureDetector(
              onTap: () {
                onChanged(!value);
              },
              child: AnimatedContainer(
                duration:
                    const Duration(
                  milliseconds: 180,
                ),
                width: 42,
                height: 24,
                padding:
                    const EdgeInsets.all(
                  3,
                ),
                decoration:
                    BoxDecoration(
                  color: value
                      ? Colors.black
                      : const Color(
                          0xFFD6D6D6,
                        ),
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),
                child: AnimatedAlign(
                  duration:
                      const Duration(
                    milliseconds: 180,
                  ),
                  alignment: value
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration:
                        const BoxDecoration(
                      color: Colors.white,
                      shape:
                          BoxShape.circle,
                    ),
                  ),
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
// FIT TO SCREEN ICON
// =====================================================================

class _FitScreenIcon
    extends StatelessWidget {
  const _FitScreenIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size:
          const Size(30, 30),
      painter:
          _FitScreenIconPainter(),
    );
  }
}

class _FitScreenIconPainter
    extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2.4
      ..style =
          PaintingStyle.stroke
      ..strokeCap =
          StrokeCap.round
      ..strokeJoin =
          StrokeJoin.round;

    // =========================================================
    // TOP-LEFT
    // =========================================================

    canvas.drawLine(
      const Offset(11, 4),
      const Offset(4, 4),
      paint,
    );

    canvas.drawLine(
      const Offset(4, 4),
      const Offset(4, 11),
      paint,
    );

    // =========================================================
    // TOP-RIGHT
    // =========================================================

    canvas.drawLine(
      const Offset(19, 4),
      const Offset(26, 4),
      paint,
    );

    canvas.drawLine(
      const Offset(26, 4),
      const Offset(26, 11),
      paint,
    );

    // =========================================================
    // BOTTOM-LEFT
    // =========================================================

    canvas.drawLine(
      const Offset(4, 19),
      const Offset(4, 26),
      paint,
    );

    canvas.drawLine(
      const Offset(4, 26),
      const Offset(11, 26),
      paint,
    );

    // =========================================================
    // BOTTOM-RIGHT
    // =========================================================

    canvas.drawLine(
      const Offset(19, 26),
      const Offset(26, 26),
      paint,
    );

    canvas.drawLine(
      const Offset(26, 26),
      const Offset(26, 19),
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}