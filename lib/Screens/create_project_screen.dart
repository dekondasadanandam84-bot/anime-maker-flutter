import 'package:flutter/material.dart';
import 'package:flutter_application_1/anime_editor/clipsystem/clip_setup_screen.dart';
import 'package:flutter_application_1/anime_editor/screens/season_screen.dart';
import 'package:flutter_application_1/manga_editor/screens/manga_editor_screen.dart';
import '../anime_editor/models/project_model.dart';

class CreateProjectScreen extends StatefulWidget {
  final String projectType;

  const CreateProjectScreen({
  super.key,
  required this.projectType,
});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final TextEditingController nameController = TextEditingController();

  String selectedRatio = "16:9";
  double fps = 12;
  final ratios = ["16:9", "9:16", "1:1", "4:3"];

  String selectedPaperSize = "A4";
  double pages = 20;
  final paperSizes = ["A4", "A5", "B5", "Comic", "Webtoon"];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.projectType.startsWith("manga")
              ? "Create Manga Project"
              : "Create Anime Project",
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.projectType.startsWith("manga") ? "Book Name" : "Animation Name",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: widget.projectType.startsWith("manga")
                    ? "Enter book name"
                    : "Enter animation name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            widget.projectType.startsWith("manga") ? _buildMangaUI() : _buildAnimeUI(),

            const Spacer(),

            SizedBox(
  width: double.infinity,
  height: 55,
  child: ElevatedButton(
    onPressed: () async {
  final navigator = Navigator.of(context);

  final projectName = nameController.text.trim().isEmpty
      ? "Untitled"
      : nameController.text.trim();

  final result = await navigator.push(
  MaterialPageRoute(
    builder: (_) => widget.projectType.startsWith("manga")
        ? MangaEditorScreen(
            projectName: projectName,
            pages: pages.toInt(),
            size: selectedPaperSize,
          )
        : widget.projectType == "anime_series"
            ? SeasonScreen(
                project: ProjectModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: projectName,
                  type: "anime",
                  projectType: widget.projectType,
                  ratio: selectedRatio,
                  fps: fps.toInt(),
                  clips: [],
                  seasons: [],
                ),
              )
            : ClipSetupScreen(
                project: ProjectModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: projectName,
                  type: "anime",
                  projectType: widget.projectType,
                  ratio: selectedRatio,
                  fps: fps.toInt(),
                  clips: [],
                  seasons: [],
                ),
              ),
  ),
);

  if (!mounted) return;

  if (result != null) {
    navigator.pop(result);
  }
},
    child: const Text("Create Project"),
  ),
)
        ]),
      ),
    );
  }

  Widget _buildAnimeUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Aspect Ratio",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        DropdownButtonFormField<String>(
          initialValue: selectedRatio,
          items: ratios.map((ratio) {
            return DropdownMenuItem(
              value: ratio,
              child: Text(ratio),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => selectedRatio = value!);
          },
        ),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Frames Per Second",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("${fps.toInt()} FPS"),
          ],
        ),

        Slider(
          min: 1,
          max: 24,
          divisions: 23,
          value: fps,
          onChanged: (value) {
            setState(() => fps = value);
          },
        ),

        if (fps.toInt() == 12)
          const Center(
            child: Text(
              "⭐ Recommended",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMangaUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Paper Size",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        DropdownButtonFormField<String>(
          initialValue: selectedPaperSize,
          items: paperSizes.map((size) {
            return DropdownMenuItem(
              value: size,
              child: Text(size),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => selectedPaperSize = value!);
          },
        ),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Pages",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("${pages.toInt()} Pages"),
          ],
        ),

        Slider(
          min: 1,
          max: 200,
          divisions: 199,
          value: pages,
          onChanged: (value) {
            setState(() => pages = value);
          },
        ),

        if (pages.toInt() == 20)
          const Center(
            child: Text(
              "⭐ Recommended",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}