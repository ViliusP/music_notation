import 'package:flutter/rendering.dart';

import 'package:music_notation/src/notation_painter/painters/utilities.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

class SimpleGlyphPainter extends CustomPainter {
  final String smufl;
  final GlyphBBox bBox;

  SimpleGlyphPainter(this.smufl, this.bBox);

  @override
  void paint(Canvas canvas, Size size) {
    PainterUtilities.drawSmuflSymbolV2(canvas, smufl, bBox);
  }

  @override
  bool shouldRepaint(SimpleGlyphPainter oldDelegate) {
    return oldDelegate.bBox != bBox || oldDelegate.smufl != smufl;
  }

  @override
  bool shouldRebuildSemantics(SimpleGlyphPainter oldDelegate) => false;
}
