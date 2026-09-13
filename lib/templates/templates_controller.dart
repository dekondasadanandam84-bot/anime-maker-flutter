import 'package:flutter/material.dart';

enum TemplateCategory {
  all,
  anime,
  manga,
}

class TemplateModel {
  final String title;
  final String description;
  final String image;
  final String duration;
  final TemplateCategory category;

  const TemplateModel({
    required this.title,
    required this.description,
    required this.image,
    required this.duration,
    required this.category,
  });

  bool get isAnime => category == TemplateCategory.anime;
  bool get isManga => category == TemplateCategory.manga;
}

class TemplatesController extends ChangeNotifier {
  TemplatesController();

  TemplateCategory _selectedCategory = TemplateCategory.manga;
  TemplateModel? _lastSelectedTemplate;

  final List<TemplateModel> _templates = const [
    // -----------------------------------------------------------------------
    // Anime templates — existing screen1.png ... screen10.png assets.
    // -----------------------------------------------------------------------
    TemplateModel(
      title: 'Walk Cycle',
      description: 'Smooth character walking loop.',
      duration: '2s',
      image: 'assets/templates/screen9.png',
      category: TemplateCategory.anime,
    ),
    TemplateModel(
      title: 'Run Cycle',
      description: 'Basic running animation.',
      duration: '1s',
      image: 'assets/templates/screen5.png',
      category: TemplateCategory.anime,
    ),
    TemplateModel(
      title: 'Jump',
      description: 'Takeoff and landing animation.',
      duration: '1s',
      image: 'assets/templates/screen1.png',
      category: TemplateCategory.anime,
    ),
    TemplateModel(
      title: 'Idle',
      description: 'Breathing idle pose.',
      duration: '4s',
      image: 'assets/templates/screen8.png',
      category: TemplateCategory.anime,
    ),
    TemplateModel(
      title: 'Talking',
      description: 'Simple mouth movement cycle.',
      duration: '3s',
      image: 'assets/templates/screen7.png',
      category: TemplateCategory.anime,
    ),
    TemplateModel(
      title: 'Wave',
      description: 'Friendly hand waving.',
      duration: '2s',
      image: 'assets/templates/screen10.png',
      category: TemplateCategory.anime,
    ),
    TemplateModel(
      title: 'Punch',
      description: 'Quick punch action.',
      duration: '1s',
      image: 'assets/templates/screen3.png',
      category: TemplateCategory.anime,
    ),
    TemplateModel(
      title: 'Kick',
      description: 'Basic kick animation.',
      duration: '1s',
      image: 'assets/templates/screen2.png',
      category: TemplateCategory.anime,
    ),
    TemplateModel(
      title: 'Turn Around',
      description: '180-degree character turn.',
      duration: '2s',
      image: 'assets/templates/screen4.png',
      category: TemplateCategory.anime,
    ),
    TemplateModel(
      title: 'Blink',
      description: 'Natural eye blinking loop.',
      duration: '2s',
      image: 'assets/templates/screen6.png',
      category: TemplateCategory.anime,
    ),

    // -----------------------------------------------------------------------
    // Manga templates — named from the 1.png ... 10.png pages supplied.
    // -----------------------------------------------------------------------
    TemplateModel(
      title: 'Two Boys Introduction',
      description: 'Introduce two boys with balanced portraits and dialogue.',
      duration: '',
      image: 'assets/templates/1.png',
      category: TemplateCategory.manga,
    ),
    TemplateModel(
      title: 'Two Boys Dialogue',
      description: 'Natural manga panel flow for a conversation between two boys.',
      duration: '',
      image: 'assets/templates/2.png',
      category: TemplateCategory.manga,
    ),
    TemplateModel(
      title: 'Two Boys Argument',
      description: 'Dramatic composition for conflict between two boys.',
      duration: '',
      image: 'assets/templates/3.png',
      category: TemplateCategory.manga,
    ),
    TemplateModel(
      title: 'Two Boys Friendship',
      description: 'Friendly slice-of-life layout for two boys.',
      duration: '',
      image: 'assets/templates/4.png',
      category: TemplateCategory.manga,
    ),
    TemplateModel(
      title: 'Two Boys Emotional Scene',
      description: 'Spacious layout for meaningful emotional moments between two boys.',
      duration: '',
      image: 'assets/templates/5.png',
      category: TemplateCategory.manga,
    ),
    TemplateModel(
      title: 'Two Boys Battle',
      description: 'Dynamic manga layout for an intense battle between two boys.',
      duration: '',
      image: 'assets/templates/6.png',
      category: TemplateCategory.manga,
    ),
    TemplateModel(
      title: 'Two Boys Rivalry',
      description: 'Mirrored composition for two rival boys facing each other.',
      duration: '',
      image: 'assets/templates/7.png',
      category: TemplateCategory.manga,
    ),
    TemplateModel(
      title: 'Two Boys Mystery',
      description: 'Suspenseful manga layout for two boys solving a mystery.',
      duration: '',
      image: 'assets/templates/8.png',
      category: TemplateCategory.manga,
    ),
    TemplateModel(
      title: 'Two Boys Comedy',
      description: 'Fast-paced comedy layout built around two boys and their reactions.',
      duration: '',
      image: 'assets/templates/9.png',
      category: TemplateCategory.manga,
    ),
    TemplateModel(
      title: 'Two Boys Dramatic Finale',
      description: 'Cinematic manga composition for a major moment between two boys.',
      duration: '',
      image: 'assets/templates/10.png',
      category: TemplateCategory.manga,
    ),
  ];

  List<TemplateModel> get templates => List.unmodifiable(_templates);

  TemplateCategory get selectedCategory => _selectedCategory;

  TemplateModel? get lastSelectedTemplate => _lastSelectedTemplate;

  int get allCount => _templates.length;

  int get animeCount =>
      _templates.where((template) => template.isAnime).length;

  int get mangaCount =>
      _templates.where((template) => template.isManga).length;

  int get selectedCount {
    switch (_selectedCategory) {
      case TemplateCategory.all:
        return allCount;
      case TemplateCategory.anime:
        return animeCount;
      case TemplateCategory.manga:
        return mangaCount;
    }
  }

  List<TemplateModel> get visibleTemplates {
    switch (_selectedCategory) {
      case TemplateCategory.all:
        return List.unmodifiable(_templates);
      case TemplateCategory.anime:
        return List.unmodifiable(
          _templates.where((template) => template.isAnime),
        );
      case TemplateCategory.manga:
        return List.unmodifiable(
          _templates.where((template) => template.isManga),
        );
    }
  }

  void setCategory(TemplateCategory category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    notifyListeners();
  }

  void useTemplate(TemplateModel template) {
    _lastSelectedTemplate = template;
    debugPrint('Selected template: ${template.title}');

    // Future integration point:
    // 1. Create/open the appropriate project.
    // 2. Import the template frames/page layout.
    // 3. Open the Editor/Manga editor.
    notifyListeners();
  }

  void init() {}
}
