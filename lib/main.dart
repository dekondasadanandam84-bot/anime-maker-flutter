import 'package:flutter/material.dart';

import 'package:flutter_application_1/core/app_theme.dart';
import 'package:flutter_application_1/home/home_ui.dart';
import 'package:flutter_application_1/home/project_controller.dart';
import 'package:flutter_application_1/home/project_scope.dart';

void main() {
  final projectController = ProjectController();

  runApp(
    AnimeClipApp(
      projectController: projectController,
    ),
  );
}

class AnimeClipApp extends StatefulWidget {
  const AnimeClipApp({
    super.key,
    required this.projectController,
  });

  final ProjectController projectController;

  @override
  State<AnimeClipApp> createState() => _AnimeClipAppState();
}

class _AnimeClipAppState extends State<AnimeClipApp> {
  late final AppThemeController _themeController;

  @override
  void initState() {
    super.initState();
    _themeController = AppThemeController();
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeScope(
      controller: _themeController,
      child: AnimatedBuilder(
        animation: _themeController,
        builder: (context, _) {
          return ProjectScope(
            controller: widget.projectController,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'AnimeClip',
              theme: _themeController.themeData,
              home: const HomeUI(),
            ),
          );
        },
      ),
    );
  }
}
