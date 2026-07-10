import 'package:flutter/material.dart';
import 'package:flutter_application_1/anime_editor/anime_editor_screen.dart';
import 'package:flutter_application_1/manga_editor/manga_editor_screen.dart';
import 'package:flutter_application_1/screens/create_project_screen.dart';

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
                    _item(Icons.workspace_premium, "Go Pro"),
                    _item(Icons.folder, "Projects"),
                    _item(Icons.groups, "Collaboration"),
                    _item(Icons.monetization_on, "Earn Credits"),
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
                    _showProfileSheet(context);
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

                  const Spacer(),
                ],
              ),
            ),

            const Divider(),

            Expanded(child: _buildBody(isTablet)),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateSheet,
        child: const Icon(Icons.add),
      ),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 90, color: Colors.grey),
            SizedBox(height: 15),
            Text(
              "No Projects Yet",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "You haven't created a project yet.\nClick the + button below to get started.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

return GridView.builder(
  padding: const EdgeInsets.all(12),
  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 250,
    childAspectRatio: 0.82,
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
  ),
  itemCount: projects.length,
  itemBuilder: (context, index) {
    final project = projects[index];

    return GestureDetector(
  onTapDown: (details) async {
    final navigator = Navigator.of(context);

final selected = await showMenu(
  context: context,
  position: RelativeRect.fromLTRB(
    details.globalPosition.dx,
    details.globalPosition.dy,
    0,
    0,
  ),
  items: const [
    PopupMenuItem(value: "edit", child: Text("Edit")),
    PopupMenuItem(value: "download", child: Text("Download")),
    PopupMenuItem(value: "share", child: Text("Share")),
    PopupMenuItem(value: "delete", child: Text("Delete")),
  ],
);

if (!mounted) return;

if (selected == "edit") {
  final updatedProject = await navigator.push(
    MaterialPageRoute(
      builder: (_) => project["type"] == "manga"
    ? MangaEditorScreen(
        projectName: project["name"],
        pages: project["pages"] ?? 1,
        size: project["size"] ?? "A4",
      )
    : AnimeEditorScreen(
        projectName: project["name"],
        ratio: project["ratio"] ?? "16:9",
        fps: project["fps"] ?? 12,
      )
    ),
  );    

  if (!mounted) return;

  if (updatedProject != null && updatedProject is Map<String, dynamic>) {
  setState(() {
    projects[index] = updatedProject;
  });
}
}

    if (selected == "delete") {
      setState(() {
        projects.removeAt(index);
      });
    }
  },

  child: Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Column(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            color: Colors.grey.shade300,
            child: Center(
              child: Icon(
                project["thumbnail"],
                size: 60,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  project["name"],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                project["type"] == "manga"
    ? Text(
        '${project["size"] ?? "A4"} • ${project["pages"] ?? 1} Pages',
      )
    : Text(
        '${project["ratio"] ?? "16:9"} • ${project["fps"] ?? 12} FPS',
      ),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
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

  void _openCreateSheet() {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) {
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

            const SizedBox(height: 15),

ListTile(
  leading: const Icon(Icons.movie),
  title: const Text("Anime Project"),
  onTap: () async {
    Navigator.pop(context);

    final project = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateProjectScreen(),
      ),
    );

    if (project != null) {
  

  setState(() {
    projects.add(project as Map<String, dynamic>);
  });
}
  },
),

ListTile(
  leading: const Icon(Icons.menu_book),
  title: const Text("Manga Project"),
  onTap: () async {
    Navigator.pop(context);

    final project = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateProjectScreen(isManga: true),
      ),
    );

    if (project != null) {
      setState(() {
        projects.add(project as Map<String, dynamic>);
      });
    }
  },
),
          ],
        ),
      );
    },
  );
}
void _showProfileSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.55,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Top Handle
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Accounts",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _profileTile(
                          name: "Dhanush (Current)",
                          isActive: true,
                        ),
                        _profileTile(name: "Anime Creator 1"),
                        _profileTile(name: "Studio Account"),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                 foregroundColor: Colors.green,
                ),
                 onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.add, color: Colors.green),
                label: const Text("Add Account"),
                 ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.white,
                   foregroundColor: Colors.red,
                  ),
                  onPressed: () {
                   Navigator.pop(context);
                  },
                 icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text("Logout"),
                 ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _profileTile({
  required String name,
  bool isActive = false,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: isActive
          ? Colors.deepPurple.shade100
          : Colors.grey.shade100,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: isActive
            ? Colors.deepPurple
            : Colors.grey.shade300,
      ),
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.deepPurple.shade200,
          child: const Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}}