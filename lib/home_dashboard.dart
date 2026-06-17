import 'package:flutter/material.dart';
import 'collaboration_screen.dart';
import 'premium_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() =>
      _HomeDashboardScreenState();
}

class _HomeDashboardScreenState
    extends State<HomeDashboardScreen> {
  String selectedSection = "Projects";

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 700;

        return Scaffold(
          drawer: Drawer(
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  const CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person, size: 40),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Anime Maker",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Divider(height: 30),

                  Expanded(
                    child: ListView(
                      children: [
                        _item(Icons.workspace_premium, "Go Pro"),
                        _item(Icons.folder, "Projects"),
                        _item(Icons.groups, "Collaboration"),
                        _item(Icons.monetization_on, "Earn Credits"),
                        _item(Icons.image, "Assets"),
                      ],
                    ),
                  ),

                  const Divider(),

                  // PROFILE SECTION
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.01,
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.person,
                        size: selectedSection == "Profile" ? 30 : 24,
                      ),
                      title: Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: selectedSection == "Profile" ? 22 : 18,
                          fontWeight: selectedSection == "Profile"
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);

                        showModalBottomSheet(
                          context: context,
                          showDragHandle: true,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  ListTile(
                                    leading: CircleAvatar(
                                      child: Icon(Icons.person),
                                    ),
                                    title: Text("Dhanush"),
                                    subtitle: Text("dhanush@gmail.com"),
                                  ),
                                  Divider(),
                                  ListTile(
                                    leading: Icon(Icons.person),
                                    title: Text("dhanush@gmail.com ✓"),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.person_outline),
                                    title: Text("anime@gmail.com"),
                                  ),
                                  Divider(),
                                  ListTile(
                                    leading: Icon(Icons.add, color: Colors.green),
                                    title: Text(
                                      "Add Account",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.logout, color: Colors.red),
                                    title: Text(
                                      "Logout",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          body: SafeArea(
            child: Column(
              children: [
                // TOP BAR
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu),
                          iconSize: isTablet ? 38 : 30,
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                      ),

                      const Spacer(),

                      Transform.scale(
                        scale: isTablet ? 1.1 : 1.0,
                        child: const Text(
                          "ANIME MAKER",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 6,
                                color: Colors.black,
                              ),
                              Shadow(
                                offset: Offset(0, 0),
                                blurRadius: 12,
                                color: Color.fromARGB(255, 123, 51, 247),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(),
                    ],
                  ),
                ),

                const Divider(),

                // BODY
                Expanded(
                  child: selectedSection == "Projects"
                      ? _projectsEmptyState(isTablet)
                      : selectedSection == "Go Pro"
                          ? PremiumScreen(
                              onBackToProjects: () {
                                setState(() {
                                  selectedSection = "Projects";
                                });
                              },
                            )
                          : selectedSection == "Collaboration"
                              ? const CollaborationScreen()
                              : Center(
                                  child: Text(
                                    selectedSection,
                                    style: TextStyle(
                                      fontSize: isTablet ? 34 : 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                ),
              ],
            ),
          ),

          floatingActionButton: selectedSection == "Projects"
              ? FloatingActionButton.extended(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text("Create"),
                )
              : null,
        );
      },
    );
  }

  // 📂 EMPTY STATE
  Widget _projectsEmptyState(bool isTablet) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: isTablet ? 120 : 90,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 20),
            const Text(
              "You haven't created any projects yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Tap the + button to start creating your first anime project",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 📌 DRAWER ITEM
  Widget _item(IconData icon, String title) {
    final isSelected = selectedSection == title;

    return ListTile(
      leading: Icon(
        icon,
        size: isSelected ? 30 : 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: isSelected ? 22 : 18,
          fontWeight:
              isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context);

        if (title == "Go Pro") {
  Navigator.push(
    context,
    smoothRoute(
      PremiumScreen(
        onBackToProjects: () {
          setState(() {
            selectedSection = "Projects";
          });
        },
      ),
    ),
  );
  return;
}
          setState(() => selectedSection = "Go Pro");
          return;
        }

        if (title == "Collaboration") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CollaborationScreen(),
            ),
          );
          return;
        }

        setState(() {
          selectedSection = title;
        });
      },
    );
  }
}
PageRouteBuilder smoothRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = 0.85;
      const end = 1.0;

      final scale = Tween(begin: begin, end: end).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        ),
      );

      final fade = Tween(begin: 0.0, end: 1.0).animate(animation);

      return FadeTransition(
        opacity: fade,
        child: ScaleTransition(
          scale: scale,
          child: child,
        ),
      );
    },
  );
}