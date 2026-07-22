import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/anime_editor/canvas_system/painters/canvas_painter.dart';
import '../controllers/canvas_controller.dart';
import '../controllers/canvas_manager.dart';
import '../controllers/touch_input_handler.dart';
import '../tools/brush_engine.dart';

class DrawingCanvas extends StatefulWidget {
  final CanvasManager canvasManager;
  final CanvasController canvasController;
  final BrushEngine brushEngine;
  final bool brushActive;

  const DrawingCanvas({
    super.key,
    required this.canvasManager,
    required this.canvasController,
    required this.brushEngine,
    required this.brushActive,
  });

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  late final TouchInputHandler _touchHandler;

  @override
  void initState() {
    super.initState();

    _touchHandler = TouchInputHandler(
      canvasController: widget.canvasController,
    );

    widget.canvasManager.addListener(_refresh);
    widget.canvasController.addListener(_refresh);
    widget.brushEngine.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.canvasManager.removeListener(_refresh);
    widget.canvasController.removeListener(_refresh);
    widget.brushEngine.removeListener(_refresh);

    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasSize = widget.canvasManager.calculateCanvasSize(
          Size(
            constraints.maxWidth,
            constraints.maxHeight,
          ),
        );

        return Center(
          child: SizedBox(
            width: canvasSize.width,
            height: canvasSize.height,

            child: ClipRect(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,

              onPanStart: (details) {
if (kDebugMode) {
  print(details.localPosition);
}

  if(!widget.brushActive) return;

  _touchHandler.onPanStart(
    details: details,
    brush: widget.brushEngine.currentBrush,
  );
},

              onPanUpdate: (details) {

  if(!widget.brushActive) return;

  _touchHandler.onPanUpdate(
    details: details,
  );
},

              onPanEnd: (details){

  if(!widget.brushActive) return;

  _touchHandler.onPanEnd(details);

},

              child: CustomPaint(
  size: canvasSize,

  painter: CanvasPainter(
    canvas: widget.canvasManager.canvas,
    currentStroke:
        widget.canvasController.currentStroke,
  ),

  child: Container(
    width: canvasSize.width,
    height: canvasSize.height,

    decoration: BoxDecoration(
      color: Colors.white,

      border: Border.all(
        color: Colors.grey.shade400,
      ),
    ),
  ),
),
            ),
          ),
        ));
      },
    );
  }
}