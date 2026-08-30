import 'clip_model.dart';

class AnimeMovieModel {
  const AnimeMovieModel({
    required this.id,
    required this.name,
    this.clips = const [],
  });

  final String id;
  final String name;
  final List<ClipModel> clips;

  AnimeMovieModel copyWith({
    String? id,
    String? name,
    List<ClipModel>? clips,
  }) {
    return AnimeMovieModel(
      id: id ?? this.id,
      name: name ?? this.name,
      clips: clips ?? this.clips,
    );
  }
}