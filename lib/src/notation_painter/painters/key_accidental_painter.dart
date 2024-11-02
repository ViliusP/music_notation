import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';

class KeyAccidentalPainter extends CustomPainter {
  final String smufl;

  const KeyAccidentalPainter(this.smufl);

  @override
  void paint(Canvas canvas, Size size) {
    PainterUtilities.drawSmuflSymbol(
      canvas,
      smufl,
      offset: Offset(0, -0.704 * 50),
    );
  }

  @override
  bool shouldRepaint(KeyAccidentalPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(KeyAccidentalPainter oldDelegate) => false;
}
