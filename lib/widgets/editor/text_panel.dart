import 'package:flutter/material.dart';
import '../../anime_editor/controllers/anime_editor_controller.dart';

class TextPanel extends StatelessWidget {

  final AnimeEditorController controller;

  const TextPanel({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,

      children: [

        _textIcon(
  TextTool.add,
  Icons.add,
),

const SizedBox(height: 16),

_textIcon(
  TextTool.font,
  Icons.font_download,
),

const SizedBox(height: 16),

_textIcon(
  TextTool.size,
  Icons.format_size,
),

const SizedBox(height: 16),

_textIcon(
  TextTool.color,
  Icons.color_lens,
),

      ],
    );
  }



  Widget _textIcon(
  TextTool tool,
  IconData icon,
) {
  final bool isSelected =
    controller.selectedTextTool == tool;

    return InkWell(

      borderRadius: BorderRadius.circular(14),

      onTap: () {
  controller.selectTextTool(tool);
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