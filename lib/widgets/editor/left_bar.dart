import 'package:flutter/material.dart';
import '../../anime_editor/controllers/anime_editor_controller.dart';


class LeftBar extends StatelessWidget {

  final AnimeEditorController controller;


  const LeftBar({
    super.key,
    required this.controller,
  });



  @override
  Widget build(BuildContext context) {

    return Container(
      width: 70,

      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: Colors.grey.shade300,
        ),

        boxShadow: const [

          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),

        ],
      ),


      child: Column(

        mainAxisSize: MainAxisSize.min,


        children: [

          _toolButton(
            EditorTool.brush,
            Icons.brush,
          ),

          const SizedBox(height: 10),


          _toolButton(
            EditorTool.eraser,
            Icons.auto_fix_normal,
          ),

          const SizedBox(height: 10),


          _toolButton(
            EditorTool.text,
            Icons.text_fields,
          ),

          const SizedBox(height: 10),


          _toolButton(
            EditorTool.paint,
            Icons.format_color_fill,
          ),

          const SizedBox(height: 10),


          _toolButton(
            EditorTool.selection,
            Icons.select_all,
          ),

        ],
      ),
    );
  }



  Widget _toolButton(
    EditorTool tool,
    IconData icon,
  ) {


    final bool isSelected =
        controller.selectedTool == tool;



    return InkWell(

      borderRadius: BorderRadius.circular(14),


      onTap: () {

        controller.selectTool(tool);

      },


      child: AnimatedContainer(

        duration: const Duration(
          milliseconds: 200,
        ),


        width: 50,

        height: 50,


        decoration: BoxDecoration(

          color: isSelected
              ? Colors.pink
              : Colors.transparent,


          borderRadius:
              BorderRadius.circular(14),

        ),



        child: Icon(

          icon,


          color: isSelected
              ? Colors.white
              : Colors.black87,


          size: 28,

        ),
      ),
    );
  }
}