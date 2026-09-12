import 'package:flutter/material.dart';

import 'package:flutter_application_1/home/drawer_ui.dart';
import 'package:flutter_application_1/core/app_media.dart';
import 'package:flutter_application_1/core/app_theme.dart';
import 'package:flutter_application_1/search/search_ui.dart';

import 'create_project_button.dart';
import 'project_controller.dart';
import 'project_scope.dart';
import 'models/project_model.dart';
import 'project_card_ui.dart';

import 'package:flutter_application_1/home/anime/seasons_ui.dart';
import 'package:flutter_application_1/home/anime/movie_clips_ui.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({
    super.key,
  });

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  // ============================================================
  // 0 = Series
  // 1 = Movies
  // 2 = Manga
  // 3 = Book
  //
  // Movies is the default tab.
  // ============================================================

  int _selectedTab = 1;

  // Used only to detect when a completely different project
  // becomes the current project.
  //
  // Project data itself is NOT stored here.
  String? _lastKnownProjectId;

  // ============================================================
  // PROJECT CONTEXT
  // ============================================================

  ProjectController get projectController =>
      ProjectScope.read(context);

  // ============================================================
  // DEPENDENCY CHANGES
  // ============================================================

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final controller = ProjectScope.of(context);

    final currentProjectId = controller.currentProjectId;

    // Settings/name/list updates for the SAME project should
    // simply rebuild through ProjectScope.
    if (currentProjectId == _lastKnownProjectId) {
      return;
    }

    _lastKnownProjectId = currentProjectId;

    final project = controller.currentProject;

    if (project == null) {
      return;
    }

    final tab = _tabForProjectType(project.projectType);

    if (_selectedTab == tab) {
      return;
    }

    setState(() {
      _selectedTab = tab;
    });
  }

  // ============================================================
  // TAB FOR PROJECT TYPE
  // ============================================================

  int _tabForProjectType(ProjectType type) {
    switch (type) {
      case ProjectType.animeSeries:
        return 0;

      case ProjectType.animeMovie:
        return 1;
    }
  }

  // ============================================================
  // PROJECTS FOR SELECTED CATEGORY
  // ============================================================

  List<ProjectModel> _projectsForSelectedTab(
    ProjectController controller,
  ) {
    switch (_selectedTab) {
      case 0:
        return controller.animeSeriesProjects;

      case 1:
        return controller.animeMovieProjects;

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
  }

  // ============================================================
  // OPEN PROJECT
  // ============================================================

  Future<void> _editProject(ProjectModel project) async {
    final controller = ProjectScope.read(context);

    final selected = controller.selectProject(project.id);

    if (!selected) {
      return;
    }

    // Always get the project again from ProjectController.
    final selectedProject = controller.currentProject;

    if (selectedProject == null) {
      return;
    }

    switch (selectedProject.projectType) {
      // ========================================================
      // ANIME SERIES
      // ========================================================

      case ProjectType.animeSeries:
        if (selectedProject.animeSeries == null) {
          return;
        }

        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const SeasonsScreen(),
          ),
        );

        break;

      // ========================================================
      // ANIME MOVIE
      // ========================================================

      case ProjectType.animeMovie:
        if (selectedProject.animeMovie == null) {
          return;
        }

        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const MovieClipsScreen(),
          ),
        );

        break;
    }
  }

  // ============================================================
  // DOWNLOAD PROJECT
  // ============================================================

  void _downloadProject(ProjectModel project) {
    // Download workflow will be connected later.
    debugPrint(
      'Download project: ${project.name}',
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    AppMedia.init(context);

    // Flutter/Chrome can briefly report an extremely small
    // window width during resize or browser transitions.
    //
    // Do not wrap the entire Scaffold in LayoutBuilder.
    // That was unnecessary and made the widget tree more complex.
    final screenWidth = MediaQuery.sizeOf(context).width;

    if (screenWidth < 120) {
      return const SizedBox.shrink();
    }

    // ProjectScope.of() makes this widget rebuild whenever
    // ProjectController calls notifyListeners().
    final controller = ProjectScope.of(context);

    final projects = _projectsForSelectedTab(controller);

    AppThemeScope.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // ==========================================================
      // TOP APP BAR
      // ==========================================================

      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        titleSpacing: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const DrawerUI(),
              ),
            );
          },
          icon: Text(
            '☰',
            style: TextStyle(
              fontSize: 28,
              color: colorScheme.onSurface,
              height: 1,
            ),
          ),
        ),

        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'AnimeClip',
            maxLines: 1,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
              letterSpacing: -.3,
            ),
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchUI(
                    projectController: controller,
                  ),
                ),
              );
            },
            icon: const Text(
              '🔍',
              style: TextStyle(
                fontSize: 26,
              ),
            ),
          ),
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: colorScheme.outlineVariant,
          ),
        ),
      ),

      // ==========================================================
      // MIDDLE CONTENT
      // ==========================================================

      body: SafeArea(
        child: Padding(
          padding: AppMedia.symmetric(
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              _SelectedCategorySection(
                selectedTab: _selectedTab,
              ),

              const SizedBox(height: 20),

              Expanded(
                child: _ProjectContent(
                  selectedTab: _selectedTab,
                  projects: projects,
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

      // ==========================================================
      // BOTTOM NAVIGATION
      // ==========================================================

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

    // ==========================================================
    // EXISTING DEMO CARDS
    // ==========================================================

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

    // ==========================================================
    // CREATED PROJECTS
    // ==========================================================

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

    // ==========================================================
    // EMPTY
    // ==========================================================

    if (cards.isEmpty) {
      return const _EmptyProjectState();
    }

    // ==========================================================
    // GRID
    // ==========================================================

    return LayoutBuilder(
      builder: (context, constraints) {
        // Prevent grid construction during an extremely small
        // transient width.
        if (!constraints.hasBoundedWidth ||
            constraints.maxWidth < 120) {
          return const SizedBox.shrink();
        }

        final crossAxisCount =
            ((constraints.maxWidth + 16) / 196)
                .floor()
                .clamp(1, 6)
                .toInt();

        return GridView.builder(
          padding: const EdgeInsets.only(
            bottom: 20,
          ),
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: 185,
            crossAxisSpacing: 16,
            mainAxisSpacing: 20,
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            return cards[index];
          },
        );
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
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '📁',
            style: TextStyle(
              fontSize: 48,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No projects yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Create a project to get started.',
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
            ),
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

  const _SelectedCategorySection({
    required this.selectedTab,
  });

  @override
  Widget build(BuildContext context) {
    final data = _CategoryData.fromIndex(
      selectedTab,
    );

    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 2,
          ),
          child: Row(
            children: [
              Text(
                data.icon,
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                data.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 2,
          ),
          child: Text(
            data.description,
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Divider(
          height: 1,
          thickness: 1,
          color: colorScheme.outlineVariant,
        ),
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

  const _CategoryData({
    required this.title,
    required this.description,
    required this.icon,
  });

  static _CategoryData fromIndex(
    int index,
  ) {
    switch (index) {
      case 0:
        return const _CategoryData(
          title: 'Series',
          description:
              'Create and organize episodic anime projects.',
          icon: '📺',
        );

      case 1:
        return const _CategoryData(
          title: 'Movies',
          description:
              'Create and manage long-form animated movies.',
          icon: '🎬',
        );

      case 2:
        return const _CategoryData(
          title: 'Manga',
          description:
              'Create and organize manga series and pages.',
          icon: '📚',
        );

      case 3:
        return const _CategoryData(
          title: 'Book',
          description:
              'Create and manage standalone manga books.',
          icon: '📖',
        );

      default:
        return const _CategoryData(
          title: 'Movies',
          description:
              'Create and manage long-form animated movies.',
          icon: '🎬',
        );
    }
  }
}

// ================================================================
// CREATE BUTTON
// ================================================================

class CreateBottomItem extends StatelessWidget {
  const CreateBottomItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.add,
        color: colorScheme.onPrimary,
        size: 34,
      ),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 82,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: _BottomItem(
                icon: '📺',
                title: 'Series',
                selected: selectedTab == 0,
                onTap: () => onTabSelected(0),
              ),
            ),
            Expanded(
              child: _BottomItem(
                icon: '🎬',
                title: 'Movies',
                selected: selectedTab == 1,
                onTap: () => onTabSelected(1),
              ),
            ),
            Expanded(
              child: Center(
                child: const CreateProjectButton(),
              ),
            ),
            Expanded(
              child: _BottomItem(
                icon: '📚',
                title: 'Manga',
                selected: selectedTab == 2,
                onTap: () => onTabSelected(2),
              ),
            ),
            Expanded(
              child: _BottomItem(
                icon: '📖',
                title: 'Book',
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
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 185,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: double.infinity,
            height: 120,
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: colorScheme.outlineVariant,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(
                      alpha: 0.06,
                    ),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  imageAsset,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) {
                    return Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 40,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 40,
            child: Text(
              projectName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
                height: 1.25,
              ),
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
  final bool selected;
  final VoidCallback onTap;

  const _BottomItem({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(
                  milliseconds: 180,
                ),
                curve: Curves.easeOut,
                width: selected ? 38 : 0,
                height: 3,
                margin: const EdgeInsets.only(
                  bottom: 4,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              AnimatedScale(
                scale: selected ? 1.08 : 1.0,
                duration: const Duration(
                  milliseconds: 180,
                ),
                child: Text(
                  icon,
                  style: const TextStyle(
                    fontSize: 23,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  color: selected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  fontWeight: selected
                      ? FontWeight.w700
                      : FontWeight.w600,
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
  const RecentSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 2,
          ),
          child: Text(
            'Recent',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Divider(
          height: 1,
          thickness: 1,
          color: colorScheme.outlineVariant,
        ),
      ],
    );
  }
}