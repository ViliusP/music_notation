import 'package:flutter/rendering.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/notation_painter/models/ledger_lines.dart';
import 'package:music_notation/src/notation_painter/painters/simple_glyph_painter.dart';

class NotePainter extends CustomPainter {
  // TODO: change
  static const double _lengthOutside = 3;

  final String smufl;

  final GlyphBBox bBox;

  final LedgerLines? ledgerLines;

  final double ledgerLinesThickness;

  final Color color;

  final double staveSpace;

  NotePainter({
    required this.smufl,
    required this.bBox,
    this.ledgerLines,
    required this.ledgerLinesThickness,
    required this.staveSpace,
    this.color = const Color.fromRGBO(0, 0, 0, 1),
  });

  @override
  void paint(Canvas canvas, Size size) {
    SimpleGlyphPainter.drawSmuflSymbol(
      canvas,
      smufl,
      bBox,
      staveSpace,
      color: color,
    );
    if (ledgerLines == null || ledgerLines?.count == 0) return;

    Paint ledgerLinePaint = Paint()
      ..color = const Color.fromRGBO(0, 0, 0, 1)
      ..strokeWidth = ledgerLinesThickness;

    double level = size.height / 2;
    if (ledgerLines?.start != LedgerPlacement.center) {
      double shift = staveSpace / 2;
      if (ledgerLines?.start == LedgerPlacement.above) {
        shift = -shift;
      }
      level += shift;
    }

    for (int i = 0; i < ledgerLines!.count; i++) {
      canvas.drawLine(
        Offset(-_lengthOutside, level),
        Offset(_lengthOutside + size.width, level),
        ledgerLinePaint,
      );

      if (ledgerLines!.direction == LedgerDrawingDirection.up) {
        level -= staveSpace;
      }
      if (ledgerLines!.direction == LedgerDrawingDirection.down) {
        level += staveSpace;
      }
    }
  }

  @override
  bool shouldRepaint(NotePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(NotePainter oldDelegate) => false;
}
