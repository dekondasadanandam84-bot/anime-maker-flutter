import 'package:flutter/material.dart';

import 'package:flutter_application_1/core/app_media.dart';
import 'package:flutter_application_1/core/app_theme.dart';
import 'package:flutter_application_1/goplus/go_plus_ui.dart';
import 'package:flutter_application_1/editor/touch_input/touch_input_controller.dart';

class SettingsUI extends StatefulWidget {
  const SettingsUI({super.key});

  @override
  State<SettingsUI> createState() => _SettingsUIState();
}

class _SettingsUIState extends State<SettingsUI> {
  InputMode inputMode = InputMode.stylus;

  final List<AppAccentColor> accentColors = [
    AppAccentColor.black,
    AppAccentColor.indigo,
    AppAccentColor.teal,
    AppAccentColor.green,
    AppAccentColor.amber,
    AppAccentColor.orange,
    AppAccentColor.deepOrange,
  ];

  @override
  Widget build(BuildContext context) {
    AppMedia.init(context);

    final themeController = AppThemeScope.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 48,
                width: double.infinity,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close_rounded,
                          color: colorScheme.onSurfaceVariant,
                          size: 26,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _proCard(),

              const SizedBox(height: 40),

              _sectionTitle(
                'Appearance',
                'Customize how AnimeClip looks on your device.',
              ),

              const SizedBox(height: 20),

              _themeSelector(themeController),

              const SizedBox(height: 25),

              Text(
                'ACCENT COLOR',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 16),

              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: accentColors.map((accent) {
                  return GestureDetector(
                    onTap: () {
                      themeController.setAccentColor(accent);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accent.color,
                        border: Border.all(
                          color: themeController.accentColor == accent
                              ? colorScheme.onSurface
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: themeController.accentColor == accent
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),

              _sectionTitle(
                'Input Methods',
                'Configure how you interact with the canvas.',
              ),

              const SizedBox(height: 20),

              _inputMethodsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _proCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.surfaceContainerHighest,
                  colorScheme.surfaceContainer,
                ],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.movie_creation_outlined,
                size: 70,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  'Unlock AnimeClip Pro',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Get unlimited cloud projects, cloud sync, and advanced export tools.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const GoPlusUI()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Upgrade Now',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _themeSelector(AppThemeController themeController) {
    return Row(
      children: [
        Expanded(
          child: _themeCard(
            title: 'Light',
            isSelected: themeController.mode == AppThemeMode.light,
            isDark: false,
            onTap: () {
              themeController.setMode(AppThemeMode.light);
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _themeCard(
            title: 'Dark',
            isSelected: themeController.mode == AppThemeMode.dark,
            isDark: true,
            onTap: () {
              themeController.setMode(AppThemeMode.dark);
            },
          ),
        ),
      ],
    );
  }

  Widget _themeCard({
    required String title,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 125,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xff1b1c1c) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: isSelected ? 2 : 1,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 8,
                  width: 60,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xff4c4546)
                        : const Color(0xffcfc4c5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 35,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xff2f3131) : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ],
                ),
                if (isSelected)
                  Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: colorScheme.primary,
                      child: Icon(
                        Icons.check,
                        color: colorScheme.onPrimary,
                        size: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputMethodsCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          _inputTile(
            icon: Icons.edit,
            title: 'Stylus',
            subtitle: 'Optimized pressure sensitivity and tilt support.',
            value: inputMode == InputMode.stylus,
            onChanged: () {
              setState(() {
                inputMode = InputMode.stylus;
              });
              TouchInputController.setGlobalInputMode(InputMode.stylus);
            },
          ),
          _divider(),
          _inputTile(
            icon: Icons.touch_app,
            title: 'Finger',
            subtitle: 'Enable touch gestures for canvas manipulation.',
            value: inputMode == InputMode.finger,
            onChanged: () {
              setState(() {
                inputMode = InputMode.finger;
              });
              TouchInputController.setGlobalInputMode(InputMode.finger);
            },
          ),
          _divider(),
          _inputTile(
            icon: Icons.devices,
            title: 'Both (Stylus & Finger)',
            subtitle:
                'Seamlessly switch between stylus precision and touch gestures.',
            value: inputMode == InputMode.both,
            onChanged: () {
              setState(() {
                inputMode = InputMode.both;
              });
              TouchInputController.setGlobalInputMode(InputMode.both);
            },
          ),
        ],
      ),
    );
  }

  Widget _inputTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required VoidCallback onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onChanged,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: colorScheme.onSurface),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: (_) {
                onChanged();
              },
              activeThumbColor: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}
