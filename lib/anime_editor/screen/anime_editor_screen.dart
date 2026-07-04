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

  void _addFrame() {
    setState(() {
      frames.add(FrameModel(number: frames.length + 1));
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
          const Icon(Icons.arrow_back),
          const SizedBox(width: 12),
          Text(
            widget.projectName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),

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

const Icon(Icons.undo),
          const SizedBox(width: 14),
          const Icon(Icons.redo),
          const SizedBox(width: 14),
          const Icon(Icons.music_note),
          const SizedBox(width: 14),
          const Icon(Icons.copy),
          const SizedBox(width: 14),
          const Icon(Icons.paste),
          const SizedBox(width: 14),
          const Icon(Icons.settings),
          const SizedBox(width: 14),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
             Navigator.pop(context, {
             "name": widget.projectName,
             "type": "anime",
              "thumbnail": Icons.movie,
           "location": "Local Storage",
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
    return Container(
      width: 82,
      margin: const EdgeInsets.only(top: 4, bottom: 4),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.brush, size: 28),
          Icon(Icons.auto_fix_off, size: 28),
          Icon(Icons.text_fields, size: 28),
          Icon(Icons.select_all, size: 28),
          Icon(Icons.format_color_fill, size: 28),
        ],
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
              onAddFrame: _addFrame,
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





  
