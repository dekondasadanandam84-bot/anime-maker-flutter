import 'package:flutter/material.dart';
import '../models/frame_model.dart';
import '../widgets/frame_manager.dart';
import '../canvas/canvas_controller.dart';

class AnimeEditorScreen extends StatefulWidget {
  final String projectName;
  final String ratio;
  final int fps;

  const AnimeEditorScreen({
  super.key,
  required this.projectName,
  this.ratio = "16:9",
  this.fps = 12,
});

  @override
  State<AnimeEditorScreen> createState() => _AnimeEditorScreenState();
}


class _AnimeEditorScreenState extends State<AnimeEditorScreen> {
  final CanvasController canvasController = CanvasController();

  List<FrameModel> frames = [
    FrameModel(number: 1),
  ];

  int selectedFrame = 0;
  int selectedTool = 0;


 void _addFrames(int count) {
  final safeCount = count.clamp(1, 24);

  setState(() {
    for (int i = 0; i < safeCount; i++) {
      frames.add(FrameModel(number: frames.length + 1));
    }

    selectedFrame = frames.length - 1;
  });
}

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.portrait) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              "Please rotate your device to landscape mode for editing.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Row(
                children: [
                  _buildLeftTools(),
                  Expanded(
                    child: Center(
                      child: _buildCanvas(),
                    ),
                  ),
                ],
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
  return Container(
    height: 72,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    color: Colors.white,
    child: Row(
      children: [
        // LEFT: tools (optional icons)
        const Icon(Icons.undo),
        const SizedBox(width: 12),
        const Icon(Icons.redo),
        const SizedBox(width: 12),
        const Icon(Icons.music_note),
        const SizedBox(width: 12),
        const Icon(Icons.copy),
        const SizedBox(width: 12),
        const Icon(Icons.paste),

        const Spacer(),

        // CENTER: zoom controls
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.zoom_out),
              onPressed: canvasController.zoomOut,
            ),
            IconButton(
              icon: const Icon(Icons.fit_screen),
              onPressed: canvasController.reset,
            ),
            IconButton(
              icon: const Icon(Icons.zoom_in),
              onPressed: canvasController.zoomIn,
            ),
          ],
        ),

        const Spacer(),

        // RIGHT: settings + save
        const Icon(Icons.settings),
        const SizedBox(width: 12),

        IconButton(
          icon: const Icon(Icons.save),
          onPressed: () {
            Navigator.pop(context, {
              "name": widget.projectName,
              "type": "anime",
              "ratio": widget.ratio,
              "fps": widget.fps,
            });
          },
        ),

        const SizedBox(width: 10),
        const Icon(Icons.workspace_premium, color: Colors.amber),
      ],
    ),
  );
}

  Widget _buildLeftTools() {
  final tools = [
    Icons.brush,
    Icons.auto_fix_off,
    Icons.text_fields,
    Icons.select_all,
    Icons.format_color_fill,
  ];

  return Container(
    width: 80,
    margin: const EdgeInsets.only(top: 4, bottom: 4),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(18),
        bottomRight: Radius.circular(18),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(tools.length, (index) {
        final isSelected = selectedTool == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedTool = index;
            });
          },
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isSelected ? Colors.pink : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.black12),
            ),
            child: Icon(
              tools[index],
              size: 28,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        );
      }),
    ),
  );
}

  Widget _buildCanvas() {
    double width = 500;
    double height = 280;

    if (widget.ratio == "9:16") {
      width = 220;
      height = 400;
    } else if (widget.ratio == "1:1") {
      width = 350;
      height = 350;
    }

    return InteractiveViewer(
  transformationController: canvasController.transformationController,
  minScale: 0.5,
  maxScale: 5.0,
  panEnabled: true,
  scaleEnabled: true,
  child: Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.black26),
    ),
  ),
);
  }

  Widget _buildBottomBar() {
  return Container(
    height: 90,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    color: Colors.white,
    child: Row(
      children: [
        Expanded(
          child: Center(
            child: FrameManager(
              frames: frames,
              selectedFrame: selectedFrame,
              onAddFrame: _showAddFrameDialog,
              onSelectFrame: (index) {
                setState(() {
                  if (selectedFrame == index) {
                    _showFrameActions();
                  } else {
                    selectedFrame = index;
                  }
                });
              },
            ),
          ),
        ),
        const Icon(Icons.skip_previous, size: 28),
        const SizedBox(width: 12),
        const Icon(Icons.play_arrow, size: 30),
        const SizedBox(width: 12),
        const Icon(Icons.skip_next, size: 28),
      ],
    ),
  );
}

 void _showFrameActions() {
  showDialog(
    context: context,
    barrierColor: Colors.black12,
    builder: (_) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.black12,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_left),
                  onPressed: () {
                    Navigator.pop(context);
                    _addBefore(selectedFrame);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Navigator.pop(context);
                    _duplicateFrame(selectedFrame);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_right),
                  onPressed: () {
                    Navigator.pop(context);
                    _addAfter(selectedFrame);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    Navigator.pop(context);
                    _deleteFrame(selectedFrame);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void _showAddFrameDialog() {
  int selectedCount = 1;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text("How many frames to add?"),
            content: SizedBox(
  width: 320,
  height: 260,
  child: Column(
    children: [
      Text(
        "$selectedCount frame(s)",
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 12),

      Expanded(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            childAspectRatio: 1,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
          ),
          itemCount: 24,
          itemBuilder: (context, index) {
            final value = index + 1;
            final isSelected = value == selectedCount;

            return GestureDetector(
              onTap: () {
                setStateDialog(() {
                  selectedCount = value;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.pink
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    "$value",
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  ),
),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _addFrames(selectedCount);
                },
                child: const Text("Add"),
              ),
            ],
          );
        },
      );
    },
  );
}
  void _addBefore(int index) {
  setState(() {
    frames.insert(index, FrameModel(number: 0));
    _renumberFrames();
    selectedFrame = index;
  });
}

void _addAfter(int index) {
  setState(() {
    frames.insert(index + 1, FrameModel(number: 0));
    _renumberFrames();
    selectedFrame = index + 1;
  });
}

void _duplicateFrame(int index) {
  setState(() {
    frames.insert(index + 1, FrameModel(number: 0));
    _renumberFrames();
    selectedFrame = index + 1;
  });
}

void _deleteFrame(int index) {
  if (frames.length == 1) return;

  setState(() {
    frames.removeAt(index);
    _renumberFrames();

    if (selectedFrame >= frames.length) {
      selectedFrame = frames.length - 1;
    }
  });
}

void _renumberFrames() {
  for (int i = 0; i < frames.length; i++) {
    frames[i] = FrameModel(number: i + 1);
  }
}
@override
void dispose() {
  canvasController.dispose();
  super.dispose();
}
}