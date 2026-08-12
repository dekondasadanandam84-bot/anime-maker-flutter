import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/app_media.dart';

enum AppThemeMode {
  light,
  dark,
}

enum InputMode {
  stylus,
  finger,
  both,
}
class SettingsUI extends StatefulWidget {
  const SettingsUI({super.key});
 @override
  State<SettingsUI> createState() => _SettingsUIState();
}
class _SettingsUIState extends State<SettingsUI> {
  AppThemeMode themeMode = AppThemeMode.light;
  InputMode inputMode = InputMode.stylus;
  Color selectedAccent = Colors.black;
  final List<Color> accentColors = [
    Colors.black,
    const Color(0xff3F51B5),
    const Color(0xff009688),
    const Color(0xff4CAF50),
    const Color(0xffFFC107),
    const Color(0xffFF9800),
    const Color(0xffFF5722),
  ];
  @override
  Widget build(BuildContext context) {
 AppMedia.init(context);
    return Scaffold(
      backgroundColor: const Color(0xfff9f9f9),
      body: SafeArea(
  child: SingleChildScrollView(
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top bar — now part of the screen content
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
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                    size: 26,
                  ),
                ),
              ),

              const Center(
                child: Text(
                  "Settings",
                  style: TextStyle(
                    color: Color.fromARGB(255, 13, 113, 254),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Existing body content
        _proCard(),

        const SizedBox(height: 40),

        _sectionTitle(
          "Appearance",
          "Customize how AnimeClip looks on your device.",
        ),

        const SizedBox(height: 20),

        _themeSelector(),

        const SizedBox(height: 25),

        const Text(
          "ACCENT COLOR",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
            color: Color(0xff4c4546),
          ),
        ),

        const SizedBox(height: 16),

        Wrap(
          spacing: 16,
          children: accentColors.map((color) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedAccent = color;
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: Border.all(
                    color: selectedAccent == color
                        ? Colors.black
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: selectedAccent == color
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
          "Input Methods",
          "Configure how you interact with the canvas.",
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xffcfc4c5),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xffeeeeee),
                  Colors.white,
                ],
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.movie_creation_outlined,
                size: 70,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text(
                  "Unlock AnimeClip Pro",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Get unlimited cloud projects, cloud sync, and advanced export tools.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff4c4546),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Upgrade Now",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
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
  Widget _sectionTitle(
      String title,
      String subtitle,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xff4c4546),
          ),
        ),
      ],
    );
  }
  Widget _themeSelector() {
    return Row(
      children: [
        Expanded(
          child: _themeCard(
            title: "Light",
            isSelected: themeMode == AppThemeMode.light,
            isDark: false,
            onTap: (){
              setState(() {
                themeMode = AppThemeMode.light;
              });
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _themeCard(
            title: "Dark",
            isSelected: themeMode == AppThemeMode.dark,
            isDark: true,
            onTap: (){
              setState(() {
                themeMode = AppThemeMode.dark;
              });
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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
  height: 125,
  padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xff1b1c1c)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: isSelected ? 2 : 1,
                color: isSelected
                    ? Colors.black
                    : const Color(0xffcfc4c5),
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
                    color: isDark
                        ? const Color(0xff2f3131)
                        : Colors.white,
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
                if(isSelected)
                  Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.black,
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
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
              fontWeight: isSelected
                  ? FontWeight.w700
                  : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
    Widget _inputMethodsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xffcfc4c5),
        ),
      ),
      child: Column(
        children: [
          _inputTile(
            icon: Icons.edit,
            title: "Stylus",
            subtitle:
                "Optimized pressure sensitivity and tilt support.",
            value: inputMode == InputMode.stylus,
            onChanged: (){
              setState(() {
                inputMode = InputMode.stylus;
              });
            },
          ),
          _divider(),
          _inputTile(
            icon: Icons.touch_app,
            title: "Finger",
            subtitle:
                "Enable touch gestures for canvas manipulation.",
            value: inputMode == InputMode.finger,
            onChanged: (){
              setState(() {
                inputMode = InputMode.finger;
              });
            },
          ),
          _divider(),
          _inputTile(
            icon: Icons.devices,
            title: "Both (Stylus & Finger)",
            subtitle:
                "Seamlessly switch between stylus precision and touch gestures.",
            value: inputMode == InputMode.both,
            onChanged: (){
              setState(() {
                inputMode = InputMode.both;
              });
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
    return InkWell(
      onTap: onChanged,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: const Color(0xffeeeeee),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff4c4546),
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
              activeThumbColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
  Widget _divider(){
    return const Divider(
      height: 1,
      color: Color(0xffcfc4c5),
    );
  }
}