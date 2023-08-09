import 'package:flutter/rendering.dart';

import 'package:music_notation/src/notation_painter/painters/utilties.dart';

class NotePainter extends CustomPainter {
  final String smufl;

  NotePainter(this.smufl);

  @override
  void paint(Canvas canvas, Size size) {
    PainterUtilities.drawSmuflSymbol(
      canvas,
      smufl,
      offset: Offset(0, size.height - 48),
    );
  }

  @override
  bool shouldRepaint(NotePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(NotePainter oldDelegate) => false;
}
