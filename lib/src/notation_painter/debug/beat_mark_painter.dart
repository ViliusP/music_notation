import 'package:flutter/rendering.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/notation_painter/spacing/timeline.dart';
import 'package:music_notation/src/notation_painter/utilities/list_extensions.dart';

/// A custom painter that draws guiding lines within a box, based on provided guides.
///
/// The guides can be either horizontal or vertical, and each has a reference point
/// (left, right, middle for vertical; top, bottom, middle for horizontal) and an offset.
class BeatMarkPainter extends CustomPainter {
  /// A list of guides that define which lines to draw within the box.
  final NoteTypeValue type;

  final BeatTimeline beatTimeline;

  const BeatMarkPainter(
    this.type,
    this.beatTimeline,
  );

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    List<double> spacings = beatTimeline.toDivisionsSpacing().everyNth(
          beatTimeline.divisions.toInt(),
        );
    for (var leftOffset in spacings) {
      paintMarker(canvas, Offset(leftOffset, size.height / 2));
    }
  }

  void paintMarker(Canvas canvas, Offset offset) {
    canvas.drawCircle(
      offset,
      6,
      Paint()..color = Color.fromRGBO(191, 191, 253, 1),
    );
    canvas.drawCircle(
      offset,
      3,
      Paint()..color = Color.fromRGBO(0, 0, 255, 1),
    );
  }

  @override
  bool shouldRepaint(BeatMarkPainter oldDelegate) {
    return oldDelegate.type != type;
  }

  @override
  bool shouldRebuildSemantics(BeatMarkPainter oldDelegate) => false;
}
