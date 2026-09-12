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
  State<FramesViewerUI> createState() => _FramesViewerUIState();
}

class _FramesViewerUIState extends State<FramesViewerUI> {
  bool _showFrameActions = false;

  BottomBarController get bottomBarController => widget.bottomBarController;
  FramesViewerController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () {
            _closeFrameActions();
            if (controller.selectionMode) controller.cancelSelection();
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface),
        ),
        centerTitle: true,
        title: Text(
          'Frames Viewer',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([bottomBarController, controller]),
          builder: (context, _) {
            return Column(
              children: [
                if (controller.selectionMode)
                  _SelectionHeader(
                    selectedCount: controller.selectedFrames.length,
                    onCancel: () {
                      controller.cancelSelection();
                      _closeFrameActions();
                    },
                    onSelectAll: controller.selectAll,
                  ),
                Expanded(
                  child: _FramesArea(
                    bottomBarController: bottomBarController,
                    controller: controller,
                    onAddFrames: widget.onAddFrames,
                    onFrameTap: _handleFrameTap,
                    onFrameLongPress: _handleFrameLongPress,
                  ),
                ),
                if (_showFrameActions && !controller.selectionMode)
                  _FrameActionsBar(
                    controller: controller,
                    bottomBarController: bottomBarController,
                    onClose: _closeFrameActions,
                  ),
                if (controller.selectionMode)
                  _SelectionActionsBar(
                    controller: controller,
                    bottomBarController: bottomBarController,
                    onClose: _closeSelection,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleFrameTap(int frame) {
    final showActions = controller.onFrameTap(frame);
    if (controller.selectionMode) {
      _closeFrameActions();
      return;
    }
    if (!showActions) {
      _closeFrameActions();
      return;
    }
    setState(() => _showFrameActions = true);
  }

  void _handleFrameLongPress(int frame) {
    _closeFrameActions();
    controller.onFrameLongPress(frame);
  }

  void _closeFrameActions() {
    if (_showFrameActions) setState(() => _showFrameActions = false);
  }

  void _closeSelection() {
    controller.cancelSelection();
    _closeFrameActions();
  }
}

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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          TextButton(onPressed: onCancel, child: const Text('Cancel')),
          Expanded(
            child: Center(
              child: Text(
                '$selectedCount selected',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          TextButton(onPressed: onSelectAll, child: const Text('Select All')),
        ],
      ),
    );
  }
}

class _FramesArea extends StatelessWidget {
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
      builder: (context, constraints) {
        const minCardWidth = 120.0;
        const cardHeight = 80.0;
        const spacing = 12.0;

        final availableWidth = constraints.maxWidth;
        int columns = ((availableWidth + spacing) /
                (minCardWidth + spacing))
            .floor();
        if (columns < 1) columns = 1;

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: minCardWidth / cardHeight,
          ),
          itemCount: bottomBarController.frames.length + 1,
          itemBuilder: (context, index) {
            if (index == bottomBarController.frames.length) {
              return _AddFrameCard(onTap: onAddFrames);
            }

            final frame = bottomBarController.frames[index];
            final selected = controller.selectionMode
                ? controller.isFrameSelected(frame)
                : bottomBarController.selectedFrame == frame;

            return _FrameCard(
              frameNumber: frame,
              selected: selected,
              selectionMode: controller.selectionMode,
              onTap: () => onFrameTap(frame),
              onLongPress: () => onFrameLongPress(frame),
            );
          },
        );
      },
    );
  }
}

class _FrameActionsBar extends StatelessWidget {
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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ActionButton(
                icon: Icons.vertical_align_top_rounded,
                label: 'Add Before',
                onTap: () {
                  controller.addBefore();
                  onClose();
                },
              ),
              _ActionButton(
                icon: Icons.vertical_align_bottom_rounded,
                label: 'Add After',
                onTap: () {
                  controller.addAfter();
                  onClose();
                },
              ),
              _ActionButton(
                icon: Icons.content_copy_outlined,
                label: 'Copy',
                onTap: () {
                  controller.copy();
                  onClose();
                },
              ),
              _ActionButton(
                icon: Icons.content_paste_outlined,
                label: 'Paste',
                onTap: bottomBarController.canPaste
                    ? () {
                        controller.paste();
                        onClose();
                      }
                    : null,
              ),
              _ActionButton(
                icon: Icons.copy_all_outlined,
                label: 'Duplicate',
                onTap: () {
                  controller.duplicate();
                  onClose();
                },
              ),
              _ActionButton(
                icon: Icons.backspace_outlined,
                label: 'Erase',
                onTap: bottomBarController.frameCount > 1
                    ? () {
                        controller.erase();
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

class _SelectionActionsBar extends StatelessWidget {
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
    final canDelete = controller.hasSelection &&
        bottomBarController.frameCount > 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Center(
          child: _DeleteActionButton(
            enabled: canDelete,
            onTap: canDelete
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

class _DeleteActionButton extends StatelessWidget {
  const _DeleteActionButton({
    required this.enabled,
    required this.onTap,
  });

  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 130,
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: enabled
                ? colorScheme.errorContainer
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: enabled
                  ? colorScheme.error
                  : colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.delete_outline,
                size: 20,
                color: enabled
                    ? colorScheme.onErrorContainer
                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
              ),
              const SizedBox(width: 7),
              Text(
                'Delete',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: enabled
                      ? colorScheme.onErrorContainer
                      : colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
    final colorScheme = Theme.of(context).colorScheme;
    final enabled = onTap != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 82,
            height: 58,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 19,
                  color: enabled
                      ? colorScheme.onSurface
                      : colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: enabled
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
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
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 120,
            height: 80,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selected
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
                width: selected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.08),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(color: colorScheme.surface),
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 22),
                    height: 21,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      '$frameNumber',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                if (selectionMode && selected)
                  Positioned(
                    left: 5,
                    top: 5,
                    child: Icon(
                      Icons.check_circle,
                      size: 19,
                      color: colorScheme.primary,
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

class _AddFrameCard extends StatelessWidget {
  const _AddFrameCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 120,
          height: 80,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Icon(
            Icons.add_rounded,
            size: 34,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
