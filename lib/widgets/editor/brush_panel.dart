import 'package:flutter/material.dart';
import '../../anime_editor/controllers/anime_editor_controller.dart';

class BrushPanel extends StatelessWidget {

  final AnimeEditorController controller;

  const BrushPanel({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,

      children: [

_brushIcon(
  BrushTool.brush,
  Icons.brush,
),

const SizedBox(height: 16),

_brushIcon(
  BrushTool.pressure,
  Icons.swap_vert,
),

const SizedBox(height: 16),

_brushIcon(
  BrushTool.opacity,
  Icons.opacity,
),

const SizedBox(height: 16),

_brushIcon(
  BrushTool.color,
  Icons.color_lens,
),

const SizedBox(height: 16),

_brushIcon(
  BrushTool.size,
  Icons.straighten,
),

      ],
    );
  }



  Widget _brushIcon(
  BrushTool tool,
  IconData icon,
) {

  final bool isSelected =
    controller.selectedBrushTool == tool;

    return InkWell(

      borderRadius: BorderRadius.circular(14),

      onTap: () {
  controller.selectBrushTool(tool);
},


      child: Container(

        width: 50,

        height: 50,


        decoration: BoxDecoration(

          color: isSelected
    ? Colors.pink
    : Colors.grey.shade100,

          borderRadius:
              BorderRadius.circular(14),


          border: Border.all(
            color: Colors.grey.shade300,
          ),

        ),


        child: Icon(
          icon,
          size: 26,
          color: isSelected
    ? Colors.white
    : Colors.black87,
        ),

      ),
    );
  }
}