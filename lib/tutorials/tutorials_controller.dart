import 'package:flutter/material.dart';

class TutorialItem {
  final String title;
  final String description;
  final String duration;
  final String level;
  final IconData icon;
  final bool completed;
  final int progress;
  final String category;

  const TutorialItem({
    required this.title,
    required this.description,
    required this.duration,
    required this.level,
    required this.icon,
    required this.category,
    this.completed = false,
    this.progress = 0,
  });
}

class TutorialCategory {
  final String name;
  final IconData icon;

  const TutorialCategory({
    required this.name,
    required this.icon,
  });
}

class TutorialsController extends ChangeNotifier {
  final List<TutorialCategory> categories = const [
    TutorialCategory(
      name: '12 Principles',
      icon: Icons.movie_creation_outlined,
    ),
    TutorialCategory(
      name: 'Animation Techniques',
      icon: Icons.movie_outlined,
    ),
    TutorialCategory(
      name: 'Manga Techniques',
      icon: Icons.auto_stories_outlined,
    ),
  ];

  final List<TutorialItem> tutorials = const [
    // ================= 12 PRINCIPLES =================

    TutorialItem(
      title: 'Squash & Stretch',
      description:
          'Give a sense of weight and volume to drawn objects in motion.',
      duration: '08:42',
      level: 'Beginner',
      icon: Icons.movie_creation_outlined,
      category: '12 Principles',
      progress: 100,
    ),
    TutorialItem(
      title: 'Anticipation',
      description:
          'Prepare the audience for a major action the character is about to perform.',
      duration: '06:15',
      level: 'Beginner',
      icon: Icons.movie_outlined,
      category: '12 Principles',
      progress: 0,
    ),
    TutorialItem(
      title: 'Staging',
      description:
          "Directing the audience's attention to the most important element in a scene.",
      duration: '09:30',
      level: 'Beginner',
      icon: Icons.local_movies_outlined,
      category: '12 Principles',
      progress: 50,
    ),
    TutorialItem(
      title: 'Straight Ahead & Pose to Pose',
      description:
          'Explore two fundamental approaches to planning and creating animated movement.',
      duration: '10:18',
      level: 'Beginner',
      icon: Icons.movie_creation_outlined,
      category: '12 Principles',
      progress: 0,
    ),
    TutorialItem(
      title: 'Follow Through & Overlapping Action',
      description:
          'Make movement feel natural by allowing parts of a character or object to continue moving and overlap.',
      duration: '11:05',
      level: 'Beginner',
      icon: Icons.movie_outlined,
      category: '12 Principles',
      progress: 0,
    ),
    TutorialItem(
      title: 'Slow In & Slow Out',
      description:
          'Create smoother movement by gradually accelerating into and out of an action.',
      duration: '07:26',
      level: 'Beginner',
      icon: Icons.slow_motion_video_outlined,
      category: '12 Principles',
      progress: 0,
    ),
    TutorialItem(
      title: 'Arcs',
      description:
          'Create natural movement by following curved paths instead of rigid straight-line motion.',
      duration: '08:54',
      level: 'Beginner',
      icon: Icons.gesture_outlined,
      category: '12 Principles',
      progress: 0,
    ),
    TutorialItem(
      title: 'Secondary Action',
      description:
          'Add supporting actions that strengthen the main action without taking attention away from it.',
      duration: '09:12',
      level: 'Intermediate',
      icon: Icons.animation_outlined,
      category: '12 Principles',
      progress: 0,
    ),
    TutorialItem(
      title: 'Timing',
      description:
          'Use timing to control the speed, weight, rhythm, and feeling of movement.',
      duration: '12:08',
      level: 'Intermediate',
      icon: Icons.schedule_outlined,
      category: '12 Principles',
      progress: 0,
    ),
    TutorialItem(
      title: 'Exaggeration',
      description:
          'Push poses and actions to make movement, emotion, and storytelling clearer.',
      duration: '07:48',
      level: 'Intermediate',
      icon: Icons.auto_awesome_outlined,
      category: '12 Principles',
      progress: 0,
    ),
    TutorialItem(
      title: 'Solid Drawing',
      description:
          'Build believable forms with strong volume, balance, perspective, and construction.',
      duration: '13:20',
      level: 'Intermediate',
      icon: Icons.draw_outlined,
      category: '12 Principles',
      progress: 0,
    ),
    TutorialItem(
      title: 'Appeal',
      description:
          'Create characters and scenes that are visually interesting, expressive, and memorable.',
      duration: '10:44',
      level: 'Intermediate',
      icon: Icons.star_outline_rounded,
      category: '12 Principles',
      progress: 0,
    ),

    // ================= ANIMATION TECHNIQUES =================

    TutorialItem(
      title: 'Keyframe Animation',
      description:
          'Learn how to define important poses and let the animation flow between them.',
      duration: '09:20',
      level: 'Beginner',
      icon: Icons.key_outlined,
      category: 'Animation Techniques',
      progress: 0,
    ),
    TutorialItem(
      title: 'Frame-by-Frame Animation',
      description:
          'Create movement by drawing individual frames for detailed and expressive animation.',
      duration: '12:35',
      level: 'Beginner',
      icon: Icons.layers_outlined,
      category: 'Animation Techniques',
      progress: 0,
    ),
    TutorialItem(
      title: 'Walk Cycles',
      description:
          'Build a convincing walking animation by understanding contact, passing, and recoil poses.',
      duration: '14:10',
      level: 'Beginner',
      icon: Icons.directions_walk_outlined,
      category: 'Animation Techniques',
      progress: 0,
    ),
    TutorialItem(
      title: 'Lip Sync Animation',
      description:
          'Sync mouth shapes and facial movement with spoken dialogue for believable character acting.',
      duration: '11:42',
      level: 'Intermediate',
      icon: Icons.record_voice_over_outlined,
      category: 'Animation Techniques',
      progress: 0,
    ),
    TutorialItem(
      title: 'Character Acting',
      description:
          'Use poses, expressions, gestures, and timing to communicate emotion and personality.',
      duration: '15:05',
      level: 'Intermediate',
      icon: Icons.theater_comedy_outlined,
      category: 'Animation Techniques',
      progress: 0,
    ),

    // ================= MANGA TECHNIQUES =================

    TutorialItem(
      title: 'Character Design',
      description:
          'Learn how to build memorable manga characters through silhouettes, proportions, clothing, and visual details.',
      duration: '12:20',
      level: 'Beginner',
      icon: Icons.person_outline,
      category: 'Manga Techniques',
      progress: 0,
    ),
    TutorialItem(
      title: 'Manga Facial Expressions',
      description:
          'Create expressive faces using eyes, eyebrows, mouths, and simplified manga expression techniques.',
      duration: '10:15',
      level: 'Beginner',
      icon: Icons.face_retouching_natural_outlined,
      category: 'Manga Techniques',
      progress: 0,
    ),
    TutorialItem(
      title: 'Manga Paneling',
      description:
          'Learn how to arrange panels to control pacing, composition, and the flow of a manga page.',
      duration: '11:30',
      level: 'Beginner',
      icon: Icons.dashboard_outlined,
      category: 'Manga Techniques',
      progress: 0,
    ),
    TutorialItem(
      title: 'Manga Perspective',
      description:
          'Use perspective to construct convincing environments, rooms, characters, and dynamic camera angles.',
      duration: '14:05',
      level: 'Intermediate',
      icon: Icons.view_in_ar_outlined,
      category: 'Manga Techniques',
      progress: 0,
    ),
    TutorialItem(
      title: 'Speed Lines & Effects',
      description:
          'Add impact, motion, atmosphere, and dramatic energy with manga speed lines and visual effects.',
      duration: '09:48',
      level: 'Intermediate',
      icon: Icons.flash_on_outlined,
      category: 'Manga Techniques',
      progress: 0,
    ),
  ];

  int _selectedCategory = 0;

  int get selectedCategory => _selectedCategory;

  List<TutorialItem> get selectedTutorials {
    final selectedCategoryName = categories[_selectedCategory].name;

    return tutorials
        .where(
          (tutorial) => tutorial.category == selectedCategoryName,
        )
        .toList();
  }

  void selectCategory(int index) {
    if (index < 0 ||
        index >= categories.length ||
        index == _selectedCategory) {
      return;
    }

    _selectedCategory = index;
    notifyListeners();
  }

  void openTutorial(TutorialItem tutorial) {
    debugPrint('Opening tutorial: ${tutorial.title}');
  }
}