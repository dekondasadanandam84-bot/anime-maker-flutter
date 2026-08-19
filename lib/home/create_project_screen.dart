import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/anime/seasons_ui.dart';

enum CreateProjectType { animeSeries, animeMovie, mangaSeries, mangaBook }

class CreateProjectScreen extends StatefulWidget {
  final CreateProjectType projectType;

  const CreateProjectScreen({super.key, required this.projectType});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final TextEditingController _titleController = TextEditingController();

  // ============================================================
  // ANIME
  // ============================================================

  String _aspectRatio = '16:9';
  String _resolution = '1920 × 1080';
  double _fps = 12;

  // ============================================================
  // MANGA
  // ============================================================

  String _paperSize = 'A4';
  String _quality = 'High';

  // ============================================================
  // TYPE HELPERS
  // ============================================================

  bool get isAnime =>
      widget.projectType == CreateProjectType.animeSeries ||
      widget.projectType == CreateProjectType.animeMovie;

  bool get isManga =>
      widget.projectType == CreateProjectType.mangaSeries ||
      widget.projectType == CreateProjectType.mangaBook;

  // ============================================================
  // SCREEN TITLE
  // ============================================================

  String get screenTitle {
    switch (widget.projectType) {
      case CreateProjectType.animeSeries:
        return 'Create Anime Series';

      case CreateProjectType.animeMovie:
        return 'Create Anime Movie';

      case CreateProjectType.mangaSeries:
        return 'Create Manga Series';

      case CreateProjectType.mangaBook:
        return 'Create Manga Book';
    }
  }

  // ============================================================
  // NAME
  // ============================================================

  String get nameLabel {
    switch (widget.projectType) {
      case CreateProjectType.animeSeries:
      case CreateProjectType.mangaSeries:
        return 'Series Name';

      case CreateProjectType.animeMovie:
        return 'Movie Name';

      case CreateProjectType.mangaBook:
        return 'Book Name';
    }
  }

  String get nameHint {
    switch (widget.projectType) {
      case CreateProjectType.animeSeries:
        return 'Enter anime series name';

      case CreateProjectType.animeMovie:
        return 'Enter anime movie name';

      case CreateProjectType.mangaSeries:
        return 'Enter manga series name';

      case CreateProjectType.mangaBook:
        return 'Enter manga book name';
    }
  }

  // ============================================================
  // PROJECT STRUCTURE
  // ============================================================

  String get projectStructure {
    switch (widget.projectType) {
      case CreateProjectType.animeSeries:
        return 'Series → Seasons → Episodes → Clips → Frames';

      case CreateProjectType.animeMovie:
        return 'Movie → Clips → Frames';

      case CreateProjectType.mangaSeries:
        return 'Series → Books → Pages → Editor';

      case CreateProjectType.mangaBook:
        return 'Book → Pages → Editor';
    }
  }

  // ============================================================
  // CREATE PROJECT
  // ============================================================

  void _createProject() {
    final name = _titleController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the ${nameLabel.toLowerCase()}.')),
      );
      return;
    }

    final projectData = <String, dynamic>{
      'projectType': widget.projectType.name,
      'name': name,
    };

    if (isAnime) {
      projectData.addAll({
        'aspectRatio': _aspectRatio,
        'resolution': _resolution,
        'fps': _fps.round(),
        'structure': projectStructure,
      });
    }

    if (isManga) {
      projectData.addAll({
        'paperSize': _paperSize,
        'quality': _quality,
        'structure': projectStructure,
      });
    }

    debugPrint('CREATE PROJECT');
    debugPrint(projectData.toString());

    // Anime Series → Seasons
    if (widget.projectType == CreateProjectType.animeSeries) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (_) => SeasonsScreen(
        seriesName: name,
      ),
    ),
  );
  return;
}

    // Existing workflow for the other project types.
    Navigator.of(context).pop(projectData);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ==========================================================
      // APP BAR
      // ==========================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          tooltip: 'Back',
          onPressed: () {
            Navigator.of(context).maybePop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),

        title: Text(
          screenTitle,
          style: const TextStyle(
            color: Color(0xFF1A1C1C),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),

        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFEAEAEA)),
        ),
      ),

      // ==========================================================
      // BODY
      // ==========================================================
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 26, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ==================================================
                  // PROJECT DETAILS
                  // ==================================================
                  const _SectionHeader(
                    title: 'Project Details',
                    subtitle: 'Enter the basic information for your project.',
                  ),

                  const SizedBox(height: 18),

                  _TitleField(
                    controller: _titleController,
                    label: nameLabel,
                    hint: nameHint,
                    icon: isAnime
                        ? Icons.movie_creation_outlined
                        : Icons.menu_book_outlined,
                  ),

                  const SizedBox(height: 32),

                  // ==================================================
                  // ANIME SETTINGS
                  // ==================================================
                  if (isAnime) ...[
                    const _SectionHeader(
                      title: 'Anime Settings',
                      subtitle: 'Configure the basic animation settings.',
                    ),

                    const SizedBox(height: 20),

                    _SimpleDropdown<String>(
                      label: 'Aspect Ratio',
                      value: _aspectRatio,
                      items: const ['16:9', '9:16', '1:1', '4:1'],
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          _aspectRatio = value;
                        });
                      },
                    ),

                    const SizedBox(height: 22),

                    _SimpleDropdown<String>(
                      label: 'Resolution',
                      value: _resolution,
                      items: const [
                        '1280 × 720',
                        '1920 × 1080',
                        '2560 × 1440',
                        '3840 × 2160',
                      ],
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          _resolution = value;
                        });
                      },
                    ),

                    const SizedBox(height: 26),

                    // ==================================================
                    // FPS SLIDER
                    // ==================================================
                    _SliderSetting(
                      label: 'Frame Rate',
                      value: _fps,
                      min: 1,
                      max: 30,
                      valueText: '${_fps.round()} FPS',
                      onChanged: (value) {
                        setState(() {
                          _fps = value;
                        });
                      },
                    ),

                    const SizedBox(height: 28),

                    _StructureSection(value: projectStructure),
                  ],

                  // ==================================================
                  // MANGA SETTINGS
                  // ==================================================
                  if (isManga) ...[
                    const _SectionHeader(
                      title: 'Manga Settings',
                      subtitle: 'Configure the basic manga settings.',
                    ),

                    const SizedBox(height: 20),

                    _SimpleDropdown<String>(
                      label: 'Paper Size',
                      value: _paperSize,
                      items: const ['A4', 'A5', 'A3', 'B5', 'Letter', 'Legal'],
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          _paperSize = value;
                        });
                      },
                    ),

                    const SizedBox(height: 22),

                    _SimpleDropdown<String>(
                      label: 'Quality',
                      value: _quality,
                      items: const ['Draft', 'Medium', 'High', 'Maximum'],
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          _quality = value;
                        });
                      },
                    ),

                    const SizedBox(height: 28),

                    _StructureSection(value: projectStructure),
                  ],

                  const SizedBox(height: 34),

                  // ==================================================
                  // CREATE BUTTON
                  // ==================================================
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _createProject,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Create ${isAnime ? 'Anime' : 'Manga'} Project',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================================================================
// SECTION HEADER
// ================================================================

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1A1C1C),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF6B6B6B),
            fontSize: 13,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

// ================================================================
// TITLE FIELD
// ================================================================

class _TitleField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;

  const _TitleField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF555555)),
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        labelStyle: const TextStyle(color: Color(0xFF444444)),
        hintStyle: const TextStyle(color: Color(0xFF999999)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E2E2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black, width: 1.2),
        ),
      ),
    );
  }
}

// ================================================================
// SIMPLE DROPDOWN
// ================================================================

class _SimpleDropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;

  const _SimpleDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF1A1C1C),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            borderRadius: BorderRadius.circular(12),
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  item.toString(),
                  style: const TextStyle(
                    color: Color(0xFF1A1C1C),
                    fontSize: 14,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

// ================================================================
// FPS SLIDER
// ================================================================

class _SliderSetting extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String valueText;
  final ValueChanged<double> onChanged;

  const _SliderSetting({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.valueText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF1A1C1C),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            Text(
              valueText,
              style: const TextStyle(
                color: Color(0xFF1A1C1C),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        Slider(
          value: value,
          min: min,
          max: max,
          divisions: 29,
          label: valueText,
          onChanged: onChanged,
        ),

        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1 FPS',
              style: TextStyle(color: Color(0xFF888888), fontSize: 11),
            ),

            Text(
              '30 FPS',
              style: TextStyle(color: Color(0xFF888888), fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }
}

// ================================================================
// PROJECT STRUCTURE
// ================================================================

class _StructureSection extends StatelessWidget {
  final String value;

  const _StructureSection({required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Project Structure',
          style: TextStyle(
            color: Color(0xFF1A1C1C),
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF6B6B6B),
            fontSize: 13,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 14),

        const Divider(height: 1, thickness: 1, color: Color(0xFFEAEAEA)),
      ],
    );
  }
}
