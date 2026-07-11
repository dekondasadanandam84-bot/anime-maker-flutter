import 'package:flutter/material.dart';
import 'package:flutter_application_1/anime_editor/controllers/anime_editor_controller.dart';

class EraserPanel extends StatelessWidget {
  final AnimeEditorController controller;

const EraserPanel({
  super.key,
  required this.controller,
});

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,

      children: [

        _eraserIcon(
  EraserTool.size,
  Icons.swap_vert,
),

const SizedBox(height: 16),

_eraserIcon(
  EraserTool.opacity,
  Icons.opacity,
),

const SizedBox(height: 16),

_eraserIcon(
  EraserTool.softness,
  Icons.blur_on,
),

const SizedBox(height: 16),

_eraserIcon(
  EraserTool.strength,
  Icons.straighten,
),

      ],
    );
  }



  Widget _eraserIcon(
  EraserTool tool,
  IconData icon,
) {

  final bool isSelected =
    controller.selectedEraserTool == tool;

    return InkWell(

      borderRadius: BorderRadius.circular(14),

      onTap: () {
  controller.selectEraserTool(tool);
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