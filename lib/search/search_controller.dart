
import 'package:flutter/material.dart';
import 'package:flutter_application_1/templates/templates_controller.dart';

class AnimeClipSearchController extends ChangeNotifier {
  final TextEditingController searchController =
      TextEditingController();

  final TemplatesController templatesController =
      TemplatesController();

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

  /// Searches the existing AnimeClip templates.
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

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    templatesController.dispose();
    super.dispose();
  }
}

