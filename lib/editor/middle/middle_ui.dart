import 'package:flutter/material.dart';

import 'middle_controller.dart';

class MiddleUI extends StatelessWidget {
  const MiddleUI({
    super.key,
    required this.controller,
  });

  final MiddleController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          color: const Color(0xFFE9E9E9),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  final maxHeight = constraints.maxHeight;

                  final widthFromHeight =
                      maxHeight * controller.aspectRatio;

                  final canvasWidth =
                      widthFromHeight <= maxWidth
                          ? widthFromHeight
                          : maxWidth;

                  final canvasHeight =
                      canvasWidth / controller.aspectRatio;

                  return SizedBox(
                    width: canvasWidth,
                    height: canvasHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black26,
                          width: 1,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
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