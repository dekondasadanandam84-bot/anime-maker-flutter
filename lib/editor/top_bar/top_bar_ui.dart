import 'package:flutter/material.dart';
import 'package:flutter_application_1/goplus/go_plus_ui.dart';

import 'package:flutter_application_1/home/project_controller.dart';
import 'package:flutter_application_1/home/project_scope.dart';

import '../editor_responsive.dart';
import 'onion_skin_ui.dart';
import 'grid_ui.dart';

class EditorTopBar extends StatefulWidget {
  const EditorTopBar({
    super.key,
    required this.metrics,
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

  final EditorResponsiveData metrics;

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
  State<EditorTopBar> createState() => _EditorTopBarState();
}

class _EditorTopBarState extends State<EditorTopBar> {
  bool _onionSkinEnabled = false;
  bool _gridEnabled = false;

  // ============================================================
  // PROJECT CONTROLLER
  // ============================================================

  ProjectController get projectController => ProjectScope.of(context);

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final projectName = projectController.currentProjectName ?? 'AnimeClip';

    final metrics = widget.metrics;

    return Container(
      height: metrics.topBarHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
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
                SizedBox(
                  width: metrics.topActionWidth,
                  height: metrics.topBarHeight,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: widget.onBack,
                    tooltip: 'Back',
                    icon: Icon(
                      Icons.close_rounded,
                      size: metrics.topActionIconSize,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),

                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: metrics.isSmall
                        ? 120
                        : metrics.isCompact
                        ? 170
                        : 260,
                  ),
                  child: Text(
                    projectName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: metrics.isSmall ? 14 : 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(width: metrics.isSmall ? 2 : 6),

                Tooltip(
                  message: 'Go Plus',
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const GoPlusUI()),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      splashColor: colorScheme.primary.withValues(alpha: 0.18),
                      highlightColor: colorScheme.primary.withValues(
                        alpha: 0.10,
                      ),
                      child: SizedBox(
                        width: metrics.isSmall ? 32 : 38,
                        height: metrics.topBarHeight,
                        child: Center(
                          child: Icon(
                            Icons.diamond_outlined,
                            size: metrics.isSmall ? 18 : 21,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // =========================================================
          // EXACT CENTER FIT-TO-SCREEN
          // =========================================================
          Positioned.fill(
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onFitToScreen,
                  borderRadius: BorderRadius.circular(8),
                  splashColor: colorScheme.primary.withValues(alpha: 0.18),
                  highlightColor: colorScheme.primary.withValues(alpha: 0.10),
                  child: SizedBox(
                    width: metrics.isSmall ? 42 : 50,
                    height: metrics.topBarHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: metrics.isSmall ? 22 : 26,
                          height: metrics.isSmall ? 22 : 26,
                          child: Image.asset(
                            'assets/fit_screen.png',
                            width: metrics.isSmall ? 22 : 26,
                            height: metrics.isSmall ? 22 : 26,
                            fit: BoxFit.contain,
                          ),
                        ),

                        if (!metrics.isSmall)
                          Text(
                            'Fit',
                            style: TextStyle(
                              fontSize: metrics.topActionLabelSize,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurfaceVariant,
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _topBarAction(
                    icon: Icons.fit_screen_outlined,
                    label: 'Hide',
                    onPressed: widget.onHidePanels,
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
                    icon: Icons.content_copy_outlined,
                    label: 'Copy',
                    onPressed: widget.onCopy,
                    tooltip: 'Copy',
                  ),

                  _topBarAction(
                    icon: Icons.content_paste_outlined,
                    label: 'Paste',
                    onPressed: widget.onPaste,
                    tooltip: 'Paste',
                  ),

                  _topBarAction(
                    icon: Icons.volume_up_outlined,
                    label: 'Audio',
                    onPressed: widget.onAudio,
                    tooltip: 'Audio',
                  ),

                  _topBarAction(
                    icon: Icons.more_vert_rounded,
                    label: 'More',
                    onPressed: () {
                      _showToolsBottomSheet(context);
                      widget.onMore();
                    },
                    tooltip: 'More',
                  ),
                ],
              ),
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
    final colorScheme = Theme.of(context).colorScheme;
    final metrics = widget.metrics;

    return SizedBox(
      width: metrics.topActionWidth,
      height: metrics.topBarHeight,
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(8),
            splashColor: colorScheme.primary.withValues(alpha: 0.18),
            highlightColor: colorScheme.primary.withValues(alpha: 0.10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: metrics.topActionIconSize,
                  color: colorScheme.onSurface,
                ),

                if (!metrics.isSmall) ...[
                  SizedBox(height: metrics.isCompact ? 1 : 2),

                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: metrics.topActionLabelSize,
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
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

  void _showToolsBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        bool onionSkinEnabled = _onionSkinEnabled;
        bool gridEnabled = _gridEnabled;

        final screenWidth = MediaQuery.sizeOf(context).width;

        final compactSheet = screenWidth < 700;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            final colorScheme = Theme.of(context).colorScheme;

            return SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: double.infinity,
              child: Material(
                color: colorScheme.surface,
                child: SafeArea(
                  child: Column(
                    children: [
                      // =============================================
                      // SHEET HEADER
                      // =============================================
                      SizedBox(
                        height: compactSheet ? 56 : 64,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              tooltip: 'Close',
                              icon: Icon(
                                Icons.close_rounded,
                                color: colorScheme.onSurface,
                              ),
                            ),

                            SizedBox(width: compactSheet ? 4 : 8),

                            Text(
                              'Tools',
                              style: TextStyle(
                                fontSize: compactSheet ? 18 : 20,
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Divider(height: 1, color: colorScheme.outlineVariant),

                      // =============================================
                      // TOOLS
                      // =============================================
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.all(compactSheet ? 12 : 20),
                          children: [
                            _toolAction(
                              icon: Icons.settings_outlined,
                              title: 'Project Settings',
                              onTap: () {
                                Navigator.of(context).pop();

                                widget.onProjectSettings();
                              },
                            ),

                            _toolAction(
                              icon: Icons.movie_outlined,
                              title: 'Frames Viewer',
                              onTap: () {
                                Navigator.of(context).pop();

                                widget.onFramesViewer();
                              },
                            ),

                            _toolAction(
                              icon: Icons.image_outlined,
                              title: 'Add Image',
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),

                            _toolAction(
                              icon: Icons.video_library_outlined,
                              title: 'Add Video',
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),

                            // =======================================
                            // ONION SKIN
                            // =======================================
                            _toolToggle(
                              icon: Icons.layers_outlined,
                              title: 'Onion Skin',
                              value: onionSkinEnabled,
                              onEdit: () {
                                Navigator.of(context).pop();

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const OnionSkinUI(),
                                  ),
                                );
                              },
                              onChanged: (value) {
                                setSheetState(() {
                                  onionSkinEnabled = value;
                                });

                                setState(() {
                                  _onionSkinEnabled = value;
                                });
                              },
                            ),

                            // =======================================
                            // GRID
                            // =======================================
                            _toolToggle(
                              icon: Icons.grid_on_outlined,
                              title: 'Grid',
                              value: gridEnabled,
                              onEdit: () {
                                Navigator.of(context).pop();

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        GridUI(initialEnabled: gridEnabled),
                                  ),
                                );
                              },
                              onChanged: (value) {
                                setSheetState(() {
                                  gridEnabled = value;
                                });

                                setState(() {
                                  _gridEnabled = value;
                                });
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
    final colorScheme = Theme.of(context).colorScheme;

    final compact = widget.metrics.isCompact;

    return Padding(
      padding: EdgeInsets.only(bottom: compact ? 8 : 12),
      child: Material(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(compact ? 12 : 14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(compact ? 12 : 14),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 14 : 18,
              vertical: compact ? 12 : 16,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: colorScheme.onSurface,
                  size: compact ? 20 : 22,
                ),

                SizedBox(width: compact ? 10 : 14),

                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: compact ? 14 : 15,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),

                Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: compact ? 20 : 22,
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
    final colorScheme = Theme.of(context).colorScheme;

    final compact = widget.metrics.isCompact;

    final radius = BorderRadius.circular(compact ? 12 : 14);

    return Padding(
      padding: EdgeInsets.only(bottom: compact ? 8 : 12),
      child: Material(
        color: colorScheme.surfaceContainer,
        borderRadius: radius,
        child: InkWell(
          onTap: onEdit,
          borderRadius: radius,
          splashColor: colorScheme.primary.withValues(alpha: 0.10),
          highlightColor: colorScheme.primary.withValues(alpha: 0.06),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 14 : 18,
              vertical: compact ? 8 : 10,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: colorScheme.onSurface,
                  size: compact ? 20 : 22,
                ),

                SizedBox(width: compact ? 10 : 14),

                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: compact ? 14 : 15,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),

                TextButton(
                  onPressed: onEdit,
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: compact ? 12 : 13,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                ),

                SizedBox(width: compact ? 4 : 8),

                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    onChanged(!value);
                  },
                  child: SizedBox(
                    width: compact ? 42 : 46,
                    height: 36,
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: compact ? 38 : 42,
                        height: 24,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: value
                              ? colorScheme.primary
                              : colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 180),
                          alignment: value
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: colorScheme.onPrimary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
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
