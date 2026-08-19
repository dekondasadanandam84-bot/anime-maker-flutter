import 'package:flutter/material.dart';
import 'about_controller.dart';

class AboutUI extends StatelessWidget {
  final AboutController controller;

  const AboutUI({super.key, required this.controller});

  Widget _title(String text, {Color color = Colors.black}) => Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget _body(String text, {Color color = const Color(0xFF4C4546)}) =>
      Text(
        text,
        style: TextStyle(color: color, fontSize: 14, height: 1.45),
      );

  Widget _stat(String label, String value) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFCFC4C5)),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF4C4546))),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      );

  Widget _timeline(String number, String title, String text) => Padding(
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
                  border: Border.all(color: const Color(0xFFCFC4C5), width: 2),
                  borderRadius: BorderRadius.circular(9999),
                  color: Colors.white,
                ),
                child: Text(number, style: const TextStyle(fontSize: 12)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title(title),
                  const SizedBox(height: 7),
                  _body(text),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
  child: Stack(
    children: [
      SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 72, 16, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    'AnimeClip',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Built from one developer's idea into a complete\ncreative platform.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF4C4546),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 96),

            Row(
              children: [
                _stat('ACTIVE DEVELOPERS', '1'),
                const SizedBox(width: 16),
                _stat('MODEL', 'Solo'),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                _stat('STATUS', 'In Development'),
                const SizedBox(width: 16),
                _stat('VISION', 'Creative Ecosystem'),
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
                        color: const Color(0xFFCFC4C5),
                      ),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 4,
                          backgroundColor: Colors.black,
                        ),
                        SizedBox(width: 7),
                        Text(
                          'SOLO DEVELOPER',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  _title('An Independent Journey'),
                  const SizedBox(height: 23),
                  _body(
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
                        color: const Color(0xFFCFC4C5),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFFF3F3F4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TEAM STRUCTURE',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        _title(
                          'No formal development team currently.',
                        ),
                        const SizedBox(height: 16),
                        _body(
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
              child: _title('How It Was Developed'),
            ),
            const SizedBox(height: 15),

            Center(
              child: _body(
                'The chronological evolution of the AnimeClip platform.',
              ),
            ),
            const SizedBox(height: 48),

            _timeline(
              '01',
              'Initial Idea',
              'Conceptualizing a unified platform for animation workflows.',
            ),
            _timeline(
              '02',
              'Product & UI Design',
              'Establishing the minimalist, studio-grade aesthetic and user experience.',
            ),
            _timeline(
              '03',
              'Flutter Development',
              'Building the core engine for cross-platform performance.',
            ),
            _timeline(
              '04',
              'Application Architecture',
              'Structuring data: Project > Season > Episode > Clip.',
            ),
            _timeline(
              '05',
              'Animation Systems',
              'Integrating precise timeline and playback controls.',
            ),
            _timeline(
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
                color: Colors.black,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title(
                    'Why AnimeClip',
                    color: Colors.white,
                  ),
                  const SizedBox(height: 15),
                  _body(
                    'To centralize the animation workflow. By removing the friction between disparate tools, '
                    'creators can focus entirely on the art of motion and storytelling in a distraction-free environment.',
                    color: Colors.white,
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
                  color: const Color(0xFFCFC4C5),
                ),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title('Vision & Future'),
                  const SizedBox(height: 15),
                  _body(
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
                  color: const Color(0xFFCFC4C5),
                ),
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFF3F3F4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title('Contact Us'),
                  const SizedBox(height: 15),
                  _body(
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
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
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

      // Back button
      Positioned(
        top: 12,
        left: 16,
        child: Material(
          color: Colors.white,
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
                  color: const Color(0xFFCFC4C5),
                ),
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 22,
                color: Colors.black,
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
