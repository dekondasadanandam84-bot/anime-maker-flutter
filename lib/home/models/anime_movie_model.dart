import 'clip_model.dart';

class AnimeMovieModel {
  final String id;
  final String name;
  final List<ClipModel> clips;

  const AnimeMovieModel({
    required this.id,
    required this.name,
    this.clips = const [],
  });

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