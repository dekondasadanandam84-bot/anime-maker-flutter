import 'package:flutter/material.dart';

import 'tutorials_controller.dart';

class TutorialsScreen extends StatefulWidget {
  const TutorialsScreen({super.key});

  @override
  State<TutorialsScreen> createState() => _TutorialsScreenState();
}

class _TutorialsScreenState extends State<TutorialsScreen> {
  late final TutorialsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TutorialsController();
    _controller.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),

              _buildCategoryBar(),
              const SizedBox(height: 48),
              _buildPrinciplesSection(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
              const Expanded(
                child: Text(
                  'Learn. Animate. Create.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1A1C1C),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 16),
          const SizedBox(
            width: 353,
            child: Text(
              'Master the art of animation and manga\n'
              'creation with our comprehensive, studio-grade\n'
              'tutorials designed for creators of all levels.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF4C4546),
                fontSize: 16,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _controller.categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = _controller.categories[index];
          final selected = index == _controller.selectedCategory;

          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => _controller.selectCategory(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: selected ? Colors.black : const Color(0xFFF9F9F9),
                border: Border.all(
                  color: selected ? Colors.black : const Color(0xFFE2E2E2),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    category.icon,
                    size: 16,
                    color: selected ? Colors.white : const Color(0xFF4C4546),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    category.name,
                    style: TextStyle(
                      color: selected ? Colors.white : const Color(0xFF1A1C1C),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPrinciplesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _controller.categories[_controller.selectedCategory].name ==
                    '12 Principles'
                ? '12 Principles of Animation'
                : _controller.categories[_controller.selectedCategory].name,
            style: const TextStyle(
              color: Color(0xFF1A1C1C),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _controller.categories[_controller.selectedCategory].name ==
                    '12 Principles'
                ? 'The foundational rules every animator must know,\n'
                      'straight from the masters.'
                : _controller.categories[_controller.selectedCategory].name ==
                      'Animation Techniques'
                ? 'Practical techniques for creating clear, expressive animation.'
                : 'Essential manga techniques for characters, pages, and visual storytelling.',
            style: const TextStyle(
              color: Color(0xFF4C4546),
              fontSize: 14,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 24),
          ..._controller.selectedTutorials.map(_buildTutorialCard),
        ],
      ),
    );
  }

  Widget _buildTutorialCard(TutorialItem tutorial) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E2E2)),
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTutorialPreview(tutorial),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tutorial.title,
                        style: const TextStyle(
                          color: Color(0xFF1A1C1C),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (tutorial.completed)
                      _pill(
                        text: 'Completed',
                        background: Colors.black,
                        foreground: Colors.white,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  tutorial.description,
                  style: const TextStyle(
                    color: Color(0xFF4C4546),
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialPreview(TutorialItem tutorial) {
    return InkWell(
      onTap: () => _controller.openTutorial(tutorial),
      child: Column(
        children: [
          Container(
            height: 190,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFEDEDED), Color(0xFFD7D7D7)],
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE2E2E2)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _tutorialNumber(tutorial),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.80),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tutorial.duration,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          LinearProgressIndicator(
            value: tutorial.progress / 100,
            minHeight: 4,
            backgroundColor: const Color(0xFFE2E2E2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        ],
      ),
    );
  }

  String _tutorialNumber(TutorialItem tutorial) {
    final index = _controller.tutorials.indexOf(tutorial);
    return (index + 1).toString().padLeft(2, '0');
  }

  Widget _pill({
    required String text,
    required Color background,
    required Color foreground,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: TextStyle(color: foreground, fontSize: 12)),
    );
  }
}
