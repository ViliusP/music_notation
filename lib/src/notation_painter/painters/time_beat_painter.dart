import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';

class TimeBeatPainter extends CustomPainter {
  final String smufl;
  final double symbolSize;

  TimeBeatPainter(this.smufl, this.symbolSize);

  @override
  void paint(Canvas canvas, Size size) {
    PainterUtilities.drawSmuflSymbol(
      canvas,
      smufl,
      symbolSize,
      offset: Offset(0, -symbolSize),
    );
  }

  @override
  bool shouldRepaint(TimeBeatPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TimeBeatPainter oldDelegate) => false;
}
