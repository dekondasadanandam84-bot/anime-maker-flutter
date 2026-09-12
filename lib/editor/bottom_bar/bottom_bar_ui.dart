import 'package:flutter/material.dart';

import '../editor_responsive.dart';
import 'bottom_bar_controller.dart';

class BottomBarUI extends StatefulWidget {
  const BottomBarUI({
    super.key,
    required this.controller,
    required this.onPreviousFrame,
    required this.onPlayPause,
    required this.onNextFrame,
    required this.controlsHidden,
    required this.metrics,
  });

  final BottomBarController controller;
  final VoidCallback onPreviousFrame;
  final VoidCallback onPlayPause;
  final VoidCallback onNextFrame;
  final bool controlsHidden;
  final EditorResponsiveData metrics;

  @override
  State<BottomBarUI> createState() => _BottomBarUIState();
}

class _BottomBarUIState extends State<BottomBarUI> {
  bool _showFrameActions = false;

  BottomBarController get controller => widget.controller;
  EditorResponsiveData get metrics => widget.metrics;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return SizedBox(
          width: double.infinity,
          height: metrics.bottomBarHeight,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              metrics.isSmall ? 6 : 12,
              metrics.isSmall ? 5 : 8,
              metrics.isSmall ? 6 : 12,
              metrics.isSmall ? 5 : 8,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _PlaybackGroup(
                  isPlaying: controller.isPlaying,
                  onPreviousFrame: widget.onPreviousFrame,
                  onPlayPause: widget.onPlayPause,
                  onNextFrame: widget.onNextFrame,
                  metrics: metrics,
                ),
                SizedBox(
                  width: metrics.isSmall
                      ? 6
                      : metrics.isCompact
                          ? 8
                          : 10,
                ),
                Expanded(
                  child: _showFrameActions
                      ? _FloatingFrameActionsToolbar(
                          onAddBefore: _addBefore,
                          onAddAfter: _addAfter,
                          onCopy: _copy,
                          onPaste: controller.canPaste ? _paste : null,
                          onDuplicate: _duplicate,
                          onErase: controller.frameCount > 1 ? _erase : null,
                          metrics: metrics,
                        )
                      : _FloatingFrameStrip(
                          controller: controller,
                          onAddFrames: () => _showAddFramesSheet(context),
                          onFrameTap: _handleFrameTap,
                          metrics: metrics,
                        ),
                ),
                SizedBox(
                  width: metrics.isSmall
                      ? 6
                      : metrics.isCompact
                          ? 8
                          : 10,
                ),
                _LayersButton(onTap: () {}, metrics: metrics),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleFrameTap(int frame) {
    final showActions = controller.handleFrameTap(frame);
    if (!showActions) {
      if (_showFrameActions) setState(() => _showFrameActions = false);
      return;
    }
    setState(() => _showFrameActions = true);
  }

  void _closeFrameActions() {
    if (_showFrameActions) setState(() => _showFrameActions = false);
  }

  void _addBefore() {
    controller.addFrameBefore();
    _closeFrameActions();
  }

  void _addAfter() {
    controller.addFrameAfter();
    _closeFrameActions();
  }

  void _copy() {
    controller.copyFrames(<int>[controller.selectedFrame]);
    _closeFrameActions();
  }

  void _paste() {
    if (!controller.canPaste) return;
    controller.pasteFrames();
    _closeFrameActions();
  }

  void _duplicate() {
    controller.duplicateFrames(<int>[controller.selectedFrame]);
    _closeFrameActions();
  }

  void _erase() {
    if (controller.frameCount <= 1) return;
    controller.eraseFrames(<int>[controller.selectedFrame]);
    _closeFrameActions();
  }

  void _showAddFramesSheet(BuildContext context) {
    showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddFramesSheet(),
    ).then((count) {
      if (count != null) controller.addFrames(count);
    });
  }
}

class _FloatingFrameStrip extends StatelessWidget {
  const _FloatingFrameStrip({
    required this.controller,
    required this.onAddFrames,
    required this.onFrameTap,
    required this.metrics,
  });

  final BottomBarController controller;
  final VoidCallback onAddFrames;
  final ValueChanged<int> onFrameTap;
  final EditorResponsiveData metrics;

  @override
  Widget build(BuildContext context) {
    final frameHeight = metrics.isSmall
        ? 52.0
        : metrics.isCompact
            ? 56.0
            : 62.0;

    return SizedBox(
      height: frameHeight,
      width: double.infinity,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.frames.length + 1,
        separatorBuilder: (_, _) => SizedBox(
          width: metrics.isSmall ? 4 : metrics.isCompact ? 5 : 6,
        ),
        itemBuilder: (context, index) {
          if (index == controller.frames.length) {
            return _AddFrameCard(onTap: onAddFrames, metrics: metrics);
          }
          final frame = controller.frames[index];
          return _FrameCard(
            frameNumber: frame,
            selected: controller.selectedFrame == frame,
            onTap: () => onFrameTap(frame),
            metrics: metrics,
          );
        },
      ),
    );
  }
}

class _FloatingFrameActionsToolbar extends StatelessWidget {
  const _FloatingFrameActionsToolbar({
    required this.onAddBefore,
    required this.onAddAfter,
    required this.onCopy,
    required this.onPaste,
    required this.onDuplicate,
    required this.onErase,
    required this.metrics,
  });

  final VoidCallback onAddBefore;
  final VoidCallback onAddAfter;
  final VoidCallback onCopy;
  final VoidCallback? onPaste;
  final VoidCallback onDuplicate;
  final VoidCallback? onErase;
  final EditorResponsiveData metrics;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: metrics.isSmall ? 54 : metrics.isCompact ? 58 : 64,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: metrics.isSmall ? 2 : 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(metrics.isSmall ? 11 : 14),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _FloatingFrameAction(icon: Icons.vertical_align_top_rounded, label: 'Add Before', onTap: onAddBefore, metrics: metrics),
              _FloatingFrameAction(icon: Icons.vertical_align_bottom_rounded, label: 'Add After', onTap: onAddAfter, metrics: metrics),
              _FloatingFrameAction(icon: Icons.content_copy_outlined, label: 'Copy', onTap: onCopy, metrics: metrics),
              _FloatingFrameAction(icon: Icons.content_paste_outlined, label: 'Paste', onTap: onPaste, metrics: metrics),
              _FloatingFrameAction(icon: Icons.copy_all_outlined, label: 'Duplicate', onTap: onDuplicate, metrics: metrics),
              _FloatingFrameAction(icon: Icons.backspace_outlined, label: 'Erase', onTap: onErase, metrics: metrics),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingFrameAction extends StatelessWidget {
  const _FloatingFrameAction({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.metrics,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final EditorResponsiveData metrics;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final enabled = onTap != null;
    final width = metrics.isSmall ? 58.0 : metrics.isCompact ? 70.0 : 82.0;
    final height = metrics.isSmall ? 50.0 : metrics.isCompact ? 54.0 : 58.0;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: metrics.isSmall ? 16 : 18,
                color: enabled
                    ? colorScheme.onSurface
                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
              ),
              if (!metrics.isSmall) ...[
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: metrics.isCompact ? 8 : 9,
                    fontWeight: FontWeight.w600,
                    color: enabled
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FrameCard extends StatelessWidget {
  const _FrameCard({
    required this.frameNumber,
    required this.selected,
    required this.onTap,
    required this.metrics,
  });

  final int frameNumber;
  final bool selected;
  final VoidCallback onTap;
  final EditorResponsiveData metrics;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final width = metrics.isSmall ? 58.0 : metrics.isCompact ? 65.0 : 72.0;
    final height = metrics.isSmall ? 52.0 : metrics.isCompact ? 57.0 : 62.0;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(metrics.isSmall ? 8 : 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(metrics.isSmall ? 8 : 10),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(metrics.isSmall ? 8 : 10),
            border: Border.all(
              color: selected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: selected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.all(metrics.isSmall ? 2 : 3),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(metrics.isSmall ? 6 : 7),
                    child: Container(color: colorScheme.surface),
                  ),
                ),
              ),
              Positioned(
                top: metrics.isSmall ? 3 : 4,
                right: metrics.isSmall ? 3 : 4,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 18),
                  height: metrics.isSmall ? 18 : 20,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(metrics.isSmall ? 4 : 5),
                  ),
                  child: Text(
                    '$frameNumber',
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: metrics.isSmall ? 8 : 9,
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

class _AddFrameCard extends StatelessWidget {
  const _AddFrameCard({required this.onTap, required this.metrics});

  final VoidCallback onTap;
  final EditorResponsiveData metrics;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = metrics.isSmall ? 52.0 : metrics.isCompact ? 58.0 : 64.0;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(metrics.isSmall ? 8 : 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(metrics.isSmall ? 8 : 10),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(metrics.isSmall ? 8 : 10),
            border: Border.all(color: colorScheme.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            Icons.add_rounded,
            size: metrics.isSmall ? 24 : 30,
            color: colorScheme.primary,
          ),
        ),
      ),
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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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

class _PlaybackGroup extends StatelessWidget {
  const _PlaybackGroup({
    required this.isPlaying,
    required this.onPreviousFrame,
    required this.onPlayPause,
    required this.onNextFrame,
    required this.metrics,
  });

  final bool isPlaying;
  final VoidCallback onPreviousFrame;
  final VoidCallback onPlayPause;
  final VoidCallback onNextFrame;
  final EditorResponsiveData metrics;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final height = metrics.isSmall ? 46.0 : metrics.isCompact ? 50.0 : 54.0;

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(metrics.isSmall ? 11 : 14),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PlaybackButton(icon: Icons.skip_previous_rounded, onTap: onPreviousFrame, metrics: metrics),
          _PlaybackButton(
            icon: isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            onTap: onPlayPause,
            metrics: metrics,
          ),
          _PlaybackButton(icon: Icons.skip_next_rounded, onTap: onNextFrame, metrics: metrics),
        ],
      ),
    );
  }
}

class _PlaybackButton extends StatelessWidget {
  const _PlaybackButton({required this.icon, required this.onTap, required this.metrics});

  final IconData icon;
  final VoidCallback onTap;
  final EditorResponsiveData metrics;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final width = metrics.isSmall ? 32.0 : metrics.isCompact ? 35.0 : 38.0;
    final height = metrics.isSmall ? 38.0 : metrics.isCompact ? 42.0 : 46.0;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: width,
          height: height,
          child: Icon(
            icon,
            size: metrics.isSmall ? 18 : 20,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _LayersButton extends StatelessWidget {
  const _LayersButton({required this.onTap, required this.metrics});

  final VoidCallback onTap;
  final EditorResponsiveData metrics;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = metrics.isSmall ? 46.0 : metrics.isCompact ? 50.0 : 54.0;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(metrics.isSmall ? 11 : 14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(metrics.isSmall ? 11 : 14),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(metrics.isSmall ? 11 : 14),
            border: Border.all(color: colorScheme.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.layers_outlined,
            size: metrics.isSmall ? 20 : 22,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
