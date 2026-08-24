import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/drawer_ui.dart';
import 'package:flutter_application_1/home/home_controller.dart';
import 'package:flutter_application_1/core/app_media.dart';
import 'package:flutter_application_1/home/models/anime_movie_model.dart';
import 'package:flutter_application_1/home/models/anime_series_model.dart';
import 'package:flutter_application_1/search/search_ui.dart';
import 'package:flutter_application_1/home/create_project_button.dart';
import 'project_controller.dart';
import 'models/project_model.dart';
import 'project_card_ui.dart';
import 'package:flutter_application_1/home/anime/seasons_ui.dart';
import 'package:flutter_application_1/home/anime/movie_clips_ui.dart';
import 'package:flutter_application_1/editor/editor_ui.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  final HomeController controller = const HomeController();

  final ProjectController projectController = ProjectController();

  // 0 = Series
  // 1 = Movies
  // 2 = Manga
  // 3 = Book
  //
  // Movies is the default tab.
  int _selectedTab = 1;

  // ============================================================
  // PROJECT CREATED
  // ============================================================

  void _onProjectCreated(ProjectModel project) {
    projectController.addProject(project);

    setState(() {
      switch (project.projectType) {
        case ProjectType.animeSeries:
          _selectedTab = 0;
          break;

        case ProjectType.animeMovie:
          _selectedTab = 1;
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    projectController.addListener(_onProjectsChanged);
  }

  void _onProjectsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  // ============================================================
  // PROJECTS FOR SELECTED CATEGORY
  // ============================================================

  List<ProjectModel> _projectsForSelectedTab() {
    switch (_selectedTab) {
      case 0:
        return projectController.projects
            .where((project) => project.projectType == ProjectType.animeSeries)
            .toList();

      case 1:
        return projectController.projects
            .where((project) => project.projectType == ProjectType.animeMovie)
            .toList();

      case 2:
        // Manga will be added later.
        return const [];

      case 3:
        // Manga Book will be added later.
        return const [];

      default:
        return const [];
    }
  }

  // ============================================================
  // PROJECT EMOJI
  // ============================================================

  String _emojiForProject(ProjectModel project) {
    switch (project.projectType) {
      case ProjectType.animeSeries:
        return '📺';

      case ProjectType.animeMovie:
        return '🎬';
    }
  }

  // ============================================================
  // DELETE PROJECT
  // ============================================================

  void _deleteProject(ProjectModel project) {
    projectController.deleteProject(project.id);

    setState(() {});
  }

  // ============================================================
  // EDIT PROJECT
  // ============================================================

  Future<void> _editProject(ProjectModel project) async {
    // ============================================================
    // ANIME SERIES
    // ============================================================

    if (project.projectType == ProjectType.animeSeries &&
        project.animeSeries != null) {
      final updatedSeries = await Navigator.of(context).push<AnimeSeriesModel>(
        MaterialPageRoute(
          builder: (_) => SeasonsScreen(
            series: project.animeSeries!,
            settings: project.settings,
          ),
        ),
      );

      if (updatedSeries == null || !mounted) {
        return;
      }

      final updatedProject = project.copyWith(animeSeries: updatedSeries);

      projectController.updateProject(updatedProject);

      return;
    }

    // ============================================================
    // ANIME MOVIE
    // ============================================================

    if (project.projectType == ProjectType.animeMovie &&
        project.animeMovie != null) {
      final updatedMovie = await Navigator.of(context).push<AnimeMovieModel>(
        MaterialPageRoute(
          builder: (_) => MovieClipsScreen(
            movie: project.animeMovie!,
            settings: project.settings,
            onOpenClip: (clip) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      EditorScreen(clipId: clip.id, clipName: clip.name),
                ),
              );
            },
          ),
        ),
      );

      if (updatedMovie == null || !mounted) {
        return;
      }

      final updatedProject = project.copyWith(animeMovie: updatedMovie);

      projectController.updateProject(updatedProject);

      return;
    }
  }

  // ============================================================
  // DOWNLOAD PROJECT
  // ============================================================

  void _downloadProject(ProjectModel project) {
    // Download workflow will be connected later.
    debugPrint('Download project: ${project.name}');
  }

  @override
  void dispose() {
    projectController.removeListener(_onProjectsChanged);
    projectController.dispose();
    super.dispose();
  }

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
          icon: const Text(
            '☰',
            style: TextStyle(fontSize: 28, color: Colors.black, height: 1),
          ),
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
                  builder: (_) =>
                      SearchUI(projectController: projectController),
                ),
              );
            },
            icon: const Text('🔍', style: TextStyle(fontSize: 30)),
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

              // ======================================================
              // PROJECT GRID
              // ======================================================
              Expanded(
                child: _ProjectContent(
                  selectedTab: _selectedTab,
                  projects: _projectsForSelectedTab(),
                  emojiBuilder: _emojiForProject,
                  onEdit: _editProject,
                  onDelete: _deleteProject,
                  onDownload: _downloadProject,
                ),
              ),
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
        onProjectCreated: _onProjectCreated,
      ),
    );
  }
}

// ================================================================
// PROJECT CONTENT
// ================================================================

class _ProjectContent extends StatelessWidget {
  final int selectedTab;
  final List<ProjectModel> projects;
  final String Function(ProjectModel) emojiBuilder;
  final void Function(ProjectModel) onEdit;
  final void Function(ProjectModel) onDelete;
  final void Function(ProjectModel) onDownload;

  const _ProjectContent({
    required this.selectedTab,
    required this.projects,
    required this.emojiBuilder,
    required this.onEdit,
    required this.onDelete,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> cards = [];

    // ============================================================
    // EXISTING DEMO CARDS
    // ============================================================

    if (selectedTab == 0 || selectedTab == 1) {
      cards.add(
        const ProjectCard(
          imageAsset: 'assets/screen.png',
          projectName: 'Boxing Demo',
        ),
      );
    }

    if (selectedTab == 2 || selectedTab == 3) {
      cards.add(
        const ProjectCard(
          imageAsset: 'assets/screen13.png',
          projectName: 'Manga Conversation Demo',
        ),
      );
    }

    // ============================================================
    // CREATED PROJECTS
    // ============================================================

    for (final project in projects) {
      cards.add(
        ProjectCardUI(
          title: project.name,
          emoji: emojiBuilder(project),
          onEdit: () => onEdit(project),
          onDelete: () => onDelete(project),
          onDownload: () => onDownload(project),
        ),
      );
    }

    // ============================================================
    // CONTENT
    // ============================================================

    if (cards.isEmpty) {
      return const _EmptyProjectState();
    }

    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180,
        mainAxisExtent: 185,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
        childAspectRatio: 1,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return cards[index];
      },
    );
  }
}

// ================================================================
// EMPTY PROJECT STATE
// ================================================================

class _EmptyProjectState extends StatelessWidget {
  const _EmptyProjectState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('📁', style: TextStyle(fontSize: 48)),

          const SizedBox(height: 12),

          const Text(
            'No projects yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Create a project to get started.',
            style: TextStyle(fontSize: 13, color: Color(0xff777777)),
          ),
        ],
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
              Text(data.icon, style: const TextStyle(fontSize: 22)),

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
  final String icon;
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
          icon: '📺',
          color: Color(0xff7C3AED),
        );

      case 1:
        return const _CategoryData(
          title: 'Movies',
          description: 'Create and manage long-form animated movies.',
          icon: '🎬',
          color: Color(0xffE11D48),
        );

      case 2:
        return const _CategoryData(
          title: 'Manga',
          description: 'Create and organize manga series and pages.',
          icon: '📚',
          color: Color(0xff0EA5E9),
        );

      case 3:
        return const _CategoryData(
          title: 'Book',
          description: 'Create and manage standalone manga books.',
          icon: '📖',
          color: Color(0xff16A34A),
        );

      default:
        return const _CategoryData(
          title: 'Movies',
          description: 'Create and manage long-form animated movies.',
          icon: '🎬',
          color: Color(0xffE11D48),
        );
    }
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
  final ValueChanged<ProjectModel> onProjectCreated;

  const HomeBottomBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
    required this.onProjectCreated,
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
                icon: '📺',
                title: "Series",
                color: const Color(0xff7C3AED),
                selected: selectedTab == 0,
                onTap: () => onTabSelected(0),
              ),
            ),

            Expanded(
              child: _BottomItem(
                icon: '🎬',
                title: "Movies",
                color: const Color(0xffE11D48),
                selected: selectedTab == 1,
                onTap: () => onTabSelected(1),
              ),
            ),

            // Center create button uses the same width as every
            // other navigation slot, so there is no large gap.
            Expanded(
              child: Center(
                child: CreateProjectButton(onProjectCreated: onProjectCreated),
              ),
            ),

            Expanded(
              child: _BottomItem(
                icon: '📚',
                title: "Manga",
                color: const Color(0xff0EA5E9),
                selected: selectedTab == 2,
                onTap: () => onTabSelected(2),
              ),
            ),

            Expanded(
              child: _BottomItem(
                icon: '📖',
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
// DEMO PROJECT CARD
// ================================================================

class ProjectCard extends StatelessWidget {
  final String imageAsset;
  final String projectName;

  const ProjectCard({
    super.key,
    required this.imageAsset,
    required this.projectName,
  });

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
                imageAsset,
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

          Center(
            child: Text(
              projectName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// BOTTOM NAV ITEM
// ================================================================

class _BottomItem extends StatelessWidget {
  final String icon;
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
                child: Text(icon, style: const TextStyle(fontSize: 23)),
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
