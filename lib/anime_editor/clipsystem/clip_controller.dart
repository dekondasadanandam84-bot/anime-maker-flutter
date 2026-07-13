import '../models/clip_model.dart';
import '../models/project_model.dart';

class ClipController {

  final ProjectModel project;

  final int defaultDurationSeconds;


  ClipController({
    required this.project,
    this.defaultDurationSeconds = 120,
  }) {
    createDefaultClip();
  }


  // Access project clips
  List<ClipModel> get clips => project.clips;


  // Selected clip index
  int get selectedClipIndex => project.selectedClipIndex;


  // Current selected clip
  ClipModel get currentClip => project.currentClip;



  /// Creates the first clip when project is created
  void createDefaultClip() {

    if (project.clips.isNotEmpty) return;


    project.clips.add(
      ClipModel(
  id: 1,
  name: "Untitled Clip",
  durationSeconds: defaultDurationSeconds,
  fps: project.fps,
  frameCount: project.fps * defaultDurationSeconds,
  frames: [1],
)
    );
  }



  /// Adds a new clip
  void addClip() {

    final number = project.clips.length + 1;


    project.clips.add(
      ClipModel(
        id: number,
        name: "Untitled Clip",
        durationSeconds: defaultDurationSeconds,
        fps: project.fps,
        frameCount: project.fps * defaultDurationSeconds,
        frames: [1],
      ),
    );
  }



  /// Deletes a clip
  void removeClip(int index) {

    if (project.clips.length == 1) return;


    project.clips.removeAt(index);


    if (project.selectedClipIndex >= project.clips.length) {

      project.selectedClipIndex =
          project.clips.length - 1;
    }
  }



  /// Rename clip
  void renameClip(
  int index,
  String newName,
) {

  final clip = project.clips[index];

  project.clips[index] = ClipModel(
    id: clip.id,
    name: newName,
    durationSeconds: clip.durationSeconds,
    fps: clip.fps,
    frameCount: clip.frameCount,
    frames: [1],
  );
}



  /// Select clip
  void selectClip(int index) {

    if(index < 0 || index >= project.clips.length) {
      return;
    }


    project.selectedClipIndex = index;
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
        project.clips.removeAt(oldIndex);


    project.clips.insert(
      newIndex,
      clip,
    );


    project.selectedClipIndex =
        project.clips.indexOf(clip);
  }
}