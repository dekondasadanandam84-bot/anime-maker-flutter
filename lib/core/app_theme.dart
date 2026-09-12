import 'package:flutter/material.dart';

enum AppThemeMode {
  light,
  dark,
}

enum AppAccentColor {
  black,
  indigo,
  teal,
  green,
  amber,
  orange,
  deepOrange,
}

extension AppAccentColorX on AppAccentColor {
  String get label {
    switch (this) {
      case AppAccentColor.black:
        return 'Black';
      case AppAccentColor.indigo:
        return 'Indigo';
      case AppAccentColor.teal:
        return 'Teal';
      case AppAccentColor.green:
        return 'Green';
      case AppAccentColor.amber:
        return 'Amber';
      case AppAccentColor.orange:
        return 'Orange';
      case AppAccentColor.deepOrange:
        return 'Deep Orange';
    }
  }

  Color get color {
    switch (this) {
      case AppAccentColor.black:
        return Colors.black;
      case AppAccentColor.indigo:
        return const Color(0xff3F51B5);
      case AppAccentColor.teal:
        return const Color(0xff009688);
      case AppAccentColor.green:
        return const Color(0xff4CAF50);
      case AppAccentColor.amber:
        return const Color(0xffFFC107);
      case AppAccentColor.orange:
        return const Color(0xffFF9800);
      case AppAccentColor.deepOrange:
        return const Color(0xffFF5722);
    }
  }
}

class AppTheme {
  AppTheme._();

  static ThemeData build({
    required AppThemeMode mode,
    required AppAccentColor accentColor,
  }) {
    final brightness = mode == AppThemeMode.dark
        ? Brightness.dark
        : Brightness.light;

    final seedColor = accentColor.color;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,

      textTheme: TextTheme(
        displayLarge: TextStyle(color: colorScheme.onSurface),
        displayMedium: TextStyle(color: colorScheme.onSurface),
        displaySmall: TextStyle(color: colorScheme.onSurface),
        headlineLarge: TextStyle(color: colorScheme.onSurface),
        headlineMedium: TextStyle(color: colorScheme.onSurface),
        headlineSmall: TextStyle(color: colorScheme.onSurface),
        titleLarge: TextStyle(color: colorScheme.onSurface),
        titleMedium: TextStyle(color: colorScheme.onSurface),
        titleSmall: TextStyle(color: colorScheme.onSurface),
        bodyLarge: TextStyle(color: colorScheme.onSurface),
        bodyMedium: TextStyle(color: colorScheme.onSurface),
        bodySmall: TextStyle(color: colorScheme.onSurfaceVariant),
        labelLarge: TextStyle(color: colorScheme.onSurface),
        labelMedium: TextStyle(color: colorScheme.onSurface),
        labelSmall: TextStyle(color: colorScheme.onSurfaceVariant),
      ),

      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),

      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
      ),
    );
  }
}

class AppThemeController extends ChangeNotifier {
  AppThemeMode _mode = AppThemeMode.light;
  AppAccentColor _accentColor = AppAccentColor.black;

  AppThemeMode get mode => _mode;
  AppAccentColor get accentColor => _accentColor;

  bool get isDarkMode => _mode == AppThemeMode.dark;

  ThemeData get themeData => AppTheme.build(
        mode: _mode,
        accentColor: _accentColor,
      );

  void setMode(AppThemeMode mode) {
    if (_mode == mode) {
      return;
    }

    _mode = mode;
    notifyListeners();
  }

  void setAccentColor(AppAccentColor color) {
    if (_accentColor == color) {
      return;
    }

    _accentColor = color;
    notifyListeners();
  }
}

class AppThemeScope extends InheritedNotifier<AppThemeController> {
  const AppThemeScope({
    super.key,
    required AppThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppThemeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppThemeScope>();

    assert(
      scope != null,
      'AppThemeScope was not found above this context.',
    );

    return scope!.notifier!;
  }
}
