import 'package:flutter/material.dart';

class SelectionOverlay extends StatefulWidget {
  final Function(Rect selectionRect) onSelectionComplete;

  const SelectionOverlay({
    super.key,
    required this.onSelectionComplete,
  });

  @override
  State<SelectionOverlay> createState() =>
      _SelectionOverlayState();
}


class _SelectionOverlayState extends State<SelectionOverlay> {

  Offset? startPosition;
  Offset? currentPosition;


  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onPanStart: (details) {

        setState(() {

          startPosition = details.localPosition;
          currentPosition = details.localPosition;

        });

      },


      onPanUpdate: (details) {

        setState(() {

          currentPosition = details.localPosition;

        });

      },


      onPanEnd: (_) {

        if (startPosition != null &&
            currentPosition != null) {


          final rect = _createRect(
            startPosition!,
            currentPosition!,
          );


          widget.onSelectionComplete(rect);

        }


        setState(() {

          startPosition = null;
          currentPosition = null;

        });

      },


      child: CustomPaint(

        size: Size.infinite,

        painter: SelectionPainter(

          start: startPosition,

          end: currentPosition,

        ),

      ),
    );
  }



  Rect _createRect(
    Offset start,
    Offset end,
  ) {

    return Rect.fromPoints(
      start,
      end,
    );

  }
}



class SelectionPainter extends CustomPainter {

  final Offset? start;
  final Offset? end;


  SelectionPainter({
    required this.start,
    required this.end,
  });


  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {

    if (start == null || end == null) {
      return;
    }


    final rect = Rect.fromPoints(
      start!,
      end!,
    );


    final paint = Paint()

      ..color = Colors.blue

      ..style = PaintingStyle.stroke

      ..strokeWidth = 2;



    canvas.drawRect(
      rect,
      paint,
    );

  }



  @override
  bool shouldRepaint(
    SelectionPainter oldDelegate,
  ) {

    return oldDelegate.start != start ||
        oldDelegate.end != end;

  }
}