import 'package:flutter/material.dart';

class EditorTopBar extends StatefulWidget {
  const EditorTopBar({
    super.key,
    required this.projectName,
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

  final String projectName;

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
  bool _panelsHidden = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEAEAEA), width: 1)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Left side
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Back
                IconButton(
                  onPressed: widget.onBack,
                  tooltip: 'Back',
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.black,
                  ),
                ),

                // Project name
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 260),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.projectName,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Fit to screen - exact middle
          _customTopBarAction(
            icon: const _FitScreenIcon(),
            label: 'Fit',
            onPressed: widget.onFitToScreen,
            tooltip: 'Fit to Screen',
          ),

          // Right side
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _topBarAction(
                  icon: _panelsHidden
                      ? Icons.fit_screen_outlined
                      : Icons.fit_screen,
                  label: _panelsHidden ? 'Hide' : 'Show',
                  onPressed: () {
                    setState(() {
                      _panelsHidden = !_panelsHidden;
                    });

                    widget.onHidePanels();
                  },
                  tooltip: _panelsHidden ? 'Show' : 'Hide',
                ),

                // Undo
                _topBarAction(
                  icon: Icons.undo_rounded,
                  label: 'Undo',
                  onPressed: widget.onUndo,
                  tooltip: 'Undo',
                ),

                // Redo
                _topBarAction(
                  icon: Icons.redo_rounded,
                  label: 'Redo',
                  onPressed: widget.onRedo,
                  tooltip: 'Redo',
                ),

                // Copy
                _topBarAction(
                  icon: Icons.content_copy_outlined,
                  label: 'Copy',
                  onPressed: widget.onCopy,
                  tooltip: 'Copy',
                ),

                // Paste
                _topBarAction(
                  icon: Icons.content_paste_outlined,
                  label: 'Paste',
                  onPressed: widget.onPaste,
                  tooltip: 'Paste',
                ),

                // Duplicate
                _topBarAction(
                  icon: Icons.control_point_duplicate_outlined,
                  label: 'Duplicate',
                  onPressed: widget.onDuplicate,
                  tooltip: 'Duplicate',
                ),

                // Audio
                _topBarAction(
                  icon: Icons.volume_up_outlined,
                  label: 'Audio',
                  onPressed: widget.onAudio,
                  tooltip: 'Audio',
                ),

                // Diamond
                _topBarAction(
                  icon: Icons.diamond_outlined,
                  label: 'Diamond',
                  onPressed: widget.onDiamond,
                  tooltip: 'Diamond',
                ),

                // Three dots
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
        ],
      ),
    );
  }

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
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          splashColor: Colors.blue.withValues(alpha: 0.18),
          highlightColor: Colors.blue.withValues(alpha: 0.10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  void _showToolsBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        bool onionSkinEnabled = _onionSkinEnabled;
        bool gridEnabled = _gridEnabled;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: double.infinity,
              child: Material(
                color: Colors.white,
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 64,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              tooltip: 'Close',
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Tools',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Divider(height: 1, color: Color(0xFFEAEAEA)),

                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(20),
                          children: [
                            _toolAction(
                              icon: Icons.settings_outlined,
                              title: 'Project Settings',
                              onTap: () {
                                Navigator.of(context).pop();

                                // Open project settings here.
                                // Example:
                                // widget.onProjectSettings();
                              },
                            ),

                            // Frames Viewer
                            _toolAction(
                              icon: Icons.movie_outlined,
                              title: 'Frames Viewer',
                              onTap: () {
                                Navigator.of(context).pop();

                                // Open frames viewer here.
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

                            _toolToggle(
                              icon: Icons.layers_outlined,
                              title: 'Onion Skin',
                              value: onionSkinEnabled,
                              onEdit: () {},
                              onChanged: (value) {
                                setSheetState(() {
                                  onionSkinEnabled = value;
                                });

                                setState(() {
                                  _onionSkinEnabled = value;
                                });
                              },
                            ),

                            _toolToggle(
                              icon: Icons.grid_on_outlined,
                              title: 'Grid',
                              value: gridEnabled,
                              onEdit: () {},
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

  Widget _toolAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Icon(icon, color: Colors.black, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.black54),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _toolToggle({
    required IconData icon,
    required String title,
    required bool value,
    required VoidCallback onEdit,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),

            // Edit
            TextButton(
              onPressed: onEdit,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Edit',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Tap-only toggle
            GestureDetector(
              onTap: () {
                onChanged(!value);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 42,
                height: 24,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: value ? Colors.black : const Color(0xFFD6D6D6),
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
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

  Widget _customTopBarAction({
  required Widget icon,
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
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          splashColor: Colors.blue.withValues(alpha: 0.18),
          highlightColor: Colors.blue.withValues(alpha: 0.10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Center(
                  child: icon,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
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

class _FitScreenIcon extends StatelessWidget {
  const _FitScreenIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _FitScreenIconPainter(),
    );
  }
}

class _FitScreenIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Top-left corner
    canvas.drawLine(const Offset(6, 4), const Offset(4, 4), paint);
    canvas.drawLine(const Offset(4, 4), const Offset(4, 6), paint);

    // Top-right corner
    canvas.drawLine(const Offset(18, 4), const Offset(20, 4), paint);
    canvas.drawLine(const Offset(20, 4), const Offset(20, 6), paint);

    // Bottom-left corner
    canvas.drawLine(const Offset(4, 18), const Offset(4, 20), paint);
    canvas.drawLine(const Offset(4, 20), const Offset(6, 20), paint);

    // Bottom-right corner
    canvas.drawLine(const Offset(18, 20), const Offset(20, 20), paint);
    canvas.drawLine(const Offset(20, 18), const Offset(20, 20), paint);

    // ↗ arrow
    canvas.drawLine(const Offset(7, 17), const Offset(17, 7), paint);
    canvas.drawLine(const Offset(17, 7), const Offset(13, 7), paint);
    canvas.drawLine(const Offset(17, 7), const Offset(17, 11), paint);

    // ↙ arrow
    canvas.drawLine(const Offset(17, 17), const Offset(7, 7), paint);
    canvas.drawLine(const Offset(7, 17), const Offset(7, 13), paint);
    canvas.drawLine(const Offset(7, 17), const Offset(11, 17), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
