import 'package:flutter/material.dart';
import 'package:flutter_application_1/anime_editor/canvas_system/models/canvas_model.dart';
import '../../models/project_model.dart';


class CanvasManager extends ChangeNotifier {

  final ProjectModel project;


  CanvasManager({
    required this.project,
  });


CanvasModel get canvas =>
    project.currentSeason
        .currentEpisode
        .currentClip
        .currentFrame
        .canvas;


  String get ratio =>
    canvas.ratio;



  void updateRatio(String ratio) {

    if (canvas.ratio == ratio) return;

canvas.ratio = ratio;


    notifyListeners();
  }



  Size calculateCanvasSize(Size availableSize) {

    double aspectWidth = 16;
    double aspectHeight = 9;


    switch (canvas.ratio) {

      case "16:9":
        aspectWidth = 16;
        aspectHeight = 9;
        break;


      case "9:16":
        aspectWidth = 9;
        aspectHeight = 16;
        break;


      case "1:1":
        aspectWidth = 1;
        aspectHeight = 1;
        break;


      case "4:3":
        aspectWidth = 4;
        aspectHeight = 3;
        break;

    }


    const padding = 24;


    final maxWidth =
        availableSize.width - padding;

    final maxHeight =
        availableSize.height - padding;



    double canvasWidth = maxWidth;

    double canvasHeight =
        canvasWidth * aspectHeight / aspectWidth;



    if(canvasHeight > maxHeight){

      canvasHeight = maxHeight;

      canvasWidth =
          canvasHeight * aspectWidth / aspectHeight;

    }


    return Size(
      canvasWidth,
      canvasHeight,
    );
  }
}