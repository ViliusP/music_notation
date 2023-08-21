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

    double level = -NotationLayoutProperties.stemStrokeWidth;

    if ([LedgerPlacement.aboveCrossing, LedgerPlacement.belowCrossing]
        .contains(ledgerLines!.placement)) {
      level = NotationLayoutProperties.noteheadHeight / 2;
    } else {
      level += NotationLayoutProperties.noteheadHeight;
    }

    double lengthOutside = 8;

    print("Ledger: ${ledgerLines?.count}");

    for (int i = 0; i < (ledgerLines?.count ?? 0); i++) {
      canvas.drawLine(
        Offset(-lengthOutside, level),
        Offset(lengthOutside + size.width, level),
        _ledgerLinePaint,
      );
      level -= NotationLayoutProperties.noteheadHeight;
    }
  }

  @override
  bool shouldRepaint(NotePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(NotePainter oldDelegate) => false;
}
