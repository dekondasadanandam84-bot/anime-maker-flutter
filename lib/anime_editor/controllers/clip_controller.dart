import 'package:flutter_application_1/anime_editor/canvas_system/models/canvas_model.dart';
import 'package:flutter_application_1/anime_editor/models/frame_model.dart';

import '../models/clip_model.dart';
import '../models/project_model.dart';

class ClipController {

  int selectedClipIndex = 0;

  final ProjectModel project;

  final int defaultDurationSeconds;


  ClipController({
 required this.project,
 this.defaultDurationSeconds = 120,
}){

 createDefaultClip();

}
List get clips {

  if(project.projectType == "anime_series") {

    return project
        .seasons[project.selectedSeasonIndex]
        .currentEpisode
        .clips;

  }

  return project.clips;

}
  /// Creates the first clip when project is created
  void createDefaultClip() {

    if (clips.isNotEmpty) return;


    clips.add(
      ClipModel(
  id: 1,
  name: "Untitled Clip",
  durationSeconds: defaultDurationSeconds,
  fps: project.fps,
  frameCount: project.fps * defaultDurationSeconds,
  frames: [
  FrameModel(
    id: 1,
    canvas: CanvasModel(
  ratio: project.ratio,
  width: 1920,
  height: 1080,
),
  ),
],
)
    );
  }



  /// Adds a new clip
  void addClip() {

    final number = clips.length + 1;


    clips.add(
      ClipModel(
        id: number,
        name: "Untitled Clip",
        durationSeconds: defaultDurationSeconds,
        fps: project.fps,
        frameCount: project.fps * defaultDurationSeconds,
        frames: [
  FrameModel(
    id: 1,
    canvas: CanvasModel(
      ratio: project.ratio,
      width: 1920,
      height: 1080,
    ),
  ),
],
      ),
    );
  }



  /// Deletes a clip
  void removeClip(int index) {

    if (clips.length == 1) return;


    clips.removeAt(index);


   if (selectedClipIndex >= clips.length) {
  selectedClipIndex = clips.length - 1;
}
  }



  /// Rename clip
  void renameClip(
  int index,
  String newName,
) {

  final clip = clips[index];

  clips[index] = ClipModel(
    id: clip.id,
    name: newName,
    durationSeconds: clip.durationSeconds,
    fps: clip.fps,
    frameCount: clip.frameCount,
    frames: clip.frames,
selectedFrame: clip.selectedFrame,
  );
}



  /// Select clip
  void selectClip(int index) {

    if(index < 0 || index >= clips.length) {
      return;
    }


   selectedClipIndex = index;
  }



  /// Reorder clips
  void reorderClips(
    int oldIndex,
    int newIndex,
  ) {

    if (newIndex > oldIndex) {
      newIndex--;
    }


    final clip =
        clips.removeAt(oldIndex);


    clips.insert(
      newIndex,
      clip,
    );


   selectedClipIndex = clips.indexOf(clip);
  }
}