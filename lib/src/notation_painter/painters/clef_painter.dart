import 'package:flutter/rendering.dart';

import 'package:music_notation/src/notation_painter/painters/utilties.dart';

class ClefPainter extends CustomPainter {
  final String smufl;

  ClefPainter(this.smufl);

  @override
  void paint(Canvas canvas, Size size) {
    PainterUtilities.drawSmuflSymbol(
      canvas,
      smufl,
      offset: Offset(0, size.height - 48),
    );
  }

  @override
  bool shouldRepaint(ClefPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(ClefPainter oldDelegate) => false;
}
