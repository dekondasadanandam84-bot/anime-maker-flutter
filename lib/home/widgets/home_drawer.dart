import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/widgets/drawer_item.dart';

class HomeDrawer extends StatelessWidget {
  final String selectedSection;
  final ValueChanged<String> onSectionSelected;
  final VoidCallback onProfileTap;

  const HomeDrawer({
    super.key,
    required this.selectedSection,
    required this.onSectionSelected,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
              const SizedBox(height: 20),

              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.deepPurple,
                        width: 2,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 42,
                      backgroundImage: AssetImage("assets/logo.png"),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Stack(
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
                          color: Colors.deepPurpleAccent.shade100,
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
                ],
              ),

              const Divider(),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
  DrawerItem(
    icon: Icons.workspace_premium,
    title: "Go Pro",
    isSelected: selectedSection == "Go Pro",
    onTap: () {
      Navigator.pop(context);
      onSectionSelected("Go Pro");
    },
  ),
  DrawerItem(
    icon: Icons.folder,
    title: "Projects",
    isSelected: selectedSection == "Projects",
    onTap: () {
      Navigator.pop(context);
      onSectionSelected("Projects");
    },
  ),
  DrawerItem(
    icon: Icons.groups,
    title: "Collaboration",
    isSelected: selectedSection == "Collaboration",
    onTap: () {
      Navigator.pop(context);
      onSectionSelected("Collaboration");
    },
  ),
  DrawerItem(
    icon: Icons.monetization_on,
    title: "Earn Credits",
    isSelected: selectedSection == "Earn Credits",
    onTap: () {
      Navigator.pop(context);
      onSectionSelected("Earn Credits");
    },
  ),
],
                ),
              ),

              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey),
                  ),
                ),
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("Profile"),
                  onTap: () {
  Navigator.pop(context);
  onProfileTap();
},
                ),
              ),
            ],
          ),
        ),
      );
  }
}