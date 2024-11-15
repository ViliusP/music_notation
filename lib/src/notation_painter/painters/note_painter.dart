import 'package:flutter/rendering.dart';
import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/notation_painter/models/ledger_lines.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/painters/simple_glyph_painter.dart';

class NotePainter extends CustomPainter {
  // TODO: change
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
    SimpleGlyphPainter.drawSmuflSymbol(
      canvas,
      smufl,
      bBox,
      color: color,
    );
    if (ledgerLines == null || ledgerLines?.count == 0) return;

    double level = size.height / 2;
    if (ledgerLines?.start != LedgerPlacement.center) {
      double shift = NotationLayoutProperties.staveSpace / 2;
      if (ledgerLines?.start == LedgerPlacement.above) {
        shift = -shift;
      }
      level += shift;
    }

    for (int i = 0; i < ledgerLines!.count; i++) {
      canvas.drawLine(
        Offset(-_lengthOutside, level),
        Offset(_lengthOutside + size.width, level),
        _ledgerLinePaint,
      );

      if (ledgerLines!.direction == LedgerDrawingDirection.up) {
        level -= NotationLayoutProperties.staveSpace;
      }
      if (ledgerLines!.direction == LedgerDrawingDirection.down) {
        level += NotationLayoutProperties.staveSpace;
      }
    }
  }

  @override
  bool shouldRepaint(NotePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(NotePainter oldDelegate) => false;
}
