import 'package:flutter/material.dart';

/// Centralized responsive sizing for the editor.
///
/// The editor uses available width rather than device names.
/// This works across:
/// - Small landscape phones
/// - Normal phones
/// - Tablets
/// - Desktop / resizable windows
class EditorResponsive {
  const EditorResponsive._();

  /// Returns responsive values based on the space actually
  /// available to the editor.
  static EditorResponsiveData of(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return forSize(width: size.width, height: size.height);
  }

  static EditorResponsiveData forSize({
    required double width,
    required double height,
  }) {
    // ============================================================
    // VERY SMALL LANDSCAPE PHONE
    // ============================================================

    if (width < 700) {
      return const EditorResponsiveData(
        screenType: EditorScreenType.small,

        topBarHeight: 48,
        bottomBarHeight: 74,

        horizontalInset: 8,
        panelGap: 6,

        leftPanelWidth: 60,
        rightPanelWidth: 190,

        panelPadding: 6,

        toolButtonHeight: 48,
        toolIconSize: 19,
        toolLabelSize: 7.5,

        rightPanelTitleSize: 14,
        rightPanelPadding: 10,

        canvasPadding: 8,

        topActionWidth: 38,
        topActionIconSize: 18,
        topActionLabelSize: 7,
      );
    }

    // ============================================================
    // COMPACT PHONE / SMALL TABLET
    // ============================================================

    if (width < 1000) {
      return const EditorResponsiveData(
        screenType: EditorScreenType.compact,

        topBarHeight: 52,
        bottomBarHeight: 80,

        horizontalInset: 10,
        panelGap: 8,

        leftPanelWidth: 66,
        rightPanelWidth: 210,

        panelPadding: 7,

        toolButtonHeight: 52,
        toolIconSize: 20,
        toolLabelSize: 8,

        rightPanelTitleSize: 15,
        rightPanelPadding: 12,

        canvasPadding: 12,

        topActionWidth: 40,
        topActionIconSize: 19,
        topActionLabelSize: 8,
      );
    }

    // ============================================================
    // NORMAL TABLET / LARGE PHONE
    // ============================================================

    if (width < 1400) {
      return const EditorResponsiveData(
        screenType: EditorScreenType.normal,

        topBarHeight: 56,
        bottomBarHeight: 86,

        horizontalInset: 12,
        panelGap: 10,

        leftPanelWidth: 72,
        rightPanelWidth: 230,

        panelPadding: 8,

        toolButtonHeight: 56,
        toolIconSize: 21,
        toolLabelSize: 9,

        rightPanelTitleSize: 16,
        rightPanelPadding: 14,

        canvasPadding: 18,

        topActionWidth: 42,
        topActionIconSize: 20,
        topActionLabelSize: 8.5,
      );
    }

    // ============================================================
    // LARGE TABLET / DESKTOP
    // ============================================================

    return const EditorResponsiveData(
      screenType: EditorScreenType.wide,

      topBarHeight: 58,
      bottomBarHeight: 90,

      horizontalInset: 16,
      panelGap: 12,

      leftPanelWidth: 76,
      rightPanelWidth: 240,

      panelPadding: 10,

      toolButtonHeight: 58,
      toolIconSize: 22,
      toolLabelSize: 9,

      rightPanelTitleSize: 17,
      rightPanelPadding: 16,

      canvasPadding: 24,

      topActionWidth: 44,
      topActionIconSize: 20,
      topActionLabelSize: 9,
    );
  }
}

// ================================================================
// SCREEN TYPE
// ================================================================

enum EditorScreenType { small, compact, normal, wide }

// ================================================================
// RESPONSIVE DATA
// ================================================================

class EditorResponsiveData {
  const EditorResponsiveData({
    required this.screenType,

    required this.topBarHeight,
    required this.bottomBarHeight,

    required this.horizontalInset,
    required this.panelGap,

    required this.leftPanelWidth,
    required this.rightPanelWidth,

    required this.panelPadding,

    required this.toolButtonHeight,
    required this.toolIconSize,
    required this.toolLabelSize,

    required this.rightPanelTitleSize,
    required this.rightPanelPadding,

    required this.canvasPadding,

    required this.topActionWidth,
    required this.topActionIconSize,
    required this.topActionLabelSize,
  });

  // ============================================================
  // SCREEN
  // ============================================================

  final EditorScreenType screenType;

  // ============================================================
  // MAIN BARS
  // ============================================================

  final double topBarHeight;
  final double bottomBarHeight;

  // ============================================================
  // PANEL POSITIONING
  // ============================================================

  final double horizontalInset;
  final double panelGap;

  // ============================================================
  // PANEL WIDTHS
  // ============================================================

  final double leftPanelWidth;
  final double rightPanelWidth;

  // ============================================================
  // GENERAL PANEL PADDING
  // ============================================================

  final double panelPadding;

  // ============================================================
  // LEFT TOOLBAR
  // ============================================================

  final double toolButtonHeight;
  final double toolIconSize;
  final double toolLabelSize;

  // ============================================================
  // RIGHT PANEL
  // ============================================================

  final double rightPanelTitleSize;
  final double rightPanelPadding;

  // ============================================================
  // CANVAS
  // ============================================================

  final double canvasPadding;

  // ============================================================
  // TOP BAR ACTIONS
  // ============================================================

  final double topActionWidth;
  final double topActionIconSize;
  final double topActionLabelSize;

  // ============================================================
  // HELPERS
  // ============================================================

  bool get isSmall => screenType == EditorScreenType.small;

  bool get isCompact =>
      screenType == EditorScreenType.small ||
      screenType == EditorScreenType.compact;

  bool get isNormal => screenType == EditorScreenType.normal;

  bool get isWide => screenType == EditorScreenType.wide;
}
