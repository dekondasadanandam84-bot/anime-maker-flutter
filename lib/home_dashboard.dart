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
    final isTablet = MediaQuery.of(context).size.width >= 700;

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

              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Profile"),
                onTap: () {
  Navigator.pop(context);

  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const Text(
              "Accounts",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // 👤 ACCOUNT 1
            const ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text("dhanush@gmail.com"),
              subtitle: Text("Primary Account"),
            ),

            // 👤 ACCOUNT 2
            const ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.person_outline),
              ),
              title: Text("animecreator@gmail.com"),
              subtitle: Text("Secondary Account"),
            ),

            // 👤 ACCOUNT 3
            const ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.person_outline),
              ),
              title: Text("studio.team@gmail.com"),
              subtitle: Text("Team Account"),
            ),

            const Divider(),

            // ➕ ADD ACCOUNT
            ListTile(
              leading: const Icon(
                Icons.add_circle,
                color: Colors.green,
              ),
              title: const Text(
                "Add Account",
                style: TextStyle(color: Colors.green),
              ),
              onTap: () {
                // dummy action
              },
            ),

            // 🚪 LOGOUT
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                // dummy action
              },
            ),

            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}, 
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
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () =>
                          Scaffold.of(context).openDrawer(),
                    ),
                  ),

                  const Spacer(),

                  const Text(
                    "ANIME MAKER",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),

            const Divider(),

            // BODY
            Expanded(
              child: _buildBody(isTablet),
            ),
          ],
        ),
      ),

      // + CREATE BUTTON (ONLY FOR PROJECTS)
      floatingActionButton: selectedSection == "Projects"
          ? FloatingActionButton.extended(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  showDragHandle: true,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            "Create Project",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          ListTile(
                            leading: Icon(Icons.movie),
                            title: Text("Anime"),
                          ),
                          ListTile(
                            leading: Icon(Icons.menu_book),
                            title: Text("Manga"),
                          ),
                          ListTile(
                            leading: Icon(Icons.landscape),
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
  }

  // 🎯 BODY SWITCH
  Widget _buildBody(bool isTablet) {
    switch (selectedSection) {
      case "Projects":
        return _projectsEmptyState(isTablet);

      case "Go Pro":
        return PremiumScreen(
          onBackToProjects: () {
            setState(() => selectedSection = "Projects");
          },
        );

     case "Collaboration":
  return CollaborationScreen(
    onBack: () {
      setState(() {
        selectedSection = "Projects";
      
      });
    },
  );

      default:
        return Center(
          child: Text(
            selectedSection,
            style: TextStyle(
              fontSize: isTablet ? 30 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
    }
  }

  // 📂 EMPTY STATE
  Widget _projectsEmptyState(bool isTablet) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: isTablet ? 110 : 80,
            color: Colors.grey,
          ),

          const SizedBox(height: 15),

          const Text(
            "You haven't created a project yet",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Use the + button below to start creating",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // 📌 DRAWER ITEM
  Widget _item(IconData icon, String title) {
    final isSelected = selectedSection == title;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.blue : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight:
              isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context);
        setState(() => selectedSection = title);
      },
    );
  }
}