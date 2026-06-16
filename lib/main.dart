import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/home_dashboard.dart';

void main() {
  runApp(const AnimeMakerApp());
}

class AnimeMakerApp extends StatelessWidget {
  const AnimeMakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anime Maker',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      home: const HomeDashboardScreen(),
    );
  }
}