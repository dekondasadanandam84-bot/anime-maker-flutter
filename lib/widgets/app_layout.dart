import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../Screens/home_dashboard.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({super.key});

  @override
  Widget build(BuildContext context) {
    if (Responsive.isTablet(context)) {
      return const TabletLayout();
    } else {
      return const HomeDashboardScreen();
    }
  }
}

class TabletLayout extends StatelessWidget {
  const TabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 280,
            child: Drawer(
              child: SafeArea(
                child: Column(
                  children: const [
                    SizedBox(height: 20),
                    Icon(Icons.auto_awesome, size: 50),
                    SizedBox(height: 10),
                    Text("Anime Maker"),
                  ],
                ),
              ),
            ),
          ),

          const Expanded(
            child: HomeDashboardScreen(),
          ),
        ],
      ),
    );
  }
}
