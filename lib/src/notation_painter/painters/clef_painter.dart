import 'package:flutter/rendering.dart';

import 'package:music_notation/src/notation_painter/painters/utilities.dart';

class ClefPainter extends CustomPainter {
  final String smufl;
  final Offset offset;

  ClefPainter(this.smufl, this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    PainterUtilities.drawSmuflSymbol(
      canvas,
      smufl,
      offset: Offset(0, size.height) - offset,
    );
  }

  @override
  bool shouldRepaint(ClefPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(ClefPainter oldDelegate) => false;
}
