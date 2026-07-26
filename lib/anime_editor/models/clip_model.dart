import 'audio_track_model.dart';
import 'clip_settings_model.dart';
import 'frame_model.dart';

class ClipModel {
  final String id;

  String name;


  ClipSettingsModel settings;

  List<AudioTrackModel> audioTracks;

  List<FrameModel> frames;

  int selectedFrameIndex;

  ClipModel({
    required this.id,
    required this.name,
    required this.settings,
    required this.audioTracks,
    required this.frames,
    this.selectedFrameIndex = 0,
  });

  /// Currently selected frame
  FrameModel get currentFrame {
    if (frames.isEmpty) {
      throw Exception("No frames found.");
    }

    return frames[selectedFrameIndex];
  }

  /// Change selected frame
  void selectFrame(int index) {
    if (index < 0 || index >= frames.length) return;

    selectedFrameIndex = index;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "settings": settings.toJson(),
      "audioTracks": audioTracks.map((e) => e.toJson()).toList(),
      "frames": frames.map((e) => e.toJson()).toList(),
      "selectedFrameIndex": selectedFrameIndex,
    };
  }

  factory ClipModel.fromJson(Map<String, dynamic> json) {
    return ClipModel(
      id: json["id"],
      name: json["name"],
      settings: ClipSettingsModel.fromJson(json["settings"]),
      audioTracks: (json["audioTracks"] as List? ?? [])
          .map((e) => AudioTrackModel.fromJson(e))
          .toList(),
      frames: (json["frames"] as List? ?? [])
          .map((e) => FrameModel.fromJson(e))
          .toList(),
      selectedFrameIndex: json["selectedFrameIndex"] ?? 0,
    );
  }
}