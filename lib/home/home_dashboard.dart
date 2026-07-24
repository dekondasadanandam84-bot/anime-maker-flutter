import 'package:flutter/material.dart';

import 'widgets/home_body.dart';
import 'widgets/home_drawer.dart';
import 'widgets/sheets/profile_sheet.dart';
import 'widgets/sheets/create_project_sheet.dart';
import 'package:flutter_application_1/screens/create_project_screen.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  String selectedSection = "Projects";
  List<Map<String, dynamic>> projects = [];

  Future<void> _openCreateSheet() async {
  final type = await showCreateProjectSheet(context);

  if (!mounted || type == null) return;

  final project = await Navigator.push<Map<String, dynamic>>(
    context,
    MaterialPageRoute(
      builder: (_) => CreateProjectScreen(
  projectType: type,
),
    ),
  );

  if (!mounted || project == null) return;

  setState(() {
    projects.add(project);
  });
}

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 700;

    return Scaffold(
      drawer: HomeDrawer(
        selectedSection: selectedSection,
        onSectionSelected: (section) {
          setState(() {
            selectedSection = section;
          });
        },
        onProfileTap: () {
          showProfileSheet(context);
        },
      ),

      body: SafeArea(
  child: Column(
    children: [
      Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            Expanded(
  child: Center(
    child: Stack(
      alignment: Alignment.center,
      children: [
        Text(
          "Anime Maker",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4
              ..color = Colors.white.withValues(alpha: 0.9),
          ),
        ),
        Text(
          "Anime Maker",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: const Color.fromARGB(255, 173, 126, 255),
            shadows: [
              Shadow(
                blurRadius: 12,
                color: Colors.blueAccent.withValues(alpha: 0.6),
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
          ],
        ),
      ),

      const Divider(height: 1),

      Expanded(
        child: HomeBody(
  selectedSection: selectedSection,
  projects: projects,
  isTablet: isTablet,
  onProjectsChanged: (updatedProjects) {
    setState(() {
      projects = updatedProjects;
    });
  },
  onSectionSelected: (section) {
    setState(() {
      selectedSection = section;
    });
  },
)
      ),
    ],
  ),
),

      floatingActionButton: selectedSection == "Projects"
    ? FloatingActionButton(
        onPressed: _openCreateSheet,
        child: const Icon(Icons.add),
      )
    : null,
    );
  }
}