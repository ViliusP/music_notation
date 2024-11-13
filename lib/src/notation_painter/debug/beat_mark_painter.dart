import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/spacing/timeline.dart';
import 'package:music_notation/src/notation_painter/utilities/list_extensions.dart';
import 'package:music_notation/src/notation_painter/utilities/number_extensions.dart';

/// A custom painter that draws guiding lines within a box, based on provided guides.
///
/// The guides can be either horizontal or vertical, and each has a reference point
/// (left, right, middle for vertical; top, bottom, middle for horizontal) and an offset.
class BeatMarkPainter extends CustomPainter {
  /// A list of guides that define which lines to draw within the box.
  final double multiplier;

  final BeatTimeline beatTimeline;

  const BeatMarkPainter(
    this.multiplier,
    this.beatTimeline,
  );

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    int every = beatTimeline.divisions.toInt();
    every = (every / multiplier).floor();
    every = every.clamp(1, NumberConstants.maxFiniteInt);

    every = every.nearestMultiple(of: beatTimeline.divisions.toInt());
    List<double> spacings = beatTimeline.toDivisionsSpacing().everyNth(every);
    for (var leftOffset in spacings) {
      canvas.drawLine(
        Offset(leftOffset, 0),
        Offset(leftOffset, size.height),
        Paint()..color = Color.fromRGBO(2, 0, 122, .5),
      );

      paintMarker(canvas, Offset(leftOffset, size.height / 2));
    }
  }

  void paintMarker(Canvas canvas, Offset offset) {
    canvas.drawCircle(
      offset,
      5,
      Paint()..color = Color.fromRGBO(9, 255, 0, .5),
    );
    canvas.drawCircle(
      offset,
      3,
      Paint()..color = Color.fromRGBO(0, 0, 255, .8),
    );
  }

  @override
  bool shouldRepaint(BeatMarkPainter oldDelegate) {
    return oldDelegate.multiplier != multiplier ||
        oldDelegate.beatTimeline != beatTimeline;
  }

  @override
  bool shouldRebuildSemantics(BeatMarkPainter oldDelegate) => false;
}
