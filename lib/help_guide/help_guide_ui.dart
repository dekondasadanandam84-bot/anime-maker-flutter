import 'package:flutter/material.dart';

class HelpGuideUi extends StatefulWidget {
  const HelpGuideUi({super.key});

  @override
  State<HelpGuideUi> createState() => _HelpGuideUiState();
}

class _HelpGuideUiState extends State<HelpGuideUi> {
  final List<_FaqCategory> _categories = _buildCategories();
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: true,
        title: const Text(
          'Help & Guide',
          style: TextStyle(
            color: Colors.green,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFE2E2E2)),
        ),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    isWide ? 48 : 16,
                    32,
                    isWide ? 48 : 16,
                    48,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1280),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Learn how AnimeClip projects, playback, collaboration, backup, and exports work.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF4C4546),
                                fontSize: 14,
                                height: 1.45,
                              ),
                            ),
                            const _BackupWarningCard(),
                            const SizedBox(height: 32),
                            if (isWide)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 210,
                                    child: _DesktopCategoryNav(
                                      categories: _categories,
                                    ),
                                  ),
                                  const SizedBox(width: 32),
                                  Expanded(
                                    child: _FaqList(
                                      categories: _categories,
                                      expandedIndex: _expandedIndex,
                                      onToggle: _toggleFaq,
                                    ),
                                  ),
                                ],
                              )
                            else
                              _FaqList(
                                categories: _categories,
                                expandedIndex: _expandedIndex,
                                onToggle: _toggleFaq,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _toggleFaq(int index) {
    setState(() {
      _expandedIndex = _expandedIndex == index ? null : index;
    });
  }
}

class _BackupWarningCard extends StatelessWidget {
  const _BackupWarningCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E5),
        border: Border.all(color: const Color(0xFFF0C36D)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFBA1A1A),
            size: 24,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Before You Uninstall or Change Phones',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Back up or download all required .ac project files and store them safely in cloud storage before uninstalling AnimeClip or changing your phone. Verify that your backup is accessible.',
                  style: TextStyle(
                    color: Color(0xFF4C4546),
                    fontSize: 14,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'You can delete MP4 exports if you do not need the existing rendered videos. On a new device, download or import the backed-up .ac project file and create a brand-new MP4 from the project.',
                  style: TextStyle(
                    color: Color(0xFF4C4546),
                    fontSize: 14,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopCategoryNav extends StatelessWidget {
  const _DesktopCategoryNav({
    required this.categories,
  });

  final List<_FaqCategory> categories;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Color(0xFFE2E2E2),
          ),
        ),
      ),
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final category in categories)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                category.title,
                style: const TextStyle(
                  color: Color(0xFF5E5E5E),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FaqList extends StatelessWidget {
  const _FaqList({
    required this.categories,
    required this.expandedIndex,
    required this.onToggle,
  });

  final List<_FaqCategory> categories;
  final int? expandedIndex;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    var globalIndex = 0;

    for (
      var categoryIndex = 0;
      categoryIndex < categories.length;
      categoryIndex++
    ) {
      final category = categories[categoryIndex];

      if (categoryIndex != 0) {
        children.add(const SizedBox(height: 40));
      }

      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            category.title,
            style: const TextStyle(
              color: Color(0xFF5E5E5E),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );

      for (final faq in category.items) {
  final cardIndex = globalIndex;

  children.add(
    _FaqCard(
      faq: faq,
      isExpanded: expandedIndex == cardIndex,
      onTap: () => onToggle(cardIndex),
    ),
  );

  globalIndex++;
}
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({
    required this.faq,
    required this.isExpanded,
    required this.onTap,
  });

  final _FaqItem faq;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFCFC4C5)),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        faq.question,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: faq.isWarning
                            ? const Color(0xFFBA1A1A)
                            : const Color(0xFF5E5E5E),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: _AnswerContent(faq: faq),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 280),
                sizeCurve: Curves.easeOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnswerContent extends StatelessWidget {
  const _AnswerContent({required this.faq});
  final _FaqItem faq;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, thickness: 1, color: Color(0xFFE2E2E2)),
          const SizedBox(height: 16),
          if (faq.isWarning) ...[
            Row(
              children: const [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 18,
                  color: Color(0xFFBA1A1A),
                ),
                SizedBox(width: 8),
                Text(
                  'Important Backup Warning',
                  style: TextStyle(
                    color: Color(0xFFBA1A1A),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
          for (final block in faq.blocks)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _AnswerBlock(block: block),
            ),
        ],
      ),
    );
  }
}

class _AnswerBlock extends StatelessWidget {
  const _AnswerBlock({required this.block});
  final _AnswerBlockData block;

  @override
  Widget build(BuildContext context) {
    switch (block.type) {
      case _AnswerBlockType.heading:
        return Text(
          block.text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            height: 1.45,
          ),
        );
      case _AnswerBlockType.paragraph:
        return Text(
          block.text,
          style: const TextStyle(
            color: Color(0xFF4C4546),
            fontSize: 14,
            height: 1.6,
          ),
        );
      case _AnswerBlockType.bullet:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 7),
              child: SizedBox(
                width: 5,
                height: 5,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFF5E5E5E),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                block.text,
                style: const TextStyle(
                  color: Color(0xFF4C4546),
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ),
          ],
        );
      case _AnswerBlockType.number:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${block.number}.',
              style: const TextStyle(
                color: Color(0xFF1A1C1C),
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.6,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                block.text,
                style: const TextStyle(
                  color: Color(0xFF4C4546),
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ),
          ],
        );
      case _AnswerBlockType.structure:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E2E2)),
          ),
          child: Text(
            block.text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        );
    }
  }
}

class _FaqCategory {
  const _FaqCategory({required this.title, required this.items});
  final String title;
  final List<_FaqItem> items;
}

class _FaqItem {
  const _FaqItem({
    required this.question,
    required this.blocks,
    required this.searchableAnswer,
    this.isWarning = false,
  });

  final String question;
  final List<_AnswerBlockData> blocks;
  final String searchableAnswer;
  final bool isWarning;
}

enum _AnswerBlockType { heading, paragraph, bullet, number, structure }

class _AnswerBlockData {
  const _AnswerBlockData.heading(this.text)
    : type = _AnswerBlockType.heading,
      number = null;

  const _AnswerBlockData.paragraph(this.text)
    : type = _AnswerBlockType.paragraph,
      number = null;

  const _AnswerBlockData.bullet(this.text)
    : type = _AnswerBlockType.bullet,
      number = null;

  const _AnswerBlockData.number(this.number, this.text)
    : type = _AnswerBlockType.number;

  const _AnswerBlockData.structure(this.text)
    : type = _AnswerBlockType.structure,
      number = null;

  final _AnswerBlockType type;
  final String text;
  final int? number;
}

List<_FaqCategory> _buildCategories() {
  return [
    _FaqCategory(
      title: 'PROJECTS',
      items: [
        _FaqItem(
          question: 'What are the 4 types of projects?',
          searchableAnswer:
              '''Anime Series. Anime Movie. Manga Series. Manga Book. Anime Series: Seasons, Episodes, Clips, Frames. Anime Movie: Clips, Frames. Manga Series: Books, Screens, Pages. Manga Book: Pages. Ten pages can be organized as one page set.''',
          blocks: [
            const _AnswerBlockData.paragraph(
              'AnimeClip supports four project types, each designed for a different creative workflow.',
            ),
            const _AnswerBlockData.heading('1. Anime Series'),
            const _AnswerBlockData.paragraph(
              'Anime Series projects are designed for episodic animated content. A series can contain multiple seasons, each season can contain multiple episodes, and each episode can contain many clips. Each clip contains its own animation frames.',
            ),
            const _AnswerBlockData.structure(
              'Anime Series → Seasons → Episodes → Clips → Frames',
            ),
            const _AnswerBlockData.paragraph(
              'This structure keeps a long-running anime organized instead of placing the entire series into one enormous timeline.',
            ),
            const _AnswerBlockData.heading('2. Anime Movie'),
            const _AnswerBlockData.paragraph(
              'Anime Movie projects are designed for a single long-form animated movie. A movie does not require seasons or episodes; clips are created directly inside the movie. This is useful for movies that can run for a long time, including projects that may be hours long.',
            ),
            const _AnswerBlockData.structure('Anime Movie → Clips → Frames'),
            const _AnswerBlockData.heading('3. Manga Series'),
            const _AnswerBlockData.paragraph(
              'Manga Series projects are designed for manga containing multiple books. A series can contain multiple books, and each book is organized into screens and pages.',
            ),
            const _AnswerBlockData.structure(
              'Manga Series → Books → Screens → Pages',
            ),
            const _AnswerBlockData.heading('4. Manga Book'),
            const _AnswerBlockData.paragraph(
              'Manga Book projects are designed for one standalone book. Pages are created directly inside the book. Pages can be organized as sets, with 10 pages forming one page set.',
            ),
            const _AnswerBlockData.structure('Manga Book → Pages'),
          ],
        ),
        _FaqItem(
          question: 'How does the workflow work for each project type?',
          searchableAnswer:
              '''Anime Series workflow project season episode clips frames. Multiple seasons. Multiple episodes per season. Many clips per episode. Anime Movie workflow project clips frames. Direct clips because a movie can be hours long. Manga Series workflow project books screens pages. Multiple books. Manga Book workflow project pages. Ten pages per set.''',
          blocks: [
            const _AnswerBlockData.heading('Anime Series'),
            const _AnswerBlockData.structure(
              'Project → Season → Episode → Clip → Frames',
            ),
            const _AnswerBlockData.paragraph(
              'Create the Anime Series project, add one or more seasons, create multiple episodes inside each season, and create multiple clips inside each episode. The animation frames are edited inside the clips.',
            ),
            const _AnswerBlockData.heading('Anime Movie'),
            const _AnswerBlockData.structure('Project → Clips → Frames'),
            const _AnswerBlockData.paragraph(
              'Create the movie project and add clips directly. A movie can contain many clips because long-form movies can be divided into manageable production sections.',
            ),
            const _AnswerBlockData.heading('Manga Series'),
            const _AnswerBlockData.structure(
              'Project → Books → Screens → Pages',
            ),
            const _AnswerBlockData.paragraph(
              'Create the series, add multiple books, and organize each book through screens and pages. This is intended for manga projects containing multiple books or volumes.',
            ),
            const _AnswerBlockData.heading('Manga Book'),
            const _AnswerBlockData.structure('Project → Pages'),
            const _AnswerBlockData.paragraph(
              'Create a standalone book and work directly with its pages. Pages can be organized into sets of 10 pages for easier navigation and management.',
            ),
          ],
        ),
      ],
    ),
    _FaqCategory(
      title: 'PLAYBACK',
      items: [
        _FaqItem(
          question: 'How does episode playback work?',
          searchableAnswer:
              '''Episode playback combines all clips belonging to an episode into one continuous playback sequence. Clips play according to their configured order. Clip 1, Clip 2, Clip 3. The episode does not require every clip to be edited on one timeline.''',
          blocks: [
            const _AnswerBlockData.paragraph(
              'Episode playback combines all clips belonging to an episode into one continuous playback sequence.',
            ),
            const _AnswerBlockData.structure(
              'Clip 1 → Clip 2 → Clip 3 → Clip 4',
            ),
            const _AnswerBlockData.paragraph(
              'The clips are played according to their configured order. The creator does not need to manually open and play every clip separately.',
            ),
            const _AnswerBlockData.paragraph(
              'This allows an episode to remain divided into manageable clips while still behaving like one continuous episode during playback.',
            ),
          ],
        ),
      ],
    ),
    _FaqCategory(
      title: 'COLLABORATION',
      items: [
        _FaqItem(
          question: 'How does the Collaboration system actually work?',
          searchableAnswer:
              '''Collaboration. One user can draw at a time. Users can join the whole project. Users can be assigned work by selecting a screen. Maximum 5 users per clip.''',
          blocks: [
            const _AnswerBlockData.paragraph(
              'AnimeClip collaboration allows multiple users to participate in the same project, but drawing on a canvas is controlled so that changes do not conflict.',
            ),
            const _AnswerBlockData.heading('One active drawing user at a time'),
            const _AnswerBlockData.paragraph(
              'Only one user can actively draw/edit a canvas at a time. Other users can still participate in the overall project and work on their assigned areas.',
            ),
            const _AnswerBlockData.heading('Work assignment'),
            const _AnswerBlockData.paragraph(
              'Users can join the whole project and can be assigned specific work by selecting the appropriate screen or work area.',
            ),
            const _AnswerBlockData.heading('Clip collaboration limit'),
            const _AnswerBlockData.paragraph(
              'A maximum of 5 users can be assigned to a clip. This keeps work organized and prevents too many users from being assigned to the same production unit.',
            ),
            const _AnswerBlockData.structure(
              'Project → Assigned work → Screens / Clips',
            ),
          ],
        ),
        _FaqItem(
          question: 'Is AnimeClip collaboration-friendly?',
          searchableAnswer:
              '''AnimeClip collaboration friendly. Multiple seasons, episodes, clips, books, screens, pages. Teams can focus on different production units.''',
          blocks: [
            const _AnswerBlockData.paragraph(
              'Yes. AnimeClip is designed to support collaborative production by dividing large projects into manageable production units.',
            ),
            const _AnswerBlockData.heading('Anime production'),
            const _AnswerBlockData.structure('Seasons → Episodes → Clips'),
            const _AnswerBlockData.paragraph(
              'Teams can divide anime production across multiple seasons, episodes, and clips so different users can focus on different parts of a larger production.',
            ),
            const _AnswerBlockData.heading('Manga production'),
            const _AnswerBlockData.structure('Books → Screens → Pages'),
            const _AnswerBlockData.paragraph(
              'Manga projects can similarly be divided across books, screens, and pages.',
            ),
            const _AnswerBlockData.paragraph(
              'The collaboration system is well suited to larger projects where work can be assigned and organized instead of requiring every user to edit the same canvas simultaneously.',
            ),
          ],
        ),
      ],
    ),
    _FaqCategory(
      title: 'BACKUP & EXPORT',
      items: [
        _FaqItem(
          question: 'How do I back up a project?',
          searchableAnswer:
              '''Backup project. Export project file. .ac file. Example project name.ac. Import Project. Cloud Sync available for Go Plus users only.''',
          blocks: [
            const _AnswerBlockData.paragraph(
              'AnimeClip projects can be backed up by exporting the project as an AnimeClip project file.',
            ),
            const _AnswerBlockData.structure('[Your Project Name].ac'),
            const _AnswerBlockData.paragraph(
              'The .ac file is intended to preserve the editable AnimeClip project and can be kept as an external backup.',
            ),
            const _AnswerBlockData.heading('Importing a project'),
            const _AnswerBlockData.structure(
              'Import Project → Select the .ac file → Import',
            ),
            const _AnswerBlockData.paragraph(
              'Cloud Sync is a separate AnimeClip feature available to Go Plus users only. Important projects should still have independent backup copies whenever possible.',
            ),
          ],
        ),
        _FaqItem(
          question: 'What are the different types of exports?',
          searchableAnswer:
              '''Two export types. Project File .ac. Final Output MP4 and PDF. Project file is editable. Final output is finished result.''',
          blocks: [
            const _AnswerBlockData.heading('1. Project File'),
            const _AnswerBlockData.structure('[Your Project Name].ac'),
            const _AnswerBlockData.paragraph(
              'The project file is used to preserve the editable AnimeClip project. It can later be imported through Import Project.',
            ),
            const _AnswerBlockData.heading('2. Final Output'),
            const _AnswerBlockData.paragraph(
              'Final output is intended for the finished result.',
            ),
            const _AnswerBlockData.bullet('MP4 — for animated/video output.'),
            const _AnswerBlockData.bullet('PDF — for manga/book output.'),
            const _AnswerBlockData.paragraph(
              'The key difference is: the project file preserves the editable project, while the final output is intended for viewing or distribution.',
            ),
          ],
        ),
      ],
    ),
    _FaqCategory(
      title: 'CLOUD & SAFETY',
      items: [
        _FaqItem(
          question: 'What should I use for cloud backup?',
          searchableAnswer:
              '''Cloud backup. Google Drive. Other reputable third-party cloud services. Keep original, local backup, cloud backup. Go Plus Cloud Sync is separate.''',
          blocks: [
            const _AnswerBlockData.paragraph(
              'For important AnimeClip project backups, use a reliable cloud-storage service.',
            ),
            const _AnswerBlockData.heading('Recommended backup option'),
            const _AnswerBlockData.structure('Google Drive'),
            const _AnswerBlockData.paragraph(
              'Google Drive can be used to store important .ac project files outside the phone. Other reputable third-party cloud-storage services can also be used when appropriate.',
            ),
            const _AnswerBlockData.heading('Recommended backup approach'),
            const _AnswerBlockData.structure(
              'Original project + Local backup + Cloud backup',
            ),
            const _AnswerBlockData.paragraph(
              'Do not depend on only one copy of an important project. Cloud Sync inside AnimeClip is separate and is available to Go Plus users only.',
            ),
          ],
        ),
        _FaqItem(
          question:
              'What should I know before changing my phone or factory resetting?',
          isWarning: true,
          searchableAnswer:
              '''Factory reset. Change phone. Download all required files. Export .ac projects. Google Drive backup. Verify cloud backup before reset. Local files can be removed.''',
          blocks: [
            const _AnswerBlockData.paragraph(
              'Before changing your phone or performing a factory reset, make sure all required AnimeClip files and important projects have been backed up outside the device.',
            ),
            const _AnswerBlockData.number(
              1,
              'Download or export all required project files.',
            ),
            const _AnswerBlockData.number(
              2,
              'Make sure important .ac project files are saved outside the phone.',
            ),
            const _AnswerBlockData.number(
              3,
              'Upload important .ac project files to Google Drive or another trusted cloud-storage service.',
            ),
            const _AnswerBlockData.number(
              4,
              'Verify that the uploaded files are actually available in the cloud and that you can access the account.',
            ),
            const _AnswerBlockData.number(
              5,
              'Only change the phone or perform the factory reset after confirming that the backups are complete.',
            ),
            const _AnswerBlockData.paragraph(
              'A factory reset can remove files stored locally on the phone. Do not assume that locally stored project files will be recoverable after a reset.',
            ),
          ],
        ),
      ],
    ),
  ];
}
