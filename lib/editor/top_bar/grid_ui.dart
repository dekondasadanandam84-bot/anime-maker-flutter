import 'package:flutter/material.dart';

import 'package:flutter_application_1/goplus/go_plus_ui.dart';

class GridUI extends StatefulWidget {
  const GridUI({
    super.key,
    this.initialOpacity = 20,
    this.initialVerticalSpacing = 80,
    this.initialHorizontalSpacing = 80,
    this.initialEnabled = true,
    this.isGoPlusUser = false,
  });

  final int initialOpacity;
  final int initialVerticalSpacing;
  final int initialHorizontalSpacing;
  final bool initialEnabled;
  final bool isGoPlusUser;

  @override
  State<GridUI> createState() => _GridUIState();
}

class _GridUIState extends State<GridUI> {
  static const int _freeOpacity = 20;
  static const int _freeVerticalSpacing = 80;
  static const int _freeHorizontalSpacing = 80;

  static const int _minimumSpacing = 10;
  static const int _maximumSpacing = 100;

  late int _opacity;
  late int _verticalSpacing;
  late int _horizontalSpacing;
  late bool _enabled;

  @override
  void initState() {
    super.initState();

    if (widget.isGoPlusUser) {
      _opacity = widget.initialOpacity.clamp(0, 100);

      _verticalSpacing = widget.initialVerticalSpacing.clamp(
        _minimumSpacing,
        _maximumSpacing,
      );

      _horizontalSpacing = widget.initialHorizontalSpacing.clamp(
        _minimumSpacing,
        _maximumSpacing,
      );
    } else {
      _opacity = _freeOpacity;
      _verticalSpacing = _freeVerticalSpacing;
      _horizontalSpacing = _freeHorizontalSpacing;
    }

    _enabled = widget.initialEnabled;
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
            'Unlock Grid customization with Go Plus.',
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
  // OPACITY
  // ============================================================

  void _changeOpacity(double value) {
    if (!widget.isGoPlusUser) {
      _showGoPlusPopup();
      return;
    }

    setState(() {
      _opacity = value.round();
    });
  }

  // ============================================================
  // VERTICAL SPACING
  // ============================================================

  void _changeVerticalSpacing(double value) {
    if (!widget.isGoPlusUser) {
      _showGoPlusPopup();
      return;
    }

    setState(() {
      _verticalSpacing = value.round();
    });
  }

  // ============================================================
  // HORIZONTAL SPACING
  // ============================================================

  void _changeHorizontalSpacing(double value) {
    if (!widget.isGoPlusUser) {
      _showGoPlusPopup();
      return;
    }

    setState(() {
      _horizontalSpacing = value.round();
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
              'enabled': _enabled,
              'opacity': _opacity,
              'verticalSpacing': _verticalSpacing,
              'horizontalSpacing': _horizontalSpacing,
            });
          },
          tooltip: 'Close',
          icon: Icon(
            Icons.close_rounded,
            color: colorScheme.onSurface,
          ),
        ),

        title: Text(
          'Grid',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 16,
            ),
            child: Switch(
              value: _enabled,
              onChanged: (value) {
                setState(() {
                  _enabled = value;
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
              // GRID PREVIEW
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 320,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colorScheme.outlineVariant,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CustomPaint(
                    painter: _GridPreviewPainter(
                      enabled: _enabled,
                      opacity: _opacity / 100,
                      verticalSpacing: _verticalSpacing,
                      horizontalSpacing: _horizontalSpacing,
                      lineColor: colorScheme.onSurface,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ==================================================
              // OPACITY
              // ==================================================

              _GridSlider(
                title: 'Opacity',
                value: _opacity,
                min: 0,
                max: 100,
                suffix: '%',
                enabled: widget.isGoPlusUser,
                onChanged: _changeOpacity,
              ),

              const SizedBox(height: 30),

              // ==================================================
              // VERTICAL LINE SPACING
              // ==================================================

              _GridSlider(
                title: 'Vertical line spacing',
                value: _verticalSpacing,
                min: _minimumSpacing,
                max: _maximumSpacing,
                suffix: ' px',
                enabled: widget.isGoPlusUser,
                onChanged: _changeVerticalSpacing,
              ),

              const SizedBox(height: 30),

              // ==================================================
              // HORIZONTAL LINE SPACING
              // ==================================================

              _GridSlider(
                title: 'Horizontal line spacing',
                value: _horizontalSpacing,
                min: _minimumSpacing,
                max: _maximumSpacing,
                suffix: ' px',
                enabled: widget.isGoPlusUser,
                onChanged: _changeHorizontalSpacing,
              ),

              const SizedBox(height: 18),

              // ==================================================
              // FREE STATUS
              // ==================================================

              if (!widget.isGoPlusUser)
                Center(
                  child: Text(
                    'Free: 20% opacity • 80 px vertical • 80 px horizontal',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
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
// GRID SLIDER
// ============================================================================

class _GridSlider extends StatelessWidget {
  const _GridSlider({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.suffix,
    required this.enabled,
    required this.onChanged,
  });

  final String title;
  final int value;
  final int min;
  final int max;
  final String suffix;
  final bool enabled;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            Text(
              '$value$suffix',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: colorScheme.primary,
            inactiveTrackColor:
                colorScheme.surfaceContainerHighest,
            thumbColor: colorScheme.primary,
            overlayColor:
                colorScheme.primary.withValues(
              alpha: 0.12,
            ),
            disabledActiveTrackColor:
                colorScheme.primary.withValues(
              alpha: 0.45,
            ),
            disabledInactiveTrackColor:
                colorScheme.surfaceContainerHighest,
            disabledThumbColor:
                colorScheme.primary.withValues(
              alpha: 0.65,
            ),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 9,
            ),
          ),
          child: Slider(
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: max - min,
            value: value.toDouble(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// GRID PREVIEW PAINTER
// ============================================================================

class _GridPreviewPainter extends CustomPainter {
  const _GridPreviewPainter({
    required this.enabled,
    required this.opacity,
    required this.verticalSpacing,
    required this.horizontalSpacing,
    required this.lineColor,
  });

  final bool enabled;
  final double opacity;
  final int verticalSpacing;
  final int horizontalSpacing;
  final Color lineColor;

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    if (!enabled) {
      return;
    }

    final paint = Paint()
      ..color = lineColor.withValues(
        alpha: opacity.clamp(
          0.0,
          1.0,
        ),
      )
      ..strokeWidth = 1;

    // ==========================================================
    // VERTICAL LINES
    // ==========================================================

    for (
      double x = 0;
      x <= size.width;
      x += verticalSpacing
    ) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // ==========================================================
    // HORIZONTAL LINES
    // ==========================================================

    for (
      double y = 0;
      y <= size.height;
      y += horizontalSpacing
    ) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _GridPreviewPainter oldDelegate,
  ) {
    return oldDelegate.enabled != enabled ||
        oldDelegate.opacity != opacity ||
        oldDelegate.verticalSpacing != verticalSpacing ||
        oldDelegate.horizontalSpacing != horizontalSpacing ||
        oldDelegate.lineColor != lineColor;
  }
}