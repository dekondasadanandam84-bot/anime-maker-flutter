import 'package:flutter/material.dart';

import 'package:flutter_application_1/goplus/go_plus_ui.dart';
import 'package:flutter_application_1/home/project_controller.dart';
import 'package:flutter_application_1/home/project_scope.dart';

class OnionSkinUI extends StatefulWidget {
  const OnionSkinUI({
    super.key,
    this.initialFramesBefore = 1,
    this.initialFramesAfter = 1,
    this.isGoPlusUser = false,
  });

  final int initialFramesBefore;
  final int initialFramesAfter;
  final bool isGoPlusUser;

  @override
  State<OnionSkinUI> createState() => _OnionSkinUIState();
}

class _OnionSkinUIState extends State<OnionSkinUI> {
  static const int _freeMaximumFrames = 5;
  static const int _fallbackFps = 12;

  late int _framesBefore;
  late int _framesAfter;

  bool _onionEnabled = true;

  ProjectController get projectController =>
      ProjectScope.of(context);

  // ============================================================
  // FPS
  // ============================================================

  double get fps {
    final value = projectController.currentFps ?? _fallbackFps;

    if (value <= 0) {
      return _fallbackFps.toDouble();
    }

    return value.toDouble();
  }

  int get maximumFrames => fps.round().clamp(1, 120);

  int get allowedMaximum =>
      widget.isGoPlusUser
          ? maximumFrames
          : _freeMaximumFrames.clamp(1, maximumFrames);

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _framesBefore = widget.initialFramesBefore.clamp(1, 120);
    _framesAfter = widget.initialFramesAfter.clamp(1, 120);
  }

  // ============================================================
  // FRAMES BEFORE
  // ============================================================

  void _changeFramesBefore(double value) {
    final selected = value.round();

    if (!widget.isGoPlusUser && selected > allowedMaximum) {
      _showGoPlusPopup();
      return;
    }

    setState(() {
      _framesBefore = selected.clamp(1, maximumFrames);
    });
  }

  // ============================================================
  // FRAMES AFTER
  // ============================================================

  void _changeFramesAfter(double value) {
    final selected = value.round();

    if (!widget.isGoPlusUser && selected > allowedMaximum) {
      _showGoPlusPopup();
      return;
    }

    setState(() {
      _framesAfter = selected.clamp(1, maximumFrames);
    });
  }

  // ============================================================
  // GO PLUS POPUP
  // ============================================================

  void _showGoPlusPopup() {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          title: Row(
            children: [
              Icon(
                Icons.diamond_outlined,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Go Plus',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Free users can use up to 5 frames before '
            'and 5 frames after. Go Plus unlocks up to '
            '$maximumFrames frames.',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const GoPlusUI(),
                  ),
                );
              },
              child: const Text('Upgrade'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final before = _framesBefore.clamp(1, maximumFrames);
    final after = _framesAfter.clamp(1, maximumFrames);

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // ==========================================================
      // APP BAR
      // ==========================================================

      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surface,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop({
              'framesBefore': before,
              'framesAfter': after,
              'enabled': _onionEnabled,
            });
          },
          tooltip: 'Close',
          icon: Icon(
            Icons.close_rounded,
            color: colorScheme.onSurface,
          ),
        ),

        title: Text(
          'Onion Skin',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Switch(
              value: _onionEnabled,
              onChanged: (value) {
                setState(() {
                  _onionEnabled = value;
                });
              },
            ),
          ),
        ],
      ),

      // ==========================================================
      // BODY
      // ==========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // IMAGE PREVIEW
              // ==================================================

              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 64,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ==================================================
              // FRAMES BEFORE
              // ==================================================

              _FrameSlider(
                title: 'Frames before',
                value: before,
                maximum: maximumFrames,
                allowedMaximum: allowedMaximum,
                onChanged: _changeFramesBefore,
              ),

              const SizedBox(height: 34),

              // ==================================================
              // FRAMES AFTER
              // ==================================================

              _FrameSlider(
                title: 'Frames after',
                value: after,
                maximum: maximumFrames,
                allowedMaximum: allowedMaximum,
                onChanged: _changeFramesAfter,
              ),

              const SizedBox(height: 28),

              // ==================================================
              // FPS MAXIMUM
              // ==================================================

              Center(
                child: Text(
                  'Maximum: $maximumFrames frames',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
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

// ============================================================================
// FRAME SLIDER
// ============================================================================

class _FrameSlider extends StatelessWidget {
  const _FrameSlider({
    required this.title,
    required this.value,
    required this.maximum,
    required this.allowedMaximum,
    required this.onChanged,
  });

  final String title;
  final int value;
  final int maximum;
  final int allowedMaximum;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: 10),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: colorScheme.primary,
                  inactiveTrackColor:
                      colorScheme.surfaceContainerHighest,
                  thumbColor: colorScheme.surface,
                  overlayColor:
                      colorScheme.primary.withValues(alpha: 0.12),
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 14,
                  ),
                ),
                child: Slider(
                  min: 1,
                  max: maximum.toDouble(),
                  divisions: maximum - 1,
                  value: value.clamp(1, maximum).toDouble(),
                  onChanged: onChanged,
                ),
              ),
            ),

            const SizedBox(width: 8),

            SizedBox(
              width: 38,
              child: Text(
                '$value',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 2),

        Text(
          '1–$allowedMaximum',
          style: TextStyle(
            fontSize: 11,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}