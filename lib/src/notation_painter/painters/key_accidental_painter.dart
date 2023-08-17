import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';

class KeyAccidentalPainter extends CustomPainter {
  final String smufl;

  const KeyAccidentalPainter(this.smufl);

  @override
  void paint(Canvas canvas, Size size) {
    PainterUtilities.drawSmuflSymbol(
      canvas,
      smufl,
      offset: Offset(0, size.height - 49),
    );
  }

  @override
  bool shouldRepaint(KeyAccidentalPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(KeyAccidentalPainter oldDelegate) => false;
}
