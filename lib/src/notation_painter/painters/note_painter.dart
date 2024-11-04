import 'package:flutter/rendering.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/notes/note_element.dart';

import 'package:music_notation/src/notation_painter/painters/utilities.dart';

class NotePainter extends CustomPainter {
  static const double _lengthOutside = 3;

  final String smufl;

  final GlyphBBox bBox;

  final LedgerLines? ledgerLines;

  final Color color;

  NotePainter({
    required this.smufl,
    required this.bBox,
    this.ledgerLines,
    this.color = const Color.fromRGBO(0, 0, 0, 1),
  });

  final Paint _ledgerLinePaint = Paint()
    ..color = const Color.fromRGBO(0, 0, 0, 1)
    ..strokeWidth = NotationLayoutProperties.staffLineStrokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    PainterUtilities.drawSmuflSymbolV2(
      canvas,
      smufl,
      bBox,
      color: color,
    );
    if (ledgerLines == null || ledgerLines?.count == 0) return;

    double level = 0;
    if (ledgerLines!.placement == LedgerPlacement.above) level = size.height;
    if (ledgerLines!.extendsThroughNote) {
      level = size.height / 2;
    }

    for (int i = 0; i < ledgerLines!.count; i++) {
      canvas.drawLine(
        Offset(-_lengthOutside, level),
        Offset(_lengthOutside + size.width, level),
        _ledgerLinePaint,
      );

      if (ledgerLines!.placement == LedgerPlacement.below) {
        level -= NotationLayoutProperties.staveSpace;
      }
      if (ledgerLines!.placement == LedgerPlacement.above) {
        level += NotationLayoutProperties.staveSpace;
      }
    }
  }

  @override
  bool shouldRepaint(NotePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(NotePainter oldDelegate) => false;
}
