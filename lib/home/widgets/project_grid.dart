import 'package:flutter/material.dart';
import 'package:flutter_application_1/anime_editor/clipsystem/clip_setup_screen.dart';
import 'package:flutter_application_1/anime_editor/models/project_model.dart';
import 'package:flutter_application_1/manga_editor/screens/manga_editor_screen.dart';

class ProjectsView extends StatelessWidget {
  final List<Map<String, dynamic>> projects;
  final bool isTablet;
  final ValueChanged<List<Map<String, dynamic>>> onProjectsChanged;

  const ProjectsView({
    super.key,
    required this.projects,
    required this.isTablet,
    required this.onProjectsChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (projects.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 90, color: Colors.grey),
            SizedBox(height: 15),
            Text(
              "No Projects Yet",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
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
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
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

            if (!context.mounted) return;

            if (selected == "edit") {
              final updatedProject = await navigator.push(
                MaterialPageRoute(
                  builder: (_) => project["type"] == "manga"
                      ? MangaEditorScreen(
                          projectName: project["name"],
                          pages: project["pages"] ?? 1,
                          size: project["size"] ?? "A4",
                        )
                      : ClipSetupScreen(
  project: ProjectModel(
    id: project["id"] ??
        DateTime.now()
            .millisecondsSinceEpoch
            .toString(),
    name: project["name"],
    type: "anime",
    ratio: project["ratio"] ?? "16:9",
    projectType: project["projectType"] ?? "series",
    fps: project["fps"] ?? 12,
    seasons: [],
    clips: [],
  ),
),
                ),
              );

              if (!context.mounted) return;

              if (updatedProject != null &&
                  updatedProject is Map<String, dynamic>) {
                final updated = List<Map<String, dynamic>>.from(projects);
                updated[index] = updatedProject;
                onProjectsChanged(updated);
              }
            }

            if (selected == "delete") {
              final updated = List<Map<String, dynamic>>.from(projects);
              updated.removeAt(index);
              onProjectsChanged(updated);
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
                        project["type"] == "anime"
                            ? Icons.movie_creation_outlined
                            : Icons.menu_book_outlined,
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
                                '${project["ratio"]} • ${project["fps"]} FPS • ${project["clips"]?.length ?? 1} Clips',
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
}