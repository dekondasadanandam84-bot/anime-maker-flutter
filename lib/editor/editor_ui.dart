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
  const EditorScreen({super.key, required this.clipId});

  final String clipId;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late final EditorController _controller;
  bool _controllerInitialized = false;

  ProjectController get projectController => ProjectScope.of(context);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controllerInitialized) return;

    final controller = ProjectScope.of(context);
    _controller = EditorController(
      projectController: controller,
      clipId: widget.clipId,
    );
    _controllerInitialized = true;
  }

  @override
  void dispose() {
    if (_controllerInitialized) _controller.dispose();
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
        return _buildEditor(context, controller);
      },
    );
  }

  void _openFramesViewer() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FramesViewerUI(
          bottomBarController: _controller.bottomBarController,
          controller: _controller.framesViewerController,
          onAddFrames: () => _showAddFramesSheet(context),
        ),
      ),
    );
  }

  void _showAddFramesSheet(BuildContext context) {
    showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddFramesSheet(),
    ).then((count) {
      if (count != null) _controller.bottomBarController.addFrames(count);
    });
  }

  Widget _buildOrientationScreen() {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final horizontalPadding = width < 360 ? 20.0 : 32.0;
              final iconSize = width < 360 ? 64.0 : 88.0;
              final titleSize = width < 360 ? 22.0 : 26.0;
              final bodySize = width < 360 ? 14.0 : 16.0;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.screen_rotation_alt_rounded,
                      size: iconSize,
                      color: colorScheme.onSurface,
                    ),
                    SizedBox(height: width < 360 ? 20 : 28),
                    Text(
                      'Rotate Your Device',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Turn your device sideways to use the editor in landscape mode.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: bodySize,
                        height: 1.5,
                        color: colorScheme.onSurfaceVariant,
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

  Widget _buildEditor(
    BuildContext context,
    ProjectController projectController,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final metrics = EditorResponsive.forSize(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
        );

        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: Column(
            children: [
              AnimatedBuilder(
                animation: Listenable.merge([
                  _controller,
                  _controller.topBarController,
                ]),
                builder: (context, child) {
                  final topBar = _controller.topBarController;
                  if (topBar.panelsHidden) {
                    return const SizedBox.shrink();
                  }

                  return EditorTopBar(
                    metrics: metrics,
                    onBack: () => Navigator.of(context).pop(),
                    onDiamond: _controller.onDiamondPressed,
                    onAudio: _controller.onAudioPressed,
                    onCopy: _controller.onCopyPressed,
                    onPaste: _controller.onPastePressed,
                    onDuplicate: _controller.onDuplicatePressed,
                    onUndo: _controller.onUndoPressed,
                    onRedo: _controller.onRedoPressed,
                    onMore: _controller.onMorePressed,
                    onProjectSettings: () {
                      projectController.beginEditCurrentProject();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CreateProjectScreen(),
                        ),
                      );
                    },
                    onFramesViewer: _openFramesViewer,
                    onFitToScreen: _controller.onFitToScreen,
                    onHidePanels: _controller.onHidePanels,
                  );
                },
              ),
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
                    final leftPanel = _controller.leftPanelController;
                    final topBar = _controller.topBarController;
                    final controlsHidden = topBar.panelsHidden;

                    return Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Positioned.fill(
                          child: MiddleUI(
                            metrics: metrics,
                            controller: _controller.middleController,
                          ),
                        ),
                        if (!leftPanel.paintSheetOpen)
                          Positioned(
                            left: metrics.horizontalInset,
                            top: 0,
                            bottom: metrics.bottomBarHeight,
                            child: Center(
                              child: LeftPanelUI(
                                metrics: metrics,
                                controller: leftPanel,
                                compact: controlsHidden,
                              ),
                            ),
                          ),
                        if (leftPanel.rightPanelOpen)
                          Positioned(
                            right: metrics.horizontalInset,
                            top: 0,
                            bottom: metrics.bottomBarHeight,
                            child: Center(
                              child: RightPanelUI(
                                metrics: metrics,
                                tool: leftPanel.selectedTool,
                              ),
                            ),
                          ),
                        if (leftPanel.paintSheetOpen)
                          Positioned.fill(
                            child: Material(
                              color: colorScheme.surface,
                              child: SafeArea(
                                child: Column(
                                  children: [
                                    Container(
                                      height: metrics.topBarHeight,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: metrics.horizontalInset,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colorScheme.surface,
                                        border: Border(
                                          bottom: BorderSide(
                                            color: colorScheme.outlineVariant,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: leftPanel.closePaintSheet,
                                            icon: Icon(
                                              Icons.arrow_back_rounded,
                                              color: colorScheme.onSurface,
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                'Paint',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: colorScheme.onSurface,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: metrics.topActionWidth,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          'Paint',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (!leftPanel.paintSheetOpen)
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: BottomBarUI(
                              metrics: metrics,
                              controller: _controller.bottomBarController,
                              onPreviousFrame: _controller.onPreviousFramePressed,
                              onPlayPause: _controller.onPlayPausePressed,
                              onNextFrame: _controller.onNextFramePressed,
                              controlsHidden: controlsHidden,
                            ),
                          ),
                        if (controlsHidden && !leftPanel.paintSheetOpen)
                          Positioned(
                            top: metrics.panelGap,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: _ShowControlsButton(
                                metrics: metrics,
                                onTap: _controller.onHidePanels,
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

class _AddFramesSheet extends StatelessWidget {
  const _AddFramesSheet();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 520),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Add Frames',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 30,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.25,
                ),
                itemBuilder: (context, index) {
                  final count = index + 1;
                  return Material(
                    color: colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(count),
                      borderRadius: BorderRadius.circular(10),
                      child: Center(
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
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

class _ShowControlsButton extends StatelessWidget {
  const _ShowControlsButton({
    required this.metrics,
    required this.onTap,
  });

  final EditorResponsiveData metrics;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: metrics.isSmall ? 8 : 10,
            vertical: metrics.isSmall ? 5 : 6,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colorScheme.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.fit_screen_rounded,
                size: metrics.isSmall ? 15 : 17,
                color: colorScheme.onSurface,
              ),
              const SizedBox(height: 1),
              Text(
                'Show',
                style: TextStyle(
                  fontSize: metrics.isSmall ? 7 : 8,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
