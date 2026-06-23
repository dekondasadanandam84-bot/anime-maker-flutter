import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/anime_editor_screen.dart';
import 'package:flutter_application_1/Screens/manga_editor_screen.dart';
import 'package:flutter_application_1/Widgets/project_dialog.dart';
import 'package:flutter_application_1/Widgets/project_card.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() =>
      _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  String selectedSection = "Projects";
  List<Map<String, dynamic>> projects = [];

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
              const Text("Anime Maker"),
              const Divider(height: 30),

              Expanded(
                child: ListView(
                  children: [
                    _item(Icons.workspace_premium, "Go Pro"),
                    _item(Icons.folder, "Projects"),
                    _item(Icons.groups, "Collaboration"),
                    _item(Icons.monetization_on, "Earn Credits"),
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

            const Divider(),

ListTile(
  leading: const Icon(Icons.person),
  title: const Text("Profile"),
  onTap: () {
    Navigator.pop(context);
    _showProfileSheet(context);
  },
),

            Expanded(child: _buildBody(isTablet)),
          ],
        ),
      ),

      floatingActionButton: selectedSection == "Projects"
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.add),
              label: const Text("Create"),
              onPressed: () => _openCreateSheet(context),
            )
          : null,
    );
  }

  // ================= BODY =================
  Widget _buildBody(bool isTablet) {
    switch (selectedSection) {
      case "Projects":
        return _projectsView(isTablet);

      case "Collaboration":
        return const Center(child: Text("Collaboration Screen"));

      case "Earn Credits":
        return const Center(child: Text("Earn Credits Screen"));

      case "Go Pro":
        return const Center(child: Text("Premium Screen"));

      default:
        return const SizedBox();
    }
  }

  // ================= PROJECT GRID =================
  Widget _projectsView(bool isTablet) {
    if (projects.isEmpty) {
      return const Center(
        child: Text("You haven't created a project yet"),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];

        return ProjectCard(
          project: project,
          onOpen: () {},
          onEdit: () {},
          onDelete: () {
            setState(() {
              projects.removeAt(index);
            });
          },
        );
      },
    );
  }

  // ================= DRAWER ITEM =================
  Widget _item(IconData icon, String title) {
    final isSelected = selectedSection == title;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.blue : null,
      ),
      title: Text(title),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context);

        if (title == "Collaboration") {
          Navigator.pushNamed(context, '/collaboration');
          return;
        }

        if (title == "Go Pro") {
          Navigator.pushNamed(context, '/premium');
          return;
        }

        if (title == "Earn Credits") {
          Navigator.pushNamed(context, '/earn-credits');
          return;
        }

        setState(() => selectedSection = title);
      },
    );
  }

  // ================= CREATE SHEET =================
  void _openCreateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (bottomContext) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Create Project",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              ListTile(
                leading: const Icon(Icons.movie),
                title: const Text("Anime"),
                onTap: () {
                  Navigator.pop(context);
                  _openAnimePopup(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.menu_book),
                title: const Text("Manga"),
                onTap: () {
                  Navigator.pop(context);
                  _openMangaPopup(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= ANIME POPUP =================
  void _openAnimePopup(BuildContext context) {
    final nameController = TextEditingController();
    String selectedRatio = "16:9";
    int frames = 24;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return CreateProjectDialog(
              title: "Create Anime Project",
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameController),

                  DropdownButton(
                    value: selectedRatio,
                    items: const [
                      DropdownMenuItem(value: "16:9", child: Text("16:9")),
                      DropdownMenuItem(value: "1:1", child: Text("1:1")),
                      DropdownMenuItem(value: "9:16", child: Text("9:16")),
                    ],
                    onChanged: (v) =>
                        setStateDialog(() => selectedRatio = v!),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Frames"),
                      IconButton(
                        onPressed: () =>
                            setStateDialog(() => frames--),
                        icon: const Icon(Icons.remove),
                      ),
                      Text("$frames"),
                      IconButton(
                        onPressed: () =>
                            setStateDialog(() => frames++),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
              onClose: () => Navigator.pop(dialogContext),
              onCreate: () async {
                final name = nameController.text.trim();
                Navigator.pop(dialogContext);

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AnimeEditorScreen(
                      projectName:
                          name.isEmpty ? "Untitled" : name,
                    ),
                  ),
                );

                if (result != null) {
                  setState(() {
                    projects.add(result);
                  });
                }
              },
            );
          },
        );
      },
    );
  }

  // ================= MANGA POPUP =================
  void _openMangaPopup(BuildContext context) {
    final nameController = TextEditingController();
    String selectedPaper = "A4";
    int pages = 1;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return CreateProjectDialog(
              title: "Create Manga Project",
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameController),

                  DropdownButton(
                    value: selectedPaper,
                    items: const [
                      DropdownMenuItem(value: "A4", child: Text("A4")),
                      DropdownMenuItem(value: "A5", child: Text("A5")),
                      DropdownMenuItem(value: "Webtoon", child: Text("Webtoon")),
                    ],
                    onChanged: (v) =>
                        setStateDialog(() => selectedPaper = v!),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Pages"),
                      IconButton(
                        onPressed: () =>
                            setStateDialog(() => pages--),
                        icon: const Icon(Icons.remove),
                      ),
                      Text("$pages"),
                      IconButton(
                        onPressed: () =>
                            setStateDialog(() => pages++),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
              onClose: () => Navigator.pop(dialogContext),
              onCreate: () async {
                final name = nameController.text.trim();
                Navigator.pop(dialogContext);

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MangaEditorScreen(
                      projectName:
                          name.isEmpty ? "Untitled" : name,
                    ),
                  ),
                );

                if (result != null) {
                  setState(() {
                    projects.add(result);
                  });
                }
              },
            );
          },
        );
      },
    );
  }
  
 void _showProfileSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // HANDLE BAR
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 20),

            // 👤 CURRENT ACCOUNT
            Row(
              children: const [
                CircleAvatar(
                  radius: 25,
                  child: Icon(Icons.person),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Current Account",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Dhanush",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ➕ ADD ACCOUNT (GREEN)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _addAccountFlow(context);
                },
                icon: const Icon(Icons.add),
                label: const Text("Add Account"),
              ),
            ),

            const SizedBox(height: 10),

            // 🚪 LOGOUT (RED)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _logoutAccount(context);
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}

  void _addAccountFlow(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      final controller = TextEditingController();

      return AlertDialog(
        title: const Text("Add Account"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Enter username",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Account '$name' created"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text("Create"),
          ),
        ],
      );
    },
  );
}
  
  void _logoutAccount(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Logged out"),
                ),
              );
            },
            child: const Text("Logout"),
          ),
        ],
      );
    },
  );
}
}