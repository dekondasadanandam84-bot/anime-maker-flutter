
import 'package:flutter/material.dart';

import 'package:flutter_application_1/home/create_project_screen.dart';
import 'package:flutter_application_1/home/project_controller.dart';
import 'package:flutter_application_1/home/project_scope.dart';

import 'editor_controller.dart';
import 'left_panel/left_panel_ui.dart';
import 'right_panel/right_panel_ui.dart';
import 'top_bar/top_bar_ui.dart';
import 'bottom_bar/bottom_bar_ui.dart';
import 'middle/middle_ui.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({
    super.key,
    required this.clipId,
  });

  // ============================================================
  // EDITOR CONTEXT
  // ============================================================
  //
  // The clip ID identifies what this editor is editing.
  //
  // Project name, project settings, FPS, resolution, aspect ratio
  // and the actual clip data all come from ProjectController.
  // ============================================================

  final String clipId;

  @override
  State<EditorScreen> createState() =>
      _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late final EditorController _controller;

  bool _controllerInitialized = false;

  // ============================================================
  // PROJECT CONTROLLER
  // ============================================================

  ProjectController get projectController =>
      ProjectScope.of(context);

  // ============================================================
  // CONTROLLER INITIALIZATION
  // ============================================================

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_controllerInitialized) {
      return;
    }

    final controller = ProjectScope.of(context);

    _controller = EditorController(
      projectController: controller,
      clipId: widget.clipId,
    );

    _controllerInitialized = true;
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    if (_controllerInitialized) {
      _controller.dispose();
    }

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    // Establish the dependency on ProjectController.
    final controller = ProjectScope.of(context);

    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return _buildOrientationScreen();
        }

        return _buildEditor(controller);
      },
    );
  }

  // ============================================================
  // PORTRAIT ORIENTATION SCREEN
  // ============================================================

  Widget _buildOrientationScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.screen_rotation_alt_rounded,
                  size: 88,
                  color: Colors.black,
                ),
                const SizedBox(height: 28),
                const Text(
                  'Rotate Your Device',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Turn your device sideways to use the editor in landscape mode.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LANDSCAPE EDITOR
  // ============================================================

  Widget _buildEditor(
    ProjectController projectController,
  ) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // =======================================================
          // TOP BAR
          // =======================================================

          AnimatedBuilder(
            animation: Listenable.merge([
              _controller,
              _controller.topBarController,
            ]),
            builder: (context, child) {
              final topBar =
                  _controller.topBarController;

              if (topBar.panelsHidden) {
                return const SizedBox.shrink();
              }

              

              return EditorTopBar(
                

                // ------------------------------------------------
                // BACK
                // ------------------------------------------------

                onBack: () {
                  Navigator.of(context).pop();
                },

                // ------------------------------------------------
                // TOP BAR ACTIONS
                // ------------------------------------------------

                onDiamond:
                    _controller.onDiamondPressed,

                onAudio:
                    _controller.onAudioPressed,

                onCopy:
                    _controller.onCopyPressed,

                onPaste:
                    _controller.onPastePressed,

                onDuplicate:
                    _controller.onDuplicatePressed,

                onUndo:
                    _controller.onUndoPressed,

                onRedo:
                    _controller.onRedoPressed,

                onMore:
                    _controller.onMorePressed,

                // ------------------------------------------------
                // PROJECT SETTINGS
                // ------------------------------------------------

                onProjectSettings: () {
                  projectController
                      .beginEditCurrentProject();

                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const CreateProjectScreen(),
                    ),
                  );
                },

                // ------------------------------------------------
                // FRAMES VIEWER
                // ------------------------------------------------

                onFramesViewer: () {
                  // Open Frames Viewer later.
                },

                // ------------------------------------------------
                // FIT
                // ------------------------------------------------

                onFitToScreen:
                    _controller.onFitToScreen,

                // ------------------------------------------------
                // HIDE PANELS
                // ------------------------------------------------

                onHidePanels:
                    _controller.onHidePanels,
              );
            },
          ),

          // =======================================================
          // EDITOR AREA
          // =======================================================

          Expanded(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _controller,
                _controller.topBarController,
                _controller.leftPanelController,
                _controller.bottomBarController,
              ]),
              builder: (context, child) {
                final leftPanel =
                    _controller.leftPanelController;

                final topBar =
                    _controller.topBarController;

                final controlsHidden =
                    topBar.panelsHidden;

                return Stack(
                  children: [
                    // =================================================
                    // CANVAS
                    // =================================================

                    Positioned.fill(
                      child: MiddleUI(
                        controller:
                            _controller.middleController,
                      ),
                    ),

                    // =================================================
                    // LEFT FLOATING TOOLBAR
                    // =================================================

                    if (!leftPanel.paintSheetOpen)
                      Positioned(
                        left: 16,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: LeftPanelUI(
                            controller: leftPanel,
                            compact:
                                controlsHidden,
                          ),
                        ),
                      ),

                    // =================================================
                    // RIGHT FLOATING TOOL PANEL
                    // =================================================

                    if (leftPanel.rightPanelOpen)
                      Positioned(
                        right: 16,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: RightPanelUI(
                            tool:
                                leftPanel.selectedTool,
                          ),
                        ),
                      ),

                    // =================================================
                    // FULL-SCREEN PAINT SHEET
                    // =================================================

                    if (leftPanel.paintSheetOpen)
                      Positioned.fill(
                        child: Material(
                          color: Colors.white,
                          child: SafeArea(
                            child: Column(
                              children: [
                                Container(
                                  height: 64,
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 12,
                                  ),
                                  decoration:
                                      const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      bottom:
                                          BorderSide(
                                        color:
                                            Color(
                                          0xFFEAEAEA,
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          leftPanel
                                              .closePaintSheet();
                                        },
                                        icon: const Icon(
                                          Icons
                                              .arrow_back_rounded,
                                          color:
                                              Colors.black,
                                        ),
                                      ),
                                      const Expanded(
                                        child: Center(
                                          child:
                                              Text(
                                            'Paint',
                                            style:
                                                TextStyle(
                                              fontSize:
                                                  18,
                                              fontWeight:
                                                  FontWeight
                                                      .w700,
                                              color:
                                                  Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 48,
                                      ),
                                    ],
                                  ),
                                ),
                                const Expanded(
                                  child: Center(
                                    child: Text(
                                      'Paint',
                                      style:
                                          TextStyle(
                                        fontSize: 18,
                                        color: Colors
                                            .black54,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // =================================================
                    // BOTTOM BAR
                    // =================================================

                    if (!leftPanel.paintSheetOpen)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: BottomBarUI(
                          controller: _controller
                              .bottomBarController,

                          onPreviousFrame:
                              _controller
                                  .onPreviousFramePressed,

                          onPlayPause:
                              _controller
                                  .onPlayPausePressed,

                          onNextFrame:
                              _controller
                                  .onNextFramePressed,

                          onAddFrames:
                              _controller
                                  .onAddFramesPressed,

                          onFrameSelected:
                              _controller
                                  .onFrameSelected,

                          onCopy:
                              _controller
                                  .onCopyPressed,

                          onPaste:
                              _controller
                                  .onPastePressed,

                          controlsHidden:
                              controlsHidden,
                        ),
                      ),

                    // =================================================
                    // SHOW CONTROLS BUTTON
                    // =================================================

                    if (controlsHidden &&
                        !leftPanel.paintSheetOpen)
                      Positioned(
                        top: 4,
                        left: 0,
                        right: 0,
                        child: Center(
                          child:
                              _ShowControlsButton(
                            onTap:
                                _controller
                                    .onHidePanels,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// SHOW CONTROLS BUTTON
// ================================================================

class _ShowControlsButton extends StatelessWidget {
  const _ShowControlsButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius:
          BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(10),
        child: Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration:
              BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(10),
            border:
                Border.all(
              color:
                  const Color(0xFFEAEAEA),
            ),
            boxShadow: const [
              BoxShadow(
                color:
                    Color(0x18000000),
                blurRadius: 8,
                offset:
                    Offset(0, 3),
              ),
            ],
          ),
          child: const Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Icon(
                Icons.fit_screen_rounded,
                size: 17,
                color: Colors.black87,
              ),
              SizedBox(height: 1),
              Text(
                'Show',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight:
                      FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

