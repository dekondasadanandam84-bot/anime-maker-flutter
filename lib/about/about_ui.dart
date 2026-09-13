import 'package:flutter/material.dart';
import 'about_controller.dart';

class AboutUI extends StatelessWidget {
  final AboutController controller;

  const AboutUI({super.key, required this.controller});

  Widget _title(
    BuildContext context,
    String text, {
    Color? color,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Text(
      text,
      style: TextStyle(
        color: color ?? scheme.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _body(
    BuildContext context,
    String text, {
    Color? color,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Text(
      text,
      style: TextStyle(
        color: color ?? scheme.onSurfaceVariant,
        fontSize: 14,
        height: 1.45,
      ),
    );
  }

  Widget _stat(
    BuildContext context,
    String label,
    String value,
  ) {
    final scheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: scheme.outlineVariant),
          borderRadius: BorderRadius.circular(8),
          color: scheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: scheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeline(
    BuildContext context,
    String number,
    String title,
    String text,
  ) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 48),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => controller.onTimelinePressed(number),
            borderRadius: BorderRadius.circular(9999),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(
                  color: scheme.outlineVariant,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(9999),
                color: scheme.surface,
              ),
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 12,
                  color: scheme.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title(context, title),
                const SizedBox(height: 7),
                _body(context, text),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 72, 16, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text(
                          'AnimeClip',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Built from one developer's idea into a complete\n"
                          'creative platform.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: scheme.onSurfaceVariant,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 96),
                  Row(
                    children: [
                      _stat(context, 'ACTIVE DEVELOPERS', '1'),
                      const SizedBox(width: 16),
                      _stat(context, 'MODEL', 'Solo'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _stat(context, 'STATUS', 'In Development'),
                      const SizedBox(width: 16),
                      _stat(context, 'VISION', 'Creative Ecosystem'),
                    ],
                  ),
                  const SizedBox(height: 96),
                  Container(
                    padding: const EdgeInsets.only(bottom: 48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 5,
                          ),
                          margin: const EdgeInsets.only(bottom: 23),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: scheme.outlineVariant,
                            ),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 4,
                                backgroundColor: scheme.primary,
                              ),
                              const SizedBox(width: 7),
                              Text(
                                'SOLO DEVELOPER',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: scheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _title(context, 'An Independent Journey'),
                        const SizedBox(height: 23),
                        _body(
                          context,
                          'AnimeClip is designed, programmed, and continuously refined by a single person. '
                          'This independent approach ensures a cohesive vision, where every feature and UI '
                          'element is crafted with focused intent, prioritizing quality over speed.',
                        ),
                        const SizedBox(height: 32),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: scheme.outlineVariant,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: scheme.surfaceContainerLow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TEAM STRUCTURE',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: scheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _title(
                                context,
                                'No formal development team currently.',
                              ),
                              const SizedBox(height: 16),
                              _body(
                                context,
                                'While operating solo today, the architecture is built for scale. '
                                'It represents a focused, long-term vision intended to grow into a '
                                'collaborative ecosystem in the future.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: _title(context, 'How It Was Developed'),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: _body(
                      context,
                      'The chronological evolution of the AnimeClip platform.',
                    ),
                  ),
                  const SizedBox(height: 48),
                  _timeline(
                    context,
                    '01',
                    'Initial Idea',
                    'Conceptualizing a unified platform for animation workflows.',
                  ),
                  _timeline(
                    context,
                    '02',
                    'Product & UI Design',
                    'Establishing the minimalist, studio-grade aesthetic and user experience.',
                  ),
                  _timeline(
                    context,
                    '03',
                    'Flutter Development',
                    'Building the core engine for cross-platform performance.',
                  ),
                  _timeline(
                    context,
                    '04',
                    'Application Architecture',
                    'Structuring data: Project > Season > Episode > Clip.',
                  ),
                  _timeline(
                    context,
                    '05',
                    'Animation Systems',
                    'Integrating precise timeline and playback controls.',
                  ),
                  _timeline(
                    context,
                    '06',
                    'Continuous Improvement',
                    'Iterative refinement based on internal testing and feedback.',
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: scheme.primary,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title(
                          context,
                          'Why AnimeClip',
                          color: scheme.onPrimary,
                        ),
                        const SizedBox(height: 15),
                        _body(
                          context,
                          'To centralize the animation workflow. By removing the friction between disparate tools, '
                          'creators can focus entirely on the art of motion and storytelling in a distraction-free environment.',
                          color: scheme.onPrimary,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: scheme.outlineVariant,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: scheme.surface,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title(context, 'Vision & Future'),
                        const SizedBox(height: 15),
                        _body(
                          context,
                          'Building a robust creative ecosystem. While starting as a singular vision, the architecture '
                          'anticipates future team expansion, collaborative features, and a vibrant community of animators.',
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: scheme.outlineVariant,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: scheme.surfaceContainerLow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title(context, 'Contact Us'),
                        const SizedBox(height: 15),
                        _body(
                          context,
                          'Facing any bugs, issues, crashes, or unexpected behavior while using AnimeClip? '
                          'Contact us and report the problem so it can be investigated and improved.',
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: controller.contactUs,
                            icon: const Icon(Icons.bug_report_outlined),
                            label: const Text('Report a Bug or Issue'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: scheme.primary,
                              foregroundColor: scheme.onPrimary,
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 12,
              left: 16,
              child: Material(
                color: scheme.surface,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: scheme.outlineVariant,
                      ),
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 22,
                      color: scheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
