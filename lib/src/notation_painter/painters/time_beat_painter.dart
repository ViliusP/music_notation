import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';

class TimeBeatPainter extends CustomPainter {
  final String smufl;

  TimeBeatPainter(this.smufl);

  @override
  void paint(Canvas canvas, Size size) {
    PainterUtilities.drawSmuflSymbol(
      canvas,
      smufl,
    );
  }

  @override
  bool shouldRepaint(TimeBeatPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TimeBeatPainter oldDelegate) => false;
}
