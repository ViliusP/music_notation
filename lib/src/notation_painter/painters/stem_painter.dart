import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/note_element.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';

class StemPainter extends CustomPainter {
  /// Smufl symbol for flag.
  final String? flagSmufl;

  final StemDirection direction;

  static const strokeWidth = NotationLayoutProperties.stemStrokeWidth;

  final Paint _paint = Paint()
    ..color = const Color.fromRGBO(0, 0, 0, 1.0)
    ..strokeWidth = strokeWidth;

  StemPainter({
    required this.flagSmufl,
    this.direction = StemDirection.up,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset.zero, Offset(0, size.height), _paint);

    Offset paintingOffset = const Offset(0, -40);

    if (direction == StemDirection.down) {
      paintingOffset = const Offset(0, 0);
    }

    if (flagSmufl != null) {
      PainterUtilities.drawSmuflSymbol(
        canvas,
        flagSmufl!,
        offset: paintingOffset,
      );
    }
  }

  @override
  bool shouldRepaint(StemPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(StemPainter oldDelegate) => false;
}
