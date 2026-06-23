import 'package:flutter/material.dart';
import 'package:flutter_application_1/anime_editor_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() =>
      _HomeDashboardScreenState();
}

class _HomeDashboardScreenState
    extends State<HomeDashboardScreen> {

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
        icon: const Icon(Icons.add),
        label: const Text("Create"),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (bottomSheetContext) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Create Project",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

ListTile(
  leading: const Icon(Icons.movie),
  title: const Text("Anime"),
  onTap: () {
    Navigator.pop(context); // closes bottom sheet
    _openAnimePopup(this.context); // opens popup using home screen context
  },
),
                    ListTile(
                      leading: const Icon(Icons.menu_book),
                      title: const Text("Manga"),
                      onTap: () {},
                    ),

                    ListTile(
                      leading: const Icon(Icons.file_upload),
                      title: const Text("Import Project"),
                      onTap: () {},
                    ),
                  ],
                ),
              );
            },
          );
        },
      )
    : null,
  );
}

  // 🎯 BODY SWITCH
  Widget _buildBody(bool isTablet) {
    switch (selectedSection) {
      case "Projects":
        return _projectsEmptyState(isTablet);
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
  if (projects.isEmpty) {
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
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  return GridView.builder(
    padding: const EdgeInsets.all(12),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: isTablet ? 3 : 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.8,
    ),
    itemCount: projects.length,
    itemBuilder: (context, index) {
      final project = projects[index];

      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // Thumbnail
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.movie,
                    size: 60,
                    color: Colors.white70,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                project["name"]?.toString() ?? "Untitled",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {},
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: "delete",
                        child: Text("Delete"),
                      ),
                      const PopupMenuItem(
                        value: "location",
                        child: Text("Show Location"),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == "delete") {
                        setState(() {
                          projects.removeAt(index);
                        });
                      }

                      if (value == "location") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Storage/emulated/0/AnimeMaker/",
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
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

void _openAnimePopup(BuildContext context) {
  final nameController = TextEditingController();
  String selectedRatio = "16:9";
  int frames = 24;

  showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return AlertDialog(
            title: const Text("Create Anime Project"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Animation Name",
                    ),
                  ),
                  const SizedBox(height: 15),

                  DropdownButton<String>(
                    value: selectedRatio,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: "16:9",
                        child: Text("16:9"),
                      ),
                      DropdownMenuItem(
                        value: "1:1",
                        child: Text("1:1"),
                      ),
                      DropdownMenuItem(
                        value: "9:16",
                        child: Text("9:16"),
                      ),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        selectedRatio = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Frames"),
                      IconButton(
                        onPressed: () {
                          if (frames > 1) {
                            setDialogState(() {
                              frames--;
                            });
                          }
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Text("$frames"),
                      IconButton(
                        onPressed: () {
                          setDialogState(() {
                            frames++;
                          });
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);

final Map<String, dynamic>? result = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => AnimeEditorScreen(
      projectName: nameController.text.trim().isEmpty
          ? "Untitled"
          : nameController.text.trim(),
    ),
  ),
);
if (result != null) {
  setState(() {
    projects.add(Map<String, dynamic>.from(result));
  });
}                },
                child: const Text("Create Project"),
              ),
            ],
          );
        },
      );
    },
  );
}
}