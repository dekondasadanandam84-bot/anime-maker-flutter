import 'package:flutter/material.dart';

import 'create_project_screen.dart';
import 'project_controller.dart';
import 'project_scope.dart';

class CreateProjectButton extends StatelessWidget {
  const CreateProjectButton({
    super.key,
  });

  void _openCreateProjectSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (_) {
        return const _CreateProjectSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openCreateProjectSheet(context),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 58,
        height: 58,
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
    );
  }
}

class _CreateProjectSheet extends StatelessWidget {
  const _CreateProjectSheet();

  void _selectProjectType(
    BuildContext context,
    CreateProjectOption type,
  ) {
    final projectController =
        ProjectScope.read(context);

    Navigator.of(context).pop();

    switch (type) {
      case CreateProjectOption.animeSeries:
        projectController.beginCreateProject(
          ProjectFlowType.animeSeries,
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                const CreateProjectScreen(),
          ),
        );
        break;

      case CreateProjectOption.animeMovie:
        projectController.beginCreateProject(
          ProjectFlowType.animeMovie,
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                const CreateProjectScreen(),
          ),
        );
        break;

      case CreateProjectOption.mangaSeries:
        projectController.beginCreateProject(
          ProjectFlowType.mangaSeries,
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                const CreateProjectScreen(),
          ),
        );
        break;

      case CreateProjectOption.mangaBook:
        projectController.beginCreateProject(
          ProjectFlowType.mangaBook,
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                const CreateProjectScreen(),
          ),
        );
        break;

      case CreateProjectOption.importProject:
        debugPrint('Import Project');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight:
              MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6D6D6),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Create Project',
                style: TextStyle(
                  color: Color(0xFF1A1C1C),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Choose a project type',
                style: TextStyle(
                  color: Color(0xFF6B6B6B),
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 20),

              _CreateProjectOption(
                icon: '📺',
                iconColor:
                    const Color(0xff7C3AED),
                title: 'Anime Series',
                description:
                    'Create an episodic anime project with seasons and episodes.',
                onTap: () => _selectProjectType(
                  context,
                  CreateProjectOption.animeSeries,
                ),
              ),

              const SizedBox(height: 10),

              _CreateProjectOption(
                icon: '🎬',
                iconColor:
                    const Color(0xffE11D48),
                title: 'Anime Movie',
                description:
                    'Create a long-form animated movie project.',
                onTap: () => _selectProjectType(
                  context,
                  CreateProjectOption.animeMovie,
                ),
              ),

              const SizedBox(height: 10),

              _CreateProjectOption(
                icon: '📚',
                iconColor:
                    const Color(0xff0EA5E9),
                title: 'Manga Series',
                description:
                    'Create a manga series containing multiple books.',
                onTap: () => _selectProjectType(
                  context,
                  CreateProjectOption.mangaSeries,
                ),
              ),

              const SizedBox(height: 10),

              _CreateProjectOption(
                icon: '📖',
                iconColor:
                    const Color(0xff16A34A),
                title: 'Manga Book',
                description:
                    'Create a standalone manga book project.',
                onTap: () => _selectProjectType(
                  context,
                  CreateProjectOption.mangaBook,
                ),
              ),

              const SizedBox(height: 10),

              _CreateProjectOption(
                icon: '📤',
                iconColor:
                    const Color(0xFFF59E0B),
                title: 'Import Project',
                description:
                    'Import an existing AnimeClip project file.',
                onTap: () => _selectProjectType(
                  context,
                  CreateProjectOption.importProject,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateProjectOption
    extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _CreateProjectOption({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding:
              const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            border: Border.all(
              color: const Color(0xFFE5E5E5),
            ),
            borderRadius:
                BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Text(
                  icon,
                  style: const TextStyle(
                    fontSize: 27,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          const TextStyle(
                        color:
                            Color(0xFF1A1C1C),
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      description,
                      style:
                          const TextStyle(
                        color:
                            Color(0xFF6B6B6B),
                        fontSize: 12.5,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF777777),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum CreateProjectOption {
  animeSeries,
  animeMovie,
  mangaSeries,
  mangaBook,
  importProject,
}