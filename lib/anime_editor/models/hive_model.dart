import 'project_model.dart';

class HiveModel {
  final String id;

  String name;

  List<ProjectModel> projects;

  int selectedProjectIndex;

  HiveModel({
    required this.id,
    required this.name,
    required this.projects,
    this.selectedProjectIndex = 0,
  });

  /// Currently selected project
  ProjectModel get currentProject {
    if (projects.isEmpty) {
      throw Exception("No projects found.");
    }

    return projects[selectedProjectIndex];
  }

  /// Change selected project
  void selectProject(int index) {
    if (index < 0 || index >= projects.length) return;

    selectedProjectIndex = index;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "selectedProjectIndex": selectedProjectIndex,
      "projects": projects.map((project) => project.toJson()).toList(),
    };
  }

  factory HiveModel.fromJson(Map<String, dynamic> json) {
    return HiveModel(
      id: json["id"],
      name: json["name"],
      selectedProjectIndex: json["selectedProjectIndex"] ?? 0,
      projects: (json["projects"] as List? ?? [])
          .map((e) => ProjectModel.fromJson(e))
          .toList(),
    );
  }
}