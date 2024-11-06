import 'package:flutter/rendering.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';

/// A custom painter that draws guiding lines within a box, based on provided guides.
///
/// The guides can be either horizontal or vertical, and each has a reference point
/// (left, right, middle for vertical; top, bottom, middle for horizontal) and an offset.
class BeatMarkPainter extends CustomPainter {
  /// A list of guides that define which lines to draw within the box.
  final NoteTypeValue type;

  final double startFrom;

  const BeatMarkPainter(
    this.type,
    this.startFrom,
  );

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    // final Paint markPainter = Paint()
    //   ..color = color
    //   ..strokeWidth = 1;

    paintMarker(canvas, Offset(0, 0));
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
