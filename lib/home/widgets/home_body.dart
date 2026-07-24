import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/widgets/project_grid.dart';
import 'package:flutter_application_1/screens/collaboration_screen.dart';
import 'package:flutter_application_1/screens/earn_credits_screen.dart';
import 'package:flutter_application_1/screens/premium_screen.dart';


class HomeBody extends StatelessWidget {
  final String selectedSection;
  final List<Map<String, dynamic>> projects;
  final bool isTablet;
  final ValueChanged<List<Map<String, dynamic>>> onProjectsChanged;
  final ValueChanged<String> onSectionSelected;

  const HomeBody({
    super.key,
    required this.selectedSection,
    required this.projects,
    required this.isTablet,
    required this.onProjectsChanged,
    required this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedSection) {
      case "Projects":
        return ProjectsView(
          projects: projects,
          isTablet: isTablet,
          onProjectsChanged: onProjectsChanged,
        );

      case "Collaboration":
  return CollaborationScreen(
    onBack: () => onSectionSelected("Projects"),
  );

case "Earn Credits":
  return EarnCreditsScreen(
    onBack: () => onSectionSelected("Projects"),
  );

case "Go Pro":
  return PremiumScreen(
    onBack: () => onSectionSelected("Projects"),
  );

      default:
        return const SizedBox();
    }
  }
}