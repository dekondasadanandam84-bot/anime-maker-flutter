import 'package:flutter/foundation.dart';

class HelpGuideController extends ChangeNotifier {
  HelpGuideController() : categories = _buildCategories();

  final List<HelpGuideCategory> categories;
  
  int? _expandedIndex;

  
  int? get expandedIndex => _expandedIndex;

  

  

  void toggleFaq(int index) {
    _expandedIndex = _expandedIndex == index ? null : index;
    notifyListeners();
  }

  
}

class HelpGuideVisibleFaq {
  const HelpGuideVisibleFaq({required this.category, required this.faq, required this.globalIndex});
  final String category;
  final HelpGuideFaqItem faq;
  final int globalIndex;
}

class HelpGuideCategory {
  const HelpGuideCategory({required this.title, required this.items});
  final String title;
  final List<HelpGuideFaqItem> items;
}

class HelpGuideFaqItem {
  const HelpGuideFaqItem({
    required this.question,
    required this.blocks,
    this.isWarning = false,
  });

  final String question;
  final List<HelpGuideAnswerBlock> blocks;
  final bool isWarning;
}

enum HelpGuideAnswerBlockType { heading, paragraph, bullet, number, structure }

class HelpGuideAnswerBlock {
  const HelpGuideAnswerBlock.heading(this.text) : type = HelpGuideAnswerBlockType.heading, number = null;
  const HelpGuideAnswerBlock.paragraph(this.text) : type = HelpGuideAnswerBlockType.paragraph, number = null;
  const HelpGuideAnswerBlock.bullet(this.text) : type = HelpGuideAnswerBlockType.bullet, number = null;
  const HelpGuideAnswerBlock.number(this.number, this.text) : type = HelpGuideAnswerBlockType.number;
  const HelpGuideAnswerBlock.structure(this.text) : type = HelpGuideAnswerBlockType.structure, number = null;
  final HelpGuideAnswerBlockType type;
  final String text;
  final int? number;
}

List<HelpGuideCategory> _buildCategories() {
  return [
    HelpGuideCategory(
      title: 'PROJECTS',
      items: [
        HelpGuideFaqItem(
          question: 'What are the 4 types of projects?',
          
          blocks: [
            const HelpGuideAnswerBlock.paragraph('AnimeClip supports four project types, each designed for a different creative workflow.'),
            const HelpGuideAnswerBlock.heading('1. Anime Series'),
            const HelpGuideAnswerBlock.paragraph('Anime Series projects are designed for episodic animated content. A series can contain multiple seasons, each season can contain multiple episodes, and each episode can contain many clips. Each clip contains its own animation frames.'),
            const HelpGuideAnswerBlock.structure('Anime Series → Seasons → Episodes → Clips → Frames'),
            const HelpGuideAnswerBlock.paragraph('This structure keeps a long-running anime organized instead of placing the entire series into one enormous timeline.'),
            const HelpGuideAnswerBlock.heading('2. Anime Movie'),
            const HelpGuideAnswerBlock.paragraph('Anime Movie projects are designed for a single long-form animated movie. A movie does not require seasons or episodes; clips are created directly inside the movie. This is useful for movies that can run for a long time, including projects that may be hours long.'),
            const HelpGuideAnswerBlock.structure('Anime Movie → Clips → Frames'),
            const HelpGuideAnswerBlock.heading('3. Manga Series'),
            const HelpGuideAnswerBlock.paragraph('Manga Series projects are designed for manga containing multiple books. A series can contain multiple books, and each book is organized into screens and pages.'),
            const HelpGuideAnswerBlock.structure('Manga Series → Books → Screens → Pages'),
            const HelpGuideAnswerBlock.heading('4. Manga Book'),
            const HelpGuideAnswerBlock.paragraph('Manga Book projects are designed for one standalone book. Pages are created directly inside the book. Pages can be organized as sets, with 10 pages forming one page set.'),
            const HelpGuideAnswerBlock.structure('Manga Book → Pages'),
          ],
        ),
        HelpGuideFaqItem(
          question: 'How does the workflow work for each project type?',
          
          blocks: [
            const HelpGuideAnswerBlock.heading('Anime Series'),
            const HelpGuideAnswerBlock.structure('Project → Season → Episode → Clip → Frames'),
            const HelpGuideAnswerBlock.paragraph('Create the Anime Series project, add one or more seasons, create multiple episodes inside each season, and create multiple clips inside each episode. The animation frames are edited inside the clips.'),
            const HelpGuideAnswerBlock.heading('Anime Movie'),
            const HelpGuideAnswerBlock.structure('Project → Clips → Frames'),
            const HelpGuideAnswerBlock.paragraph('Create the movie project and add clips directly. A movie can contain many clips because long-form movies can be divided into manageable production sections.'),
            const HelpGuideAnswerBlock.heading('Manga Series'),
            const HelpGuideAnswerBlock.structure('Project → Books → Screens → Pages'),
            const HelpGuideAnswerBlock.paragraph('Create the series, add multiple books, and organize each book through screens and pages. This is intended for manga projects containing multiple books or volumes.'),
            const HelpGuideAnswerBlock.heading('Manga Book'),
            const HelpGuideAnswerBlock.structure('Project → Pages'),
            const HelpGuideAnswerBlock.paragraph('Create a standalone book and work directly with its pages. Pages can be organized into sets of 10 pages for easier navigation and management.'),
          ],
        ),
      ],
    ),
    HelpGuideCategory(
      title: 'PLAYBACK',
      items: [
        HelpGuideFaqItem(
          question: 'How does episode playback work?',
          
          blocks: [
            const HelpGuideAnswerBlock.paragraph('Episode playback combines all clips belonging to an episode into one continuous playback sequence.'),
            const HelpGuideAnswerBlock.structure('Clip 1 → Clip 2 → Clip 3 → Clip 4'),
            const HelpGuideAnswerBlock.paragraph('The clips are played according to their configured order. The creator does not need to manually open and play every clip separately.'),
            const HelpGuideAnswerBlock.paragraph('This allows an episode to remain divided into manageable clips while still behaving like one continuous episode during playback.'),
          ],
        ),
      ],
    ),
    HelpGuideCategory(
      title: 'COLLABORATION',
      items: [
        HelpGuideFaqItem(
          question: 'How does the Collaboration system actually work?',
                    blocks: [
            const HelpGuideAnswerBlock.paragraph('AnimeClip collaboration allows multiple users to participate in the same project, but drawing on a canvas is controlled so that changes do not conflict.'),
            const HelpGuideAnswerBlock.heading('One active drawing user at a time'),
            const HelpGuideAnswerBlock.paragraph('Only one user can actively draw/edit a canvas at a time. Other users can still participate in the overall project and work on their assigned areas.'),
            const HelpGuideAnswerBlock.heading('Work assignment'),
            const HelpGuideAnswerBlock.paragraph('Users can join the whole project and can be assigned specific work by selecting the appropriate screen or work area.'),
            const HelpGuideAnswerBlock.heading('Clip collaboration limit'),
            const HelpGuideAnswerBlock.paragraph('A maximum of 5 users can be assigned to a clip. This keeps work organized and prevents too many users from being assigned to the same production unit.'),
            const HelpGuideAnswerBlock.structure('Project → Assigned work → Screens / Clips'),
          ],
        ),
        HelpGuideFaqItem(
          question: 'Is AnimeClip collaboration-friendly?',
          
          blocks: [
            const HelpGuideAnswerBlock.paragraph('Yes. AnimeClip is designed to support collaborative production by dividing large projects into manageable production units.'),
            const HelpGuideAnswerBlock.heading('Anime production'),
            const HelpGuideAnswerBlock.structure('Seasons → Episodes → Clips'),
            const HelpGuideAnswerBlock.paragraph('Teams can divide anime production across multiple seasons, episodes, and clips so different users can focus on different parts of a larger production.'),
            const HelpGuideAnswerBlock.heading('Manga production'),
            const HelpGuideAnswerBlock.structure('Books → Screens → Pages'),
            const HelpGuideAnswerBlock.paragraph('Manga projects can similarly be divided across books, screens, and pages.'),
            const HelpGuideAnswerBlock.paragraph('The collaboration system is well suited to larger projects where work can be assigned and organized instead of requiring every user to edit the same canvas simultaneously.'),
          ],
        ),
      ],
    ),
    HelpGuideCategory(
      title: 'BACKUP & EXPORT',
      items: [
        HelpGuideFaqItem(
          question: 'How do I back up a project?',
          
          blocks: [
            const HelpGuideAnswerBlock.paragraph('AnimeClip projects can be backed up by exporting the project as an AnimeClip project file.'),
            const HelpGuideAnswerBlock.structure('[Your Project Name].ac'),
            const HelpGuideAnswerBlock.paragraph('The .ac file is intended to preserve the editable AnimeClip project and can be kept as an external backup.'),
            const HelpGuideAnswerBlock.heading('Importing a project'),
            const HelpGuideAnswerBlock.structure('Import Project → Select the .ac file → Import'),
            const HelpGuideAnswerBlock.paragraph('Cloud Sync is a separate AnimeClip feature available to Go Plus users only. Important projects should still have independent backup copies whenever possible.'),
          ],
        ),
        HelpGuideFaqItem(
          question: 'What are the different types of exports?',
          
          blocks: [
            const HelpGuideAnswerBlock.heading('1. Project File'),
            const HelpGuideAnswerBlock.structure('[Your Project Name].ac'),
            const HelpGuideAnswerBlock.paragraph('The project file is used to preserve the editable AnimeClip project. It can later be imported through Import Project.'),
            const HelpGuideAnswerBlock.heading('2. Final Output'),
            const HelpGuideAnswerBlock.paragraph('Final output is intended for the finished result.'),
            const HelpGuideAnswerBlock.bullet('MP4 — for animated/video output.'),
            const HelpGuideAnswerBlock.bullet('PDF — for manga/book output.'),
            const HelpGuideAnswerBlock.paragraph('The key difference is: the project file preserves the editable project, while the final output is intended for viewing or distribution.'),
          ],
        ),
      ],
    ),
    HelpGuideCategory(
      title: 'CLOUD & SAFETY',
      items: [
        HelpGuideFaqItem(
          question: 'What should I use for cloud backup?',
          
          blocks: [
            const HelpGuideAnswerBlock.paragraph('For important AnimeClip project backups, use a reliable cloud-storage service.'),
            const HelpGuideAnswerBlock.heading('Recommended backup option'),
            const HelpGuideAnswerBlock.structure('Google Drive'),
            const HelpGuideAnswerBlock.paragraph('Google Drive can be used to store important .ac project files outside the phone. Other reputable third-party cloud-storage services can also be used when appropriate.'),
            const HelpGuideAnswerBlock.heading('Recommended backup approach'),
            const HelpGuideAnswerBlock.structure('Original project + Local backup + Cloud backup'),
            const HelpGuideAnswerBlock.paragraph('Do not depend on only one copy of an important project. Cloud Sync inside AnimeClip is separate and is available to Go Plus users only.'),
          ],
        ),
      ],
    ),
  ];
}
