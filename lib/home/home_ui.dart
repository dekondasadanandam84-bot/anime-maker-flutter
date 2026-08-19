import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/drawer_ui.dart';
import 'package:flutter_application_1/home/home_controller.dart';
import 'package:flutter_application_1/core/app_media.dart';
import 'package:flutter_application_1/search/search_ui.dart';
import 'package:flutter_application_1/home/create_project_button.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  final HomeController controller = const HomeController();

  // 0 = Series
  // 1 = Movies
  // 2 = Manga
  // 3 = Book
  //
  // Movies is the default tab.
  int _selectedTab = 1;

  @override
  Widget build(BuildContext context) {
    AppMedia.init(context);

    return Scaffold(
      backgroundColor: Colors.white,

      // ============================================================
      // TOP APP BAR — REMAINS THE SAME
      // ============================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DrawerUI()),
            );
          },
          icon: const Icon(Icons.menu, color: Colors.black, size: 28),
        ),

        title: const Text(
          "AnimeClip",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xff1E293B),
            letterSpacing: -.3,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchUI()),
              );
            },
            icon: const Icon(
              Icons.search,
              color: Color.fromARGB(255, 220, 14, 207),
              size: 34,
            ),
          ),
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xffECECEC)),
        ),
      ),

      // ============================================================
      // MIDDLE CONTENT
      // ============================================================
      body: SafeArea(
        child: Padding(
          padding: AppMedia.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Changes when bottom navigation is selected.
              _SelectedCategorySection(selectedTab: _selectedTab),

              const SizedBox(height: 20),

              // Boxing Demo remains visible on EVERY TAB.
              const ProjectCard(),

              const Spacer(),
            ],
          ),
        ),
      ),

      // ============================================================
      // BOTTOM NAVIGATION — REMAINS ON SAME SCREEN
      // ============================================================
      bottomNavigationBar: HomeBottomBar(
        selectedTab: _selectedTab,
        onTabSelected: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
      ),
    );
  }
}

// ================================================================
// CATEGORY CONTENT
// ================================================================

class _SelectedCategorySection extends StatelessWidget {
  final int selectedTab;

  const _SelectedCategorySection({required this.selectedTab});

  @override
  Widget build(BuildContext context) {
    final data = _CategoryData.fromIndex(selectedTab);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Row(
            children: [
              Icon(data.icon, size: 22, color: data.color),
              const SizedBox(width: 8),
              Text(
                data.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            data.description,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xff666666),
              height: 1.4,
            ),
          ),
        ),

        const SizedBox(height: 12),

        const Divider(height: 1, thickness: 1, color: Color(0xffEAEAEA)),
      ],
    );
  }
}

// ================================================================
// CATEGORY DATA
// ================================================================

class _CategoryData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _CategoryData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  static _CategoryData fromIndex(int index) {
    switch (index) {
      case 0:
        return const _CategoryData(
          title: 'Series',
          description: 'Create and organize episodic anime projects.',
          icon: Icons.movie_creation_outlined,
          color: Color(0xff7C3AED),
        );

      case 1:
        return const _CategoryData(
          title: 'Movies',
          description: 'Create and manage long-form animated movies.',
          icon: Icons.theaters_outlined,
          color: Color(0xffE11D48),
        );

      case 2:
        return const _CategoryData(
          title: 'Manga',
          description: 'Create and organize manga series and pages.',
          icon: Icons.auto_stories_outlined,
          color: Color(0xff0EA5E9),
        );

      case 3:
        return const _CategoryData(
          title: 'Book',
          description: 'Create and manage standalone manga books.',
          icon: Icons.menu_book_outlined,
          color: Color(0xff16A34A),
        );

      default:
        return const _CategoryData(
          title: 'Movies',
          description: 'Create and manage long-form animated movies.',
          icon: Icons.theaters_outlined,
          color: Color(0xffE11D48),
        );
    }
  }
}

// ================================================================
// PROJECT CARD
// ================================================================

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 160,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xffEAEAEA)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                "assets/screen.png",
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return Container(
                    color: const Color(0xffF4F4F4),
                    child: const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Center(
            child: Text(
              "Boxing Demo",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// CREATE BUTTON
// ================================================================

class CreateBottomItem extends StatelessWidget {
  const CreateBottomItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: const BoxDecoration(
        color: Color(0xFFE91E63),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.add, color: Colors.white, size: 34),
    );
  }
}

// ================================================================
// BOTTOM NAVIGATION
// ================================================================

class HomeBottomBar extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabSelected;

  const HomeBottomBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xffEAEAEA), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: _BottomItem(
                icon: Icons.movie_creation_outlined,
                title: "Series",
                color: const Color(0xff7C3AED),
                selected: selectedTab == 0,
                onTap: () => onTabSelected(0),
              ),
            ),

            Expanded(
              child: _BottomItem(
                icon: Icons.theaters_outlined,
                title: "Movies",
                color: const Color(0xffE11D48),
                selected: selectedTab == 1,
                onTap: () => onTabSelected(1),
              ),
            ),

            // Center create button uses the same width as every
            // other navigation slot, so there is no large gap.
            Expanded(child: Center(child: const CreateProjectButton())),

            Expanded(
              child: _BottomItem(
                icon: Icons.auto_stories_outlined,
                title: "Manga",
                color: const Color(0xff0EA5E9),
                selected: selectedTab == 2,
                onTap: () => onTabSelected(2),
              ),
            ),

            Expanded(
              child: _BottomItem(
                icon: Icons.menu_book_outlined,
                title: "Book",
                color: const Color(0xff16A34A),
                selected: selectedTab == 3,
                onTap: () => onTabSelected(3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// BOTTOM NAV ITEM
// ================================================================

class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _BottomItem({
    required this.icon,
    required this.title,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Selected indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                width: selected ? 38 : 0,
                height: 3,
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),

              AnimatedScale(
                scale: selected ? 1.08 : 1.0,
                duration: const Duration(milliseconds: 180),
                child: Icon(icon, size: 23, color: color),
              ),

              const SizedBox(height: 3),

              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  color: selected ? color : const Color(0xff555555),
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================================================
// OLD RECENT SECTION
// ================================================================

class RecentSection extends StatelessWidget {
  const RecentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            "Recent",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 1, color: Color(0xffEAEAEA)),
      ],
    );
  }
}
