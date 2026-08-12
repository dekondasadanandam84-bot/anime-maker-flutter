import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/drawer_ui.dart';
import 'package:flutter_application_1/home/home_controller.dart';
import 'package:flutter_application_1/core/app_media.dart';
import 'package:flutter_application_1/search/search_ui.dart';

class HomeUI extends StatelessWidget {
  final HomeController controller = const HomeController();
  const HomeUI({super.key});

  @override
  Widget build(BuildContext context) {
     AppMedia.init(context);
    return Scaffold(
      backgroundColor: Colors.white,

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
        MaterialPageRoute(
          builder: (_) => const SearchUI(),
        ),
      );
    },
    icon: const Icon(
      Icons.search,
      color: Color.fromARGB(255, 81, 77, 77),
      size: 26,
    ),
  ),
],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xffECECEC)),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: AppMedia.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
  SizedBox(height: 24),
  RecentSection(),
  SizedBox(height: 20),
  ProjectCard(),
  Spacer(),
],
          ),
        ),
      ),

      bottomNavigationBar: const HomeBottomBar(),
    );
  }
}

///
/// PROJECT CARD
///

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

/// =======================================
/// CREATE BUTTON
/// =======================================

class CreateBottomItem extends StatelessWidget {
  const CreateBottomItem({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 78,
      child: Center(
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: Color(0xFFE91E63),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 34,
          ),
        ),
      ),
    );
  }
}

/// =======================================
/// BOTTOM NAVIGATION
/// =======================================

class HomeBottomBar extends StatelessWidget {
  const HomeBottomBar({super.key});

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
      ),
    ),

    Expanded(
      child: _BottomItem(
        icon: Icons.theaters_outlined,
        title: "Movies",
      ),
    ),

    const CreateBottomItem(),

    Expanded(
      child: _BottomItem(
        icon: Icons.auto_stories_outlined,
        title: "Manga",
      ),
    ),

    Expanded(
      child: _BottomItem(
        icon: Icons.menu_book_outlined,
        title: "Book",
      ),
    ),
  ],
)
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _BottomItem({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: const Color(0xff333333),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xff333333),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

        const Divider(
          height: 1,
          thickness: 1,
          color: Color(0xffEAEAEA),
        ),
      ],
    );
  }
}
