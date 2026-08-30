
import 'package:flutter/material.dart';

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

class AnimeClipApp extends StatelessWidget {
  const AnimeClipApp({
    super.key,
    required this.projectController,
  });

  final ProjectController projectController;

  @override
  Widget build(BuildContext context) {
    return ProjectScope(
      controller: projectController,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AnimeClip',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black,
            brightness: Brightness.light,
          ),
        ),
        home: const HomeUI(),
      ),
    );
  }
}

