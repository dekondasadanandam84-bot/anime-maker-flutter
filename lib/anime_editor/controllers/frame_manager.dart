import 'package:flutter/foundation.dart';
import '../models/project_model.dart';
import '../models/frame_model.dart';
import '../models/canvas_model.dart';


class FrameManager extends ChangeNotifier {

  final ProjectModel project;

  FrameManager({
    required this.project,
    required List<FrameModel> frames,
    int selectedFrame = 0,
  });



  List<FrameModel> get frames =>
    project
        .currentSeason
        .currentEpisode
        .currentClip
        .frames;



  int selectedFrame = 0;



  int get frameCount =>
      frames.length;



  void addFrames(int count) {

    if(count <= 0) return;


    final start = frames.length;


    for(int i = 0; i < count; i++) {

      frames.add(
  FrameModel(
    id: start + i + 1,
    canvas: CanvasModel(
      ratio: project.ratio,
      width: 1920,
      height: 1080,
    ),
  ),
);

    }


    notifyListeners();
  }




  void selectFrame(int index) {

    if(index < 0 || index >= frames.length) return;


    selectedFrame = index;

    notifyListeners();
  }




  void previousFrame() {

    if(selectedFrame > 0){

      selectedFrame--;

      notifyListeners();

    }

  }




  void nextFrame(){

    if(selectedFrame < frames.length - 1){

      selectedFrame++;

      notifyListeners();

    }

  }





  void deleteFrame(int index){

    if(frames.length <= 1) return;


    frames.removeAt(index);


    _renumber();


    if(selectedFrame >= frames.length){

      selectedFrame = frames.length - 1;

    }


    notifyListeners();
  }





  void duplicateFrame(int index){

    final frame = frames[index];

frames.insert(
  index + 1,
  frame.copyWith(
    id: frames.length + 1,
  ),
);


    _renumber();


    selectedFrame = index + 1;


    notifyListeners();
  }





  void addFrameAfter(int index){

    frames.insert(
  index + 1,
  FrameModel(
    id: frames.length + 1,
    canvas: CanvasModel(
      ratio: project.ratio,
      width: 1920,
      height: 1080,
    ),
  ),
);


    _renumber();


    selectedFrame = index + 1;


    notifyListeners();

  }





  void clear(){

    frames
  ..clear()
  ..add(
    FrameModel(
      id: 1,
      canvas: CanvasModel(
        ratio: project.ratio,
        width: 1920,
        height: 1080,
      ),
    ),
  );


    selectedFrame = 0;


    notifyListeners();

  }





  void _renumber(){

    for(int i = 0; i < frames.length; i++){

      frames[i] = frames[i].copyWith(
  id: i + 1,
);

    }

  }
  
  void addFrameBefore(int index) {

  if(index < 0 || index > frames.length) return;


  frames.insert(
  index,
  FrameModel(
    id: frames.length + 1,
    canvas: CanvasModel(
      ratio: project.ratio,
      width: 1920,
      height: 1080,
    ),
  ),
);


  _renumber();


  selectedFrame = index;


  notifyListeners();
}
}