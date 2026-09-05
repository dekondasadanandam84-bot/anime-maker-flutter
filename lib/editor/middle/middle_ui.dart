import 'package:flutter/material.dart';

import '../editor_responsive.dart';
import 'middle_controller.dart';

class MiddleUI extends StatelessWidget {
const MiddleUI({
super.key,
required this.controller,
required this.metrics,
});

final MiddleController controller;
final EditorResponsiveData metrics;

@override
Widget build(BuildContext context) {
return AnimatedBuilder(
animation: controller,
builder: (context, child) {
return Container(
color: const Color(0xFFE9E9E9),
child: Center(
child: Padding(
padding: EdgeInsets.all(
metrics.canvasPadding,
),
child: LayoutBuilder(
builder: (context, constraints) {
final maxWidth =
constraints.maxWidth;
final maxHeight =
constraints.maxHeight;


              final aspectRatio =
                  controller.aspectRatio > 0
                      ? controller.aspectRatio
                      : 16 / 9;

              // --------------------------------------------------
              // Calculate the largest canvas that fits BOTH
              // available width and available height.
              // --------------------------------------------------

              final widthFromHeight =
                  maxHeight * aspectRatio;

              final canvasWidth =
                  widthFromHeight <= maxWidth
                      ? widthFromHeight
                      : maxWidth;

              final canvasHeight =
                  canvasWidth / aspectRatio;

              return Center(
                child: SizedBox(
                  width: canvasWidth,
                  height: canvasHeight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black26,
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color:
                              Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  },
);


}
}
