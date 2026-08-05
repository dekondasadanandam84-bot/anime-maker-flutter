import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/home_ui.dart';

void main() {
  runApp(const AnimeClipApp());
}

class AnimeClipApp extends StatelessWidget {
  const AnimeClipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
