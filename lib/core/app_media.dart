import 'package:flutter/material.dart';

class AppMedia {
  AppMedia._();

  static late MediaQueryData _media;

  /// Call once inside every screen's build() method.
  static void init(BuildContext context) {
    _media = MediaQuery.of(context);
  }

  // Screen Size
  static double get width => _media.size.width;
  static double get height => _media.size.height;

  // Orientation
  static Orientation get orientation => _media.orientation;
  static bool get isPortrait => orientation == Orientation.portrait;
  static bool get isLandscape => orientation == Orientation.landscape;

  // Device Type
  static bool get isMobile => width < 600;
  static bool get isTablet => width >= 600 && width < 1024;
  static bool get isDesktop => width >= 1024;

  // Responsive Width (Based on 390px design width)
  static double w(double value) {
    return value * (width / 390);
  }

  // Responsive Height (Based on 844px design height)
  static double h(double value) {
    return value * (height / 844);
  }

  // Responsive Font Size
  static double sp(double value) {
    final scale = width / 390;
    return value * scale;
  }

  // Responsive Radius
  static double r(double value) {
    final scale = width / 390;
    return value * scale;
  }

  // Responsive Icon Size
  static double icon(double value) {
    final scale = width / 390;
    return value * scale;
  }

  // Safe Area
  static double get top => _media.padding.top;
  static double get bottom => _media.padding.bottom;
  static double get left => _media.padding.left;
  static double get right => _media.padding.right;

  // Screen Percentage
  static double percentWidth(double percent) {
    return width * percent;
  }

  static double percentHeight(double percent) {
    return height * percent;
  }

  // Responsive EdgeInsets
  static EdgeInsets all(double value) {
    return EdgeInsets.all(w(value));
  }

  static EdgeInsets symmetric({
    double horizontal = 0,
    double vertical = 0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: w(horizontal),
      vertical: h(vertical),
    );
  }

  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: w(left),
      top: h(top),
      right: w(right),
      bottom: h(bottom),
    );
  }

  // Responsive SizedBox
  static SizedBox gapH(double value) {
    return SizedBox(height: h(value));
  }

  static SizedBox gapW(double value) {
    return SizedBox(width: w(value));
  }
}