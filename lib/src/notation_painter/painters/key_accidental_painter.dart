import 'package:flutter/rendering.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/notation_painter/painters/utilities.dart';

class KeyAccidentalPainter extends CustomPainter {
  final String smufl;
  final GlyphBBox bBox;

  const KeyAccidentalPainter(this.smufl, this.bBox);

  @override
  void paint(Canvas canvas, Size size) {
    PainterUtilities.drawSmuflSymbolV2(
      canvas,
      smufl,
      bBox,
    );
  }

  @override
  bool shouldRepaint(KeyAccidentalPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(KeyAccidentalPainter oldDelegate) => false;
}
