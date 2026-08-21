import 'package:flutter/foundation.dart';

import 'models/project_model.dart';

class ProjectController extends ChangeNotifier {
  ProjectController({
    List<ProjectModel> initialProjects = const [],
  }) : _projects = List<ProjectModel>.from(initialProjects);

  final List<ProjectModel> _projects;

  // ============================================================
  // ALL PROJECTS
  // ============================================================

  List<ProjectModel> get projects => List.unmodifiable(_projects);

  int get projectCount => _projects.length;

  // ============================================================
  // ANIME SERIES
  // ============================================================

  List<ProjectModel> get animeSeriesProjects {
    return List.unmodifiable(
      _projects.where(
        (project) => project.projectType == ProjectType.animeSeries,
      ),
    );
  }

  // ============================================================
  // ANIME MOVIES
  // ============================================================

  List<ProjectModel> get animeMovieProjects {
    return List.unmodifiable(
      _projects.where(
        (project) => project.projectType == ProjectType.animeMovie,
      ),
    );
  }

  // ============================================================
  // CREATE
  // ============================================================

  void addProject(ProjectModel project) {
    _projects.add(project);
    notifyListeners();
  }

  // ============================================================
  // READ
  // ============================================================

  ProjectModel? getProjectById(String projectId) {
    for (final project in _projects) {
      if (project.id == projectId) {
        return project;
      }
    }

    return null;
  }

  // ============================================================
  // DELETE
  // ============================================================

  bool deleteProject(String projectId) {
    final index = _projects.indexWhere(
      (project) => project.id == projectId,
    );

    if (index == -1) {
      return false;
    }

    _projects.removeAt(index);
    notifyListeners();

    return true;
  }

  // ============================================================
  // UPDATE
  // ============================================================

  bool updateProject(ProjectModel updatedProject) {
    final index = _projects.indexWhere(
      (project) => project.id == updatedProject.id,
    );

    if (index == -1) {
      return false;
    }

    _projects[index] = updatedProject;
    notifyListeners();

    return true;
  }

  // ============================================================
  // CLEAR
  // ============================================================

  void clearProjects() {
    if (_projects.isEmpty) {
      return;
    }

    _projects.clear();
    notifyListeners();
  }
}