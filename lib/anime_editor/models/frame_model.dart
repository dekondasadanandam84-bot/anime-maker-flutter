import 'stroke_model.dart';

class FrameModel {
  final int number;

  /// All drawings belonging to this frame.
  final List<StrokeModel> strokes;

  FrameModel({
    required this.number,
    List<StrokeModel>? strokes,
  }) : strokes = strokes ?? [];

  FrameModel copyWith({
    int? number,
    List<StrokeModel>? strokes,
  }) {
    return FrameModel(
      number: number ?? this.number,
      strokes: strokes ?? List<StrokeModel>.from(this.strokes),
    );
  }
}