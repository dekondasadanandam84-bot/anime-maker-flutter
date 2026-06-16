import 'package:flutter/material.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() =>
      _HomeDashboardScreenState();
}

class _HomeDashboardScreenState
    extends State<HomeDashboardScreen> {
  String selectedSection = 'Projects';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth >= 700;

        return Scaffold(
          drawer: Drawer(
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  const CircleAvatar(
                    radius: 40,
                    child: Icon(
                      Icons.person,
                      size: 40,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Anime Maker User',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Divider(),

                  Expanded(
                    child: ListView(
                      children: [
                        _drawerTile(
                          icon: Icons.person,
                          title: 'Profile',
                        ),

                        _drawerTile(
                          icon: Icons.workspace_premium,
                          title: 'Go Pro',
                        ),

                        _drawerTile(
                          icon: Icons.folder,
                          title: 'Projects',
                        ),

                        _drawerTile(
                          icon: Icons.groups,
                          title: 'Collaboration',
                        ),

                        _drawerTile(
                          icon: Icons.monetization_on,
                          title: 'Earn Credits',
                        ),

                        _drawerTile(
                          icon: Icons.inventory_2,
                          title: 'Assets',
                        ),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 24 : 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Builder(
                        builder: (context) {
                          return IconButton(
                            icon: const Icon(Icons.menu),
                            iconSize: isTablet ? 40 : 34,
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          );
                        },
                      ),

                      Expanded(
                        child: Center(
                          child: Text(
                            'ANIME MAKER',
                            style: TextStyle(
                              fontSize: isTablet ? 32 : 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        width: isTablet ? 40 : 34,
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                Expanded(
                  child: Center(
                    child: Text(
                      selectedSection,
                      style: TextStyle(
                        fontSize: isTablet ? 34 : 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          floatingActionButton:
              selectedSection == 'Projects'
                  ? FloatingActionButton.extended(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          showDragHandle: true,
                          builder: (context) {
                            return SafeArea(
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize:
                                      MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Create Project',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 16,
                                    ),

                                    ListTile(
                                      leading: const Icon(
                                        Icons.movie,
                                      ),
                                      title: const Text(
                                        'Anime',
                                      ),
                                      onTap: () {},
                                    ),

                                    ListTile(
                                      leading: const Icon(
                                        Icons.menu_book,
                                      ),
                                      title: const Text(
                                        'Manga',
                                      ),
                                      onTap: () {},
                                    ),

                                    ListTile(
                                      leading: const Icon(
                                        Icons.landscape,
                                      ),
                                      title: const Text(
                                        'Background',
                                      ),
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text(
                        'Create',
                      ),
                    )
                  : null,
        );
      },
    );
  }

  Widget _drawerTile({
    required IconData icon,
    required String title,
  }) {
    final bool selected =
        selectedSection == title;

    return ListTile(
      leading: Icon(
        icon,
        size: selected ? 30 : 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: selected ? 22 : 18,
          fontWeight: selected
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
      selected: selected,
      onTap: () {
        setState(() {
          selectedSection = title;
        });

        Navigator.pop(context);
      },
    );
  }
}