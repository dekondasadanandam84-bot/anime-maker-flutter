import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/anime/movie_clips_ui.dart';
import 'package:flutter_application_1/home/anime/seasons_ui.dart';
import 'package:flutter_application_1/home/models/project_model.dart';
import 'package:flutter_application_1/home/project_controller.dart';
import 'package:flutter_application_1/tutorials/tutorials_controller.dart';
import 'search_controller.dart';
import 'package:flutter_application_1/templates/templates_controller.dart';

class SearchUI extends StatefulWidget {
  final ProjectController projectController;

  const SearchUI({super.key, required this.projectController});

  @override
  State<SearchUI> createState() => _SearchUIState();
}

class _SearchUIState extends State<SearchUI> {
  late final AnimeClipSearchController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimeClipSearchController(
      projectController: widget.projectController,
    );

    controller.init();

    controller.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.removeListener(_onSearchChanged);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // =====================================================
            // SEARCH HEADER
            // =====================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F4),
                        border: Border.all(color: const Color(0xFFCFC4C5)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 14),

                          const Icon(
                            Icons.search,
                            size: 21,
                            color: Colors.grey,
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: TextField(
                              controller: controller.searchController,
                              autofocus: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search AnimeClip...",
                                hintStyle: TextStyle(
                                  color: Color(0xFF777777),
                                  fontSize: 16,
                                ),
                              ),
                              style: const TextStyle(
                                color: Color(0xFF1A1C1C),
                                fontSize: 16,
                              ),
                            ),
                          ),

                          if (controller.hasQuery)
                            GestureDetector(
                              onTap: controller.clearSearch,
                              child: const Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Icon(
                                  Icons.close,
                                  size: 19,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Color(0xFF1A1C1C),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // =====================================================
            // DIVIDER
            // =====================================================
            const Divider(height: 1, thickness: 1, color: Color(0xFFEAEAEA)),

            // =====================================================
            // CONTENT
            // =====================================================
            Expanded(
              child: controller.hasQuery
                  ? _SearchResults(controller: controller)
                  : const _SearchEmptyState(),
            ),
          ],
        ),
      ),
    );
  }
}

// ===============================================================
// EMPTY SEARCH STATE
// ===============================================================

class _SearchEmptyState extends StatelessWidget {
  const _SearchEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Search AnimeClip",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Find projects, tutorials, templates and more.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ===============================================================
// SEARCH RESULTS
// ===============================================================

class _SearchResults extends StatelessWidget {
  final AnimeClipSearchController controller;

  const _SearchResults({required this.controller});

  @override
  Widget build(BuildContext context) {
    final projects = controller.projects;
    final templates = controller.templates;
    final tutorials = controller.tutorials;

    if (projects.isEmpty && templates.isEmpty && tutorials.isEmpty) {
      return const Center(
        child: Text(
          "No results found",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      children: [
        // ===========================================================
        // PROJECTS
        // ===========================================================
        if (projects.isNotEmpty) ...[
          const Text(
            "Projects",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 12),

          ...projects.map(
            (project) => _ProjectSearchResultCard(
              project: project,
              projectController: controller.projectController,
            ),
          ),

          const SizedBox(height: 28),
        ],

        // ===========================================================
        // TEMPLATES
        // ===========================================================
        if (templates.isNotEmpty) ...[
          const Text(
            "Templates",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 12),

          ...templates.map(
            (template) =>
                _TemplateResultCard(template: template, controller: controller),
          ),
        ],

        if (templates.isNotEmpty && tutorials.isNotEmpty)
          const SizedBox(height: 28),

        // ===========================================================
        // TUTORIALS
        // ===========================================================
        if (tutorials.isNotEmpty) ...[
          const Text(
            "Tutorials",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 12),

          ...tutorials.map(
            (tutorial) =>
                _TutorialResultCard(tutorial: tutorial, controller: controller),
          ),
        ],
      ],
    );
  }
}

// ===============================================================
// TEMPLATE RESULT CARD
// ===============================================================

class _TemplateResultCard extends StatelessWidget {
  final TemplateModel template;
  final AnimeClipSearchController controller;

  const _TemplateResultCard({required this.template, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            controller.templatesController.useTemplate(template);
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    template.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) {
                      return Container(
                        width: 60,
                        height: 60,
                        color: const Color(0xFFF4F4F4),
                        child: const Icon(
                          Icons.image_outlined,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        template.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  template.duration,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TutorialResultCard extends StatelessWidget {
  final TutorialItem tutorial;
  final AnimeClipSearchController controller;

  const _TutorialResultCard({required this.tutorial, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            controller.tutorialsController.openTutorial(tutorial);
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(tutorial.icon, size: 28, color: Colors.black),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tutorial.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        tutorial.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          height: 1.35,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        '${tutorial.category} • ${tutorial.duration}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectSearchResultCard extends StatelessWidget {
  final ProjectModel project;
  final ProjectController projectController;

  const _ProjectSearchResultCard({
    required this.project,
    required this.projectController,
  });

  String _projectEmoji() {
    switch (project.projectType) {
      case ProjectType.animeSeries:
        return '📺';

      case ProjectType.animeMovie:
        return '🎬';
    }
  }


  String _projectTypeName() {
    switch (project.projectType) {
      case ProjectType.animeSeries:
        return 'Anime Series';

      case ProjectType.animeMovie:
        return 'Anime Movie';
    }
  }

  void _openProject(BuildContext context) {
  final selected = projectController.selectProject(
    project.id,
  );

  if (!selected) {
    return;
  }

  // ===========================================================
  // ANIME SERIES
  // ===========================================================

  if (project.projectType == ProjectType.animeSeries &&
      project.animeSeries != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SeasonsScreen(),
      ),
    );

    return;
  }

  // ===========================================================
  // ANIME MOVIE
  // ===========================================================

  if (project.projectType == ProjectType.animeMovie &&
      project.animeMovie != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MovieClipsScreen(),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _openProject(context),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // PROJECT ICON
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      _projectEmoji(),
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // PROJECT DETAILS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        _projectTypeName(),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        '${project.settings.fps} FPS',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
