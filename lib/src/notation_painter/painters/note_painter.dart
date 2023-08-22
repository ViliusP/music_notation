import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/note_element.dart';

import 'package:music_notation/src/notation_painter/painters/utilities.dart';

class NotePainter extends CustomPainter {
  final String smufl;

  final LedgerLines? ledgerLines;

  NotePainter({
    required this.smufl,
    this.ledgerLines,
  });

  final Paint _ledgerLinePaint = Paint()
    ..color = const Color.fromRGBO(0, 0, 0, 1)
    ..strokeWidth = NotationLayoutProperties.staffLineStrokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    PainterUtilities.drawSmuflSymbol(
      canvas,
      smufl,
      offset: Offset(0, size.height - 48),
    );
    if (ledgerLines == null || ledgerLines?.count == 0) return;
    const double lengthOutside = 4;

    double level = 0;
    if (ledgerLines!.extendsThroughNote) {
      level = NotationLayoutProperties.noteheadHeight / 2;
    } else if (ledgerLines!.placement == LedgerPlacement.above) {
      level = NotationLayoutProperties.noteheadHeight;
      level -= NotationLayoutProperties.stemStrokeWidth / 1.5;
    }

    for (int i = 0; i < ledgerLines!.count; i++) {
      canvas.drawLine(
        Offset(-lengthOutside, level),
        Offset(lengthOutside + size.width, level),
        _ledgerLinePaint,
      );

      if (ledgerLines!.placement == LedgerPlacement.below) {
        level -= NotationLayoutProperties.noteheadHeight;
        level += NotationLayoutProperties.stemStrokeWidth / 0.75;
      }
      if (ledgerLines!.placement == LedgerPlacement.above) {
        level += NotationLayoutProperties.noteheadHeight;
        level -= NotationLayoutProperties.stemStrokeWidth / 0.75;
      }
    }
  }

  @override
  bool shouldRepaint(NotePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(NotePainter oldDelegate) => false;
}
