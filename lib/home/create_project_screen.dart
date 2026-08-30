import 'package:flutter/material.dart';

import 'project_controller.dart';
import 'project_scope.dart';
import 'models/project_model.dart';
import 'models/project_settings_model.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({
    super.key,
  });

  @override
  State<CreateProjectScreen> createState() =>
      _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  late final TextEditingController _titleController;

  // ============================================================
  // TEMPORARY FORM STATE
  // ============================================================
  //
  // These values are only draft values while the user is filling
  // the form.
  //
  // They are NOT the source of truth for a saved project.
  // The final saved values go into ProjectController.
  // ============================================================

  String _aspectRatio = '16:9';
  String _resolution = '1920 × 1080';
  double _fps = 12;

  String _paperSize = 'A4';
  String _quality = 'High';

  bool _loadedCurrentProject = false;

  // ============================================================
  // PROJECT CONTROLLER
  // ============================================================

  ProjectController get projectController =>
      ProjectScope.of(context);

  ProjectFlowType? get flowType =>
      projectController.projectFlowType;

  bool get isEditing =>
      projectController.isEditingProject;

  bool get isAnime =>
      flowType == ProjectFlowType.animeSeries ||
      flowType == ProjectFlowType.animeMovie ||
      isEditing;

  bool get isManga =>
      flowType == ProjectFlowType.mangaSeries ||
      flowType == ProjectFlowType.mangaBook;

  // ============================================================
  // INITIALIZATION
  // ============================================================

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _loadCurrentProject();
    });
  }

  void _loadCurrentProject() {
    if (_loadedCurrentProject || !isEditing) {
      return;
    }

    final project = projectController.currentProject;

    if (project == null) {
      return;
    }

    _titleController.text = project.name;

    _aspectRatio = _aspectRatioText(
      project.settings.aspectRatio,
    );

    _resolution = project.settings.resolution;
    _fps = project.settings.fps;
    _quality = project.settings.quality;

    _loadedCurrentProject = true;

    setState(() {});
  }

  // ============================================================
  // SCREEN TITLE
  // ============================================================

  String get screenTitle {
    if (isEditing) {
      return 'Project Settings';
    }

    switch (flowType) {
      case ProjectFlowType.animeSeries:
        return 'Create Anime Series';

      case ProjectFlowType.animeMovie:
        return 'Create Anime Movie';

      case ProjectFlowType.mangaSeries:
        return 'Create Manga Series';

      case ProjectFlowType.mangaBook:
        return 'Create Manga Book';

      case ProjectFlowType.editCurrentProject:
      case null:
        return 'Create Project';
    }
  }

  // ============================================================
  // NAME LABEL
  // ============================================================

  String get nameLabel {
    switch (flowType) {
      case ProjectFlowType.animeMovie:
        return 'Movie Name';

      case ProjectFlowType.mangaSeries:
        return 'Series Name';

      case ProjectFlowType.mangaBook:
        return 'Book Name';

      case ProjectFlowType.animeSeries:
      case ProjectFlowType.editCurrentProject:
      case null:
        if (isEditing &&
            projectController.currentProjectType ==
                ProjectType.animeMovie) {
          return 'Movie Name';
        }

        return 'Series Name';
    }
  }

  // ============================================================
  // NAME HINT
  // ============================================================

  String get nameHint {
    switch (flowType) {
      case ProjectFlowType.animeSeries:
        return 'Enter anime series name';

      case ProjectFlowType.animeMovie:
        return 'Enter anime movie name';

      case ProjectFlowType.mangaSeries:
        return 'Enter manga series name';

      case ProjectFlowType.mangaBook:
        return 'Enter manga book name';

      case ProjectFlowType.editCurrentProject:
      case null:
        return 'Enter project name';
    }
  }

  // ============================================================
  // PROJECT STRUCTURE
  // ============================================================

  String get projectStructure {
    switch (flowType) {
      case ProjectFlowType.animeSeries:
        return 'Series → Seasons → Episodes → Clips → Frames';

      case ProjectFlowType.animeMovie:
        return 'Movie → Clips → Frames';

      case ProjectFlowType.mangaSeries:
        return 'Series → Books → Pages → Editor';

      case ProjectFlowType.mangaBook:
        return 'Book → Pages → Editor';

      case ProjectFlowType.editCurrentProject:
      case null:
        if (projectController.currentProjectType ==
            ProjectType.animeMovie) {
          return 'Movie → Clips → Frames';
        }

        return 'Series → Seasons → Episodes → Clips → Frames';
    }
  }

  // ============================================================
  // ASPECT RATIO
  // ============================================================

  ProjectAspectRatio _parseAspectRatio(
    String value,
  ) {
    switch (value) {
      case '9:16':
        return ProjectAspectRatio.ratio9x16;

      case '1:1':
        return ProjectAspectRatio.ratio1x1;

      case '4:1':
        return ProjectAspectRatio.ratio4x1;

      case '16:9':
      default:
        return ProjectAspectRatio.ratio16x9;
    }
  }

  String _aspectRatioText(
    ProjectAspectRatio ratio,
  ) {
    switch (ratio) {
      case ProjectAspectRatio.ratio16x9:
        return '16:9';

      case ProjectAspectRatio.ratio9x16:
        return '9:16';

      case ProjectAspectRatio.ratio1x1:
        return '1:1';

      case ProjectAspectRatio.ratio4x1:
        return '4:1';
    }
  }

  // ============================================================
  // SAVE / CREATE
  // ============================================================

  void _saveProject() {
    final name = _titleController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter the ${nameLabel.toLowerCase()}.',
          ),
        ),
      );

      return;
    }

    final controller = projectController;

    // ==========================================================
    // EDIT CURRENT PROJECT
    // ==========================================================

    if (isEditing) {
      final currentProject = controller.currentProject;

      if (currentProject == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No current project found.',
            ),
          ),
        );

        return;
      }

      final updatedSettings =
          currentProject.settings.copyWith(
        aspectRatio: _parseAspectRatio(_aspectRatio),
        resolution: _resolution,
        fps: _fps.roundToDouble(),
        quality: _quality,
      );

      // ONE central project update.
      //
      // ProjectController remains the single source of truth.
      // Name and settings are committed together.
      controller.updateCurrentProject(
        name: name,
        settings: updatedSettings,
      );

      controller.clearProjectFlow();

      Navigator.of(context).pop();

      return;
    }

    // ==========================================================
    // MANGA
    // ==========================================================

    if (isManga) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Manga project models are not implemented yet.',
          ),
        ),
      );

      return;
    }

    // ==========================================================
    // ANIME SETTINGS
    // ==========================================================

    final settings = ProjectSettingsModel(
      aspectRatio: _parseAspectRatio(_aspectRatio),
      resolution: _resolution,
      fps: _fps.roundToDouble(),
      quality: _quality,
    );

    // ==========================================================
    // ANIME SERIES
    // ==========================================================

    if (flowType == ProjectFlowType.animeSeries) {
      controller.createProject(
        projectType: ProjectType.animeSeries,
        name: name,
        settings: settings,
      );

      controller.clearProjectFlow();

      Navigator.of(context).pop();

      return;
    }

    // ==========================================================
    // ANIME MOVIE
    // ==========================================================

    if (flowType == ProjectFlowType.animeMovie) {
      controller.createProject(
        projectType: ProjectType.animeMovie,
        name: name,
        settings: settings,
      );

      controller.clearProjectFlow();

      Navigator.of(context).pop();

      return;
    }

    // ==========================================================
    // NO PROJECT TYPE
    // ==========================================================

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Please select a project type.',
        ),
      ),
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

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
    // Establish the reactive dependency on ProjectController.
    ProjectScope.of(context);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          tooltip: 'Back',
          onPressed: () {
            projectController.clearProjectFlow();

            Navigator.of(context).maybePop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
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
          child: Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFEAEAEA),
          ),
        ),
      ),

      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            26,
            20,
            32,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 720,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  const _SectionHeader(
                    title: 'Project Details',
                    subtitle:
                        'Enter the basic information for your project.',
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

                  if (isAnime) ...[
                    const _SectionHeader(
                      title: 'Anime Settings',
                      subtitle:
                          'Configure the basic animation settings.',
                    ),

                    const SizedBox(height: 20),

                    _SimpleDropdown<String>(
                      label: 'Aspect Ratio',
                      value: _aspectRatio,
                      items: const [
                        '16:9',
                        '9:16',
                        '1:1',
                        '4:1',
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }

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
                        if (value == null) {
                          return;
                        }

                        setState(() {
                          _resolution = value;
                        });
                      },
                    ),

                    const SizedBox(height: 26),

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

                    _StructureSection(
                      value: projectStructure,
                    ),
                  ],

                  if (isManga) ...[
                    const _SectionHeader(
                      title: 'Manga Settings',
                      subtitle:
                          'Configure the basic manga settings.',
                    ),

                    const SizedBox(height: 20),

                    _SimpleDropdown<String>(
                      label: 'Paper Size',
                      value: _paperSize,
                      items: const [
                        'A4',
                        'A5',
                        'A3',
                        'B5',
                        'Letter',
                        'Legal',
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }

                        setState(() {
                          _paperSize = value;
                        });
                      },
                    ),

                    const SizedBox(height: 22),

                    _SimpleDropdown<String>(
                      label: 'Quality',
                      value: _quality,
                      items: const [
                        'Draft',
                        'Medium',
                        'High',
                        'Maximum',
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }

                        setState(() {
                          _quality = value;
                        });
                      },
                    ),

                    const SizedBox(height: 28),

                    _StructureSection(
                      value: projectStructure,
                    ),
                  ],

                  const SizedBox(height: 34),

                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _saveProject,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        isEditing
                            ? 'Save Settings'
                            : 'Create ${isAnime ? 'Anime' : 'Manga'} Project',
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

  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

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
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF555555),
        ),
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        labelStyle: const TextStyle(
          color: Color(0xFF444444),
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF999999),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFE2E2E2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 1.2,
          ),
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
            items: items.map(
              (item) {
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
              },
            ).toList(),
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
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
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
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1 FPS',
              style: TextStyle(
                color: Color(0xFF888888),
                fontSize: 11,
              ),
            ),
            Text(
              '30 FPS',
              style: TextStyle(
                color: Color(0xFF888888),
                fontSize: 11,
              ),
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

  const _StructureSection({
    required this.value,
  });

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
        const Divider(
          height: 1,
          thickness: 1,
          color: Color(0xFFEAEAEA),
        ),
      ],
    );
  }
}