import 'package:flutter/material.dart';

import 'package:flutter_application_1/home/create_project_screen.dart';
import 'package:flutter_application_1/home/project_controller.dart';
import 'package:flutter_application_1/home/project_scope.dart';

import 'editor_controller.dart';
import 'editor_responsive.dart';
import 'left_panel/left_panel_ui.dart';
import 'right_panel/right_panel_ui.dart';
import 'top_bar/top_bar_ui.dart';
import 'bottom_bar/bottom_bar_ui.dart';
import 'bottom_bar/frames_viewer_ui.dart';
import 'middle/middle_ui.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({
    super.key,
    required this.clipId,
  });

  final String clipId;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late final EditorController _controller;

  bool _controllerInitialized = false;

  ProjectController get projectController =>
      ProjectScope.of(context);

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

  @override
  void dispose() {
    if (_controllerInitialized) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ProjectScope.of(context);

    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return _buildOrientationScreen();
        }

        return _buildEditor(
          context,
          controller,
        );
      },
    );
  }

  // ============================================================
  // OPEN FRAMES VIEWER
  // ============================================================

  void _openFramesViewer() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FramesViewerUI(
          bottomBarController:
              _controller.bottomBarController,
          controller:
              _controller.framesViewerController,
          onAddFrames: () {
            _showAddFramesSheet(context);
          },
        ),
      ),
    );
  }

  // ============================================================
  // ADD FRAMES SHEET
  // ============================================================

  void _showAddFramesSheet(
    BuildContext context,
  ) {
    showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const _AddFramesSheet();
      },
    ).then((count) {
      if (count == null) {
        return;
      }

      _controller.bottomBarController.addFrames(count);
    });
  }

  // ============================================================
  // PORTRAIT SCREEN
  // ============================================================

  Widget _buildOrientationScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              final horizontalPadding =
                  width < 360 ? 20.0 : 32.0;

              final iconSize =
                  width < 360 ? 64.0 : 88.0;

              final titleSize =
                  width < 360 ? 22.0 : 26.0;

              final bodySize =
                  width < 360 ? 14.0 : 16.0;

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.screen_rotation_alt_rounded,
                      size: iconSize,
                      color: Colors.black,
                    ),

                    SizedBox(
                      height: width < 360 ? 20 : 28,
                    ),

                    Text(
                      'Rotate Your Device',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Turn your device sideways to use the editor in landscape mode.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: bodySize,
                        height: 1.5,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LANDSCAPE EDITOR
  // ============================================================

  Widget _buildEditor(
    BuildContext context,
    ProjectController projectController,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final metrics =
            EditorResponsive.forSize(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
        );

        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // ==================================================
              // TOP BAR
              // ==================================================

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
                    metrics: metrics,
                    onBack: () {
                      Navigator.of(context).pop();
                    },

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

                    onProjectSettings: () {
                      projectController
                          .beginEditCurrentProject();

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const CreateProjectScreen(),
                        ),
                      );
                    },

                    onFramesViewer:
                        _openFramesViewer,

                    onFitToScreen:
                        _controller.onFitToScreen,

                    onHidePanels:
                        _controller.onHidePanels,
                  );
                },
              ),

              // ==================================================
              // EDITOR AREA
              // ==================================================

              Expanded(
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _controller,
                    _controller.topBarController,
                    _controller.leftPanelController,
                    _controller.bottomBarController,
                    _controller.framesViewerController,
                  ]),
                  builder: (context, child) {
                    final leftPanel =
                        _controller.leftPanelController;

                    final topBar =
                        _controller.topBarController;

                    final controlsHidden =
                        topBar.panelsHidden;

                    return Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        // =========================================
                        // CANVAS
                        // =========================================

                        Positioned.fill(
                          child: MiddleUI(
                            metrics: metrics,
                            controller:
                                _controller.middleController,
                          ),
                        ),

                        // =========================================
                        // LEFT FLOATING TOOLBAR
                        // =========================================

                        if (!leftPanel.paintSheetOpen)
                          Positioned(
                            left: metrics.horizontalInset,
                            top: 0,
                            bottom:
                                metrics.bottomBarHeight,
                            child: Center(
                              child: LeftPanelUI(
                                metrics: metrics,
                                controller: leftPanel,
                                compact:
                                    controlsHidden,
                              ),
                            ),
                          ),

                        // =========================================
                        // RIGHT FLOATING TOOL PANEL
                        // =========================================

                        if (leftPanel.rightPanelOpen)
                          Positioned(
                            right:
                                metrics.horizontalInset,
                            top: 0,
                            bottom:
                                metrics.bottomBarHeight,
                            child: Center(
                              child: RightPanelUI(
                                metrics: metrics,
                                tool:
                                    leftPanel.selectedTool,
                              ),
                            ),
                          ),

                        // =========================================
                        // FULL SCREEN PAINT SHEET
                        // =========================================

                        if (leftPanel.paintSheetOpen)
                          Positioned.fill(
                            child: Material(
                              color: Colors.white,
                              child: SafeArea(
                                child: Column(
                                  children: [
                                    Container(
                                      height:
                                          metrics.topBarHeight,
                                      padding:
                                          EdgeInsets.symmetric(
                                        horizontal:
                                            metrics.horizontalInset,
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
                                            icon:
                                                const Icon(
                                              Icons
                                                  .arrow_back_rounded,
                                              color:
                                                  Colors.black,
                                            ),
                                          ),

                                          const Expanded(
                                            child: Center(
                                              child: Text(
                                                'Paint',
                                                style:
                                                    TextStyle(
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.w700,
                                                  color:
                                                      Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),

                                          SizedBox(
                                            width:
                                                metrics
                                                    .topActionWidth,
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
                                            color:
                                                Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        // =========================================
                        // BOTTOM BAR
                        // =========================================

                        if (!leftPanel.paintSheetOpen)
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: BottomBarUI(
                              metrics: metrics,
                              controller:
                                  _controller
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

                              controlsHidden:
                                  controlsHidden,
                            ),
                          ),

                        // =========================================
                        // SHOW CONTROLS
                        // =========================================

                        if (controlsHidden &&
                            !leftPanel.paintSheetOpen)
                          Positioned(
                            top: metrics.panelGap,
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
      },
    );
  }
}

// ================================================================
// ADD FRAMES SHEET
// ================================================================

class _AddFramesSheet
    extends StatelessWidget {
  const _AddFramesSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints:
            const BoxConstraints(
          maxHeight: 520,
        ),
        padding:
            const EdgeInsets.fromLTRB(
          20,
          14,
          20,
          20,
        ),
        decoration:
            const BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child:
            SingleChildScrollView(
          child:
              Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration:
                    BoxDecoration(
                  color:
                      const Color(0xFFD8D8D8),
                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                ),
              ),

              const SizedBox(
                height: 14,
              ),

              const Text(
                'Add Frames',
                style:
                    TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.w700,
                  color:
                      Colors.black87,
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount: 30,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.25,
                ),
                itemBuilder:
                    (context, index) {
                  final count =
                      index + 1;

                  return Material(
                    color:
                        const Color(
                      0xFFF5F7FA,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                    child:
                        InkWell(
                      onTap: () {
                        Navigator.of(
                          context,
                        ).pop(count);
                      },
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                      child:
                          Center(
                        child:
                            Text(
                          '$count',
                          style:
                              const TextStyle(
                            fontSize:
                                14,
                            fontWeight:
                                FontWeight.w600,
                            color:
                                Colors.black87,
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

// ================================================================
// SHOW CONTROLS BUTTON
// ================================================================

class _ShowControlsButton
    extends StatelessWidget {
  const _ShowControlsButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final metrics =
        EditorResponsive.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius:
          BorderRadius.circular(
        10,
      ),
      child:
          InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(
          10,
        ),
        child:
            Container(
          padding:
              EdgeInsets.symmetric(
            horizontal:
                metrics.isSmall
                    ? 8
                    : 10,
            vertical:
                metrics.isSmall
                    ? 5
                    : 6,
          ),
          decoration:
              BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(
              10,
            ),
            border:
                Border.all(
              color:
                  const Color(
                0xFFEAEAEA,
              ),
            ),
            boxShadow:
                const [
              BoxShadow(
                color:
                    Color(
                  0x18000000,
                ),
                blurRadius: 8,
                offset:
                    Offset(
                  0,
                  3,
                ),
              ),
            ],
          ),
          child:
              Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Icon(
                Icons
                    .fit_screen_rounded,
                size:
                    metrics.isSmall
                        ? 15
                        : 17,
                color:
                    Colors.black87,
              ),
              const SizedBox(
                height: 1,
              ),
              Text(
                'Show',
                style:
                    TextStyle(
                  fontSize:
                      metrics.isSmall
                          ? 7
                          : 8,
                  fontWeight:
                      FontWeight.w600,
                  color:
                      Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}