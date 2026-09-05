import 'package:flutter/material.dart';

import 'package:flutter_application_1/editor/editor_responsive.dart';
import 'package:flutter_application_1/editor/left_panel/left_panel_controller.dart';

class RightPanelUI extends StatefulWidget {
const RightPanelUI({
super.key,
required this.tool,
required this.metrics,
});

final int tool;
final EditorResponsiveData metrics;

@override
State<RightPanelUI> createState() =>
_RightPanelUIState();
}

class _RightPanelUIState extends State<RightPanelUI> {
double _size = 20;
double _opacity = 1.0;
double _fade = 0.5;
double _alpha = 1.0;

// ============================================================
// BUILD
// ============================================================

@override
Widget build(BuildContext context) {
final bool isEraser =
widget.tool == LeftPanelController.eraser;


final bool isFont =
    widget.tool == LeftPanelController.font;

final metrics = widget.metrics;

return Container(
  width: metrics.rightPanelWidth,
  padding: EdgeInsets.fromLTRB(
    metrics.rightPanelPadding,
    metrics.rightPanelPadding,
    metrics.rightPanelPadding,
    metrics.rightPanelPadding,
  ),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(
      metrics.isSmall ? 14 : 18,
    ),
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
    crossAxisAlignment:
        CrossAxisAlignment.start,
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
          style: TextStyle(
            fontSize:
                metrics.rightPanelTitleSize,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),

      SizedBox(
        height: metrics.isSmall ? 8 : 12,
      ),

      // =========================================================
      // SETTINGS AREA
      // =========================================================

      SizedBox(
        height: _visibleSettingsHeight,
        child: SingleChildScrollView(
          physics:
              const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
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
                  valueText:
                      _size.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      _size = value;
                    });
                  },
                  metrics: metrics,
                ),

                _verticalSpacing(8),

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
                  metrics: metrics,
                ),

                _verticalSpacing(8),

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
                  metrics: metrics,
                ),

                _verticalSpacing(6),

                _PanelButton(
                  icon:
                      Icons.straighten_outlined,
                  title: 'Ruler',
                  onTap: () {},
                  metrics: metrics,
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
                  metrics: metrics,
                ),

                _verticalSpacing(6),

                _PanelButton(
                  icon:
                      Icons.font_download_outlined,
                  title: 'Font',
                  onTap: () {},
                  metrics: metrics,
                ),

                _verticalSpacing(8),

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
                  metrics: metrics,
                ),

                _verticalSpacing(8),

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
                  metrics: metrics,
                ),

                _verticalSpacing(6),

                _PanelButton(
                  icon:
                      Icons.palette_outlined,
                  title: 'Colour',
                  onTap: () {},
                  metrics: metrics,
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
                  metrics: metrics,
                ),

                _verticalSpacing(8),

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
                  metrics: metrics,
                ),

                _verticalSpacing(8),

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
                  metrics: metrics,
                ),

                _verticalSpacing(4),

                _PanelButton(
                  icon:
                      Icons.brush_outlined,
                  title: 'Brush Type',
                  onTap: () {},
                  metrics: metrics,
                ),

                _verticalSpacing(6),

                _PanelButton(
                  icon:
                      Icons.palette_outlined,
                  title: 'Colour',
                  onTap: () {},
                  metrics: metrics,
                ),

                _verticalSpacing(6),

                _PanelButton(
                  icon:
                      Icons.straighten_outlined,
                  title: 'Ruler',
                  onTap: () {},
                  metrics: metrics,
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

// ============================================================
// RESPONSIVE SETTINGS HEIGHT
// ============================================================

double get _visibleSettingsHeight {
if (widget.metrics.isSmall) {
return 190;
}


if (widget.metrics.isCompact) {
  return 205;
}

return 220;


}

// ============================================================
// RESPONSIVE VERTICAL SPACING
// ============================================================

Widget _verticalSpacing(double normal) {
if (widget.metrics.isSmall) {
return SizedBox(height: normal * 0.65);
}


if (widget.metrics.isCompact) {
  return SizedBox(height: normal * 0.8);
}

return SizedBox(height: normal);


}
}

// ==================================================================
// SETTING SLIDER
// ==================================================================

class _SettingSlider extends StatelessWidget {
const _SettingSlider({
required this.label,
required this.value,
required this.min,
required this.max,
required this.valueText,
required this.onChanged,
required this.metrics,
});

final String label;
final double value;
final double min;
final double max;
final String valueText;
final ValueChanged<double> onChanged;
final EditorResponsiveData metrics;

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
Flexible(
child: Text(
label,
maxLines: 1,
overflow:
TextOverflow.ellipsis,
style: TextStyle(
fontSize:
metrics.isSmall ? 12 : 13,
fontWeight:
FontWeight.w600,
color:
Colors.black87,
),
),
),
const SizedBox(width: 8),
Text(
valueText,
style: TextStyle(
fontSize:
metrics.isSmall ? 11 : 12,
color:
Colors.black54,
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

// ==================================================================
// PANEL BUTTON
// ==================================================================

class _PanelButton extends StatelessWidget {
const _PanelButton({
required this.icon,
required this.title,
required this.onTap,
required this.metrics,
});

final IconData icon;
final String title;
final VoidCallback onTap;
final EditorResponsiveData metrics;

@override
Widget build(BuildContext context) {
final compact = metrics.isCompact;


return Material(
  color:
      const Color(0xFFF7F7F7),
  borderRadius:
      BorderRadius.circular(
    compact ? 10 : 12,
  ),
  child: InkWell(
    onTap: onTap,
    borderRadius:
        BorderRadius.circular(
      compact ? 10 : 12,
    ),
    child: SizedBox(
      width: double.infinity,
      height:
          compact ? 42 : 48,
      child: Row(
        children: [
          SizedBox(
            width:
                compact ? 10 : 14,
          ),

          Icon(
            icon,
            size:
                compact ? 19 : 21,
            color:
                Colors.black87,
          ),

          SizedBox(
            width:
                compact ? 8 : 12,
          ),

          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              style: TextStyle(
                fontSize:
                    compact ? 13 : 14,
                fontWeight:
                    FontWeight.w600,
                color:
                    Colors.black87,
              ),
            ),
          ),

          Icon(
            Icons.chevron_right_rounded,
            size:
                compact ? 18 : 20,
            color:
                Colors.black54,
          ),

          SizedBox(
            width:
                compact ? 7 : 10,
          ),
        ],
      ),
    ),
  ),
);


}
}
