import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/responsive.dart';
import '../Screens/home_dashboard.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({super.key});

  @override
  Widget build(BuildContext context) {
    if (Responsive.isTablet(context)) {
      return const TabletLayout();
    }
    return const HomeDashboardScreen();
  }
}

class TabletLayout extends StatelessWidget {
  const TabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 280,
            color: Colors.grey.shade200,
            child: const SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Icon(Icons.animation, size: 50),
                  SizedBox(height: 10),
                  Text("Anime Maker"),
                ],
              ),
            ),
          ),

          // Main Content
          const Expanded(
            child: HomeDashboardScreen(),
          ),
        ],
      ),
    );
  }
}