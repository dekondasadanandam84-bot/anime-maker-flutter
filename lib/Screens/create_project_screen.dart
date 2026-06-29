import 'package:flutter/material.dart';
import 'package:flutter_application_1/anime_editor/screen/anime_editor_screen.dart';
import 'package:flutter_application_1/Screens/manga_editor_screen.dart';

class CreateProjectScreen extends StatefulWidget {
  final bool isManga;

  const CreateProjectScreen({
    super.key,
    this.isManga = false,
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
          widget.isManga
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
              widget.isManga ? "Book Name" : "Animation Name",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: widget.isManga
                    ? "Enter book name"
                    : "Enter animation name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            widget.isManga ? _buildMangaUI() : _buildAnimeUI(),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  final projectName = nameController.text.trim().isEmpty
                      ? "Untitled"
                      : nameController.text.trim();

                  final navigator = Navigator.of(context);

                  final result = await navigator.push(
                    MaterialPageRoute(
                      builder: (_) => widget.isManga
                          ? MangaEditorScreen(projectName: projectName)
                          : AnimeEditorScreen(
  projectName: projectName,
  ratio: selectedRatio,
),
                    ),
                  );

                  if (result != null) {
                    navigator.pop(result);
                  }
                },
                child: const Text("Create Project"),
              ),
            ),
          ],
        ),
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