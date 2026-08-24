import 'package:flutter/material.dart';
import 'package:flutter_application_1/templates/templates_controller.dart';
import 'package:flutter_application_1/tutorials/tutorials_controller.dart';

import '../home/project_controller.dart';
import '../home/models/project_model.dart';

class AnimeClipSearchController extends ChangeNotifier {
  AnimeClipSearchController({
    required this.projectController,
  });

  final ProjectController projectController;

  final TextEditingController searchController = TextEditingController();

  final TemplatesController templatesController = TemplatesController();

  final TutorialsController tutorialsController = TutorialsController();

  String _query = '';

  String get query => _query;

  bool get hasQuery => _query.trim().isNotEmpty;

  void init() {
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _query = searchController.text;
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
  }

  // =============================================================
  // PROJECT SEARCH
  // =============================================================

  List<ProjectModel> get projects {
    if (!hasQuery) {
      return [];
    }

    final searchQuery = _query.trim().toLowerCase();

    return projectController.projects.where((project) {
      return project.name.toLowerCase().contains(searchQuery);
    }).toList();
  }

  // =============================================================
  // TEMPLATE SEARCH
  // =============================================================

  List<TemplateModel> get templates {
    if (!hasQuery) {
      return [];
    }

    final query = _query.trim().toLowerCase();

    return templatesController.templates.where((template) {
      return template.title.toLowerCase().contains(query) ||
          template.description.toLowerCase().contains(query);
    }).toList();
  }

  // =============================================================
  // TUTORIAL SEARCH
  // =============================================================

  List<TutorialItem> get tutorials {
    if (!hasQuery) {
      return [];
    }

    final query = _query.trim().toLowerCase();

    return tutorialsController.tutorials.where((tutorial) {
      return tutorial.title.toLowerCase().contains(query) ||
          tutorial.description.toLowerCase().contains(query) ||
          tutorial.category.toLowerCase().contains(query) ||
          tutorial.level.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();

    // Do NOT dispose projectController.
    // It belongs to HomeUI.

    templatesController.dispose();
    tutorialsController.dispose();

    super.dispose();
  }
}
