import 'package:flutter/material.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() =>
      _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  Widget _accountTile({
  required String name,
  bool isActive = false,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: isActive ? Colors.deepPurple : Colors.grey.shade900,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isActive ? Colors.purple : Colors.transparent,
      ),
    ),
    child: Row(
      children: [
        const CircleAvatar(
          child: Icon(Icons.person),
        ),
        const SizedBox(width: 10),
        Text(
          name,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    ),
  );
}
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

        const Divider(),

        

        // 📌 MAIN MENU (TAKES AVAILABLE SPACE)
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

        // 🔥 PUSH PROFILE TO TRUE BOTTOM
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

            Expanded(child: _buildBody(isTablet)),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
  onPressed: _openCreateSheet,
  child: const Icon(Icons.add),
),
          key: null,
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
        return null;


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
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Create Project",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text("Anime Project"),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text("Manga Project"),
              onTap: () {
                Navigator.pop(context);
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
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
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

              const SizedBox(height: 15),

              const Text(
                "Accounts",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // ACCOUNTS HERE
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _accountTile(
                        name: "Dhanush (Current)",
                        isActive: true,
                      ),
                      _accountTile(name: "Anime Creator 1"),
                      _accountTile(name: "Studio Account"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // BUTTONS
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Account"),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  },
);}

}