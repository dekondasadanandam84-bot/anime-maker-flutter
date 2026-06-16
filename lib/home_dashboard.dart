import 'package:flutter/material.dart';

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
                        _item(Icons.person, "Profile"),
                        _item(Icons.workspace_premium, "Go Pro"),
                        _item(Icons.folder, "Projects"),
                        _item(Icons.groups, "Collaboration"),
                        _item(Icons.monetization_on, "Earn Credits"),
                        _item(Icons.image, "Assets"),
                      ],
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
                      horizontal: 12, vertical: 10),
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

                      // 🎨 ANIME MAKER LOGO STYLE TEXT
                      Transform.scale(
                        scale: isTablet ? 1.1 : 1.0,
                        child: Text(
                          "ANIME MAKER",
                          style: TextStyle(
                            fontSize: isTablet ? 34 : 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4,
                            color: Colors.white,

                            // 🔥 Anime glow + depth effect
                            shadows: const [
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 6,
                                color: Colors.black,
                              ),
                              Shadow(
                                offset: Offset(0, 0),
                                blurRadius: 12,
                                color: Colors.deepPurple,
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
                      : Center(
                          child: Text(
                            selectedSection,
                            style: TextStyle(
                              fontSize:
                                  isTablet ? 34 : 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),

          // ONLY FOR PROJECTS
          floatingActionButton:
              selectedSection == "Projects"
                  ? FloatingActionButton.extended(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          showDragHandle: true,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize:
                                    MainAxisSize.min,
                                children: const [
                                  Text(
                                    "Create Project",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ListTile(
                                    leading: Icon(Icons.movie),
                                    title: Text("Anime"),
                                  ),
                                  ListTile(
                                    leading:
                                        Icon(Icons.menu_book),
                                    title: Text("Manga"),
                                  ),
                                  ListTile(
                                    leading:
                                        Icon(Icons.landscape),
                                    title: Text("Background"),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
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
              "Click + Create button to get started",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
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
          fontWeight: isSelected
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        setState(() {
          selectedSection = title;
        });
        Navigator.pop(context);
      },
    );
  }
}