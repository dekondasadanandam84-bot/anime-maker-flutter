import 'package:flutter/material.dart';
import 'package:flutter_application_1/editor/left_panel/left_panel_controller.dart';

class RightPanelUI extends StatefulWidget {
  const RightPanelUI({
    super.key,
    required this.tool,
  });

  final int tool;

  @override
  State<RightPanelUI> createState() => _RightPanelUIState();
}

class _RightPanelUIState extends State<RightPanelUI> {
  double _size = 20;
  double _opacity = 1.0;
  double _fade = 0.5;
  double _alpha = 1.0;

  static const double _visibleSettingsHeight = 220;

  @override
  Widget build(BuildContext context) {
    final bool isEraser =
        widget.tool == LeftPanelController.eraser;

    final bool isFont =
        widget.tool == LeftPanelController.font;

    return Container(
      width: 230,
      padding: const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFEAEAEA),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================================================
          // TITLE
          // =========================================================
          Center(
            child: Text(
              isEraser
                  ? 'Eraser'
                  : isFont
                      ? 'Font'
                      : 'Brush',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // =========================================================
          // SETTINGS AREA
          // ONLY THREE OPTIONS VISIBLE
          // =========================================================
          SizedBox(
            height: _visibleSettingsHeight,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =================================================
                  // ERASER
                  // =================================================
                  if (isEraser) ...[
                    _SettingSlider(
                      label: 'Size',
                      value: _size,
                      min: 1,
                      max: 100,
                      valueText: _size.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          _size = value;
                        });
                      },
                    ),

                    const SizedBox(height: 14),

                    _SettingSlider(
                      label: 'Fade',
                      value: _fade,
                      min: 0,
                      max: 1,
                      valueText:
                          '${(_fade * 100).round()}%',
                      onChanged: (value) {
                        setState(() {
                          _fade = value;
                        });
                      },
                    ),

                    const SizedBox(height: 14),

                    _SettingSlider(
                      label: 'Alpha',
                      value: _alpha,
                      min: 0,
                      max: 1,
                      valueText:
                          '${(_alpha * 100).round()}%',
                      onChanged: (value) {
                        setState(() {
                          _alpha = value;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    _PanelButton(
                      icon: Icons.straighten_outlined,
                      title: 'Ruler',
                      onTap: () {},
                    ),
                  ]

                  // =================================================
                  // FONT
                  // =================================================
                  else if (isFont) ...[
                    _PanelButton(
                      icon: Icons.add_rounded,
                      title: 'Add Text',
                      onTap: () {},
                    ),

                    const SizedBox(height: 10),

                    _PanelButton(
                      icon: Icons.font_download_outlined,
                      title: 'Font',
                      onTap: () {},
                    ),

                    const SizedBox(height: 14),

                    _SettingSlider(
                      label: 'Size',
                      value: _size,
                      min: 8,
                      max: 200,
                      valueText:
                          _size.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          _size = value;
                        });
                      },
                    ),

                    const SizedBox(height: 14),

                    _SettingSlider(
                      label: 'Opacity',
                      value: _opacity,
                      min: 0,
                      max: 1,
                      valueText:
                          '${(_opacity * 100).round()}%',
                      onChanged: (value) {
                        setState(() {
                          _opacity = value;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    _PanelButton(
                      icon: Icons.palette_outlined,
                      title: 'Colour',
                      onTap: () {},
                    ),
                  ]

                  // =================================================
                  // BRUSH
                  // =================================================
                  else ...[
                    _SettingSlider(
                      label: 'Size',
                      value: _size,
                      min: 1,
                      max: 100,
                      valueText:
                          _size.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          _size = value;
                        });
                      },
                    ),

                    const SizedBox(height: 14),

                    _SettingSlider(
                      label: 'Opacity',
                      value: _opacity,
                      min: 0,
                      max: 1,
                      valueText:
                          '${(_opacity * 100).round()}%',
                      onChanged: (value) {
                        setState(() {
                          _opacity = value;
                        });
                      },
                    ),

                    const SizedBox(height: 14),

                    _SettingSlider(
                      label: 'Hardness',
                      value: _fade,
                      min: 0,
                      max: 1,
                      valueText:
                          '${(_fade * 100).round()}%',
                      onChanged: (value) {
                        setState(() {
                          _fade = value;
                        });
                      },
                    ),

                    const SizedBox(height: 4),

                    _PanelButton(
                      icon: Icons.brush_outlined,
                      title: 'Brush Type',
                      onTap: () {},
                    ),

                    const SizedBox(height: 10),

                    _PanelButton(
                      icon: Icons.palette_outlined,
                      title: 'Colour',
                      onTap: () {},
                    ),

                    const SizedBox(height: 10),

                    _PanelButton(
                      icon: Icons.straighten_outlined,
                      title: 'Ruler',
                      onTap: () {},
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingSlider extends StatelessWidget {
  const _SettingSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.valueText,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final String valueText;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              valueText,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
          activeColor: Colors.blue,
          inactiveColor:
              const Color(0xFFDCDCDC),
        ),
      ],
    );
  }
}

class _PanelButton extends StatelessWidget {
  const _PanelButton({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF7F7F7),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(
                icon,
                size: 21,
                color: Colors.black87,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Colors.black54,
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}