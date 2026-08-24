import 'package:flutter/material.dart';

import 'editor_controller.dart';
import 'left_panel/left_panel_ui.dart';
import 'right_panel/right_panel_ui.dart';
import 'top_bar/top_bar_ui.dart';
import 'bottom_bar/bottom_bar_ui.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key, required this.clipId, required this.clipName});

  final String clipId;
  final String clipName;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late final EditorController _controller;

  @override
  void initState() {
    super.initState();

    _controller = EditorController(
      clipId: widget.clipId,
      clipName: widget.clipName,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return _buildOrientationScreen();
        }

        return _buildEditor();
      },
    );
  }

  Widget _buildOrientationScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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

  Widget _buildEditor() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // =========================================================
          // TOP BAR
          // =========================================================
          AnimatedBuilder(
            animation: _controller.topBarController,
            builder: (context, child) {
              return EditorTopBar(
                projectName: widget.clipName,

                onBack: () {
                  Navigator.of(context).pop();
                },

                onDiamond: _controller.onDiamondPressed,

                onAudio: _controller.onAudioPressed,

                onCopy: _controller.onCopyPressed,

                onPaste: _controller.onPastePressed,

                onDuplicate: _controller.onDuplicatePressed,

                onUndo: _controller.onUndoPressed,

                onRedo: _controller.onRedoPressed,

                onMore: _controller.onMorePressed,

                onProjectSettings: () {
                  // Open Project Settings later.
                },

                onFramesViewer: () {
                  // Open Frames Viewer later.
                },

                onFitToScreen: _controller.onFitToScreen,

                onHidePanels: _controller.onHidePanels,
              );
            },
          ),

          // =========================================================
          // EDITOR AREA
          // =========================================================
          Expanded(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _controller.leftPanelController,
                _controller.bottomBarController,
              ]),
              builder: (context, child) {
                final leftPanel = _controller.leftPanelController;

                return Stack(
                  children: [
                    // =================================================
                    // CANVAS
                    // =================================================
                    const Positioned.fill(
                      child: Center(
                        child: Text(
                          'Canvas',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),

                    // =================================================
                    // LEFT FLOATING TOOLBAR
                    // =================================================
                    Positioned(
                      left: 16,
                      top: 0,
                      bottom: 0,
                      child: Center(child: LeftPanelUI(controller: leftPanel)),
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
                          child: RightPanelUI(tool: leftPanel.selectedTool),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFEAEAEA),
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      leftPanel.closePaintSheet();
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.black,
                    ),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        'Paint',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 48),
                ],
              ),
            ),

            const Expanded(
              child: Center(
                child: Text(
                  'Paint',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
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
      controller: _controller.bottomBarController,
      onPreviousFrame:
          _controller.onPreviousFramePressed,
      onPlayPause:
          _controller.onPlayPausePressed,
      onNextFrame:
          _controller.onNextFramePressed,
      onAddFrame:
          _controller.onAddFramePressed,
      onFrameSelected:
          _controller.onFrameSelected,
    ),
  ),
                  
        ]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
