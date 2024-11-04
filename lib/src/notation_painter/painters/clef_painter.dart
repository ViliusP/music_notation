import 'package:flutter/rendering.dart';

import 'package:music_notation/src/notation_painter/painters/utilities.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

class ClefPainter extends CustomPainter {
  final String smufl;
  final GlyphBBox bBox;

  ClefPainter(this.smufl, this.bBox);

  @override
  void paint(Canvas canvas, Size size) {
    PainterUtilities.drawSmuflSymbolV2(canvas, smufl, bBox);
  }

  @override
  bool shouldRepaint(ClefPainter oldDelegate) {
    return oldDelegate.bBox != bBox || oldDelegate.smufl != smufl;
  }

  @override
  bool shouldRebuildSemantics(ClefPainter oldDelegate) => false;
}
