import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';

class StemPainter extends CustomPainter {
  final StemDirection direction;

  static const strokeWidth = NotationLayoutProperties.stemStrokeWidth;

  final Paint _paint = Paint()
    ..color = const Color.fromRGBO(0, 0, 0, 1.0)
    ..strokeWidth = strokeWidth;

  StemPainter({
    this.direction = StemDirection.up,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset.zero, Offset(0, size.height), _paint);
  }

  @override
  bool shouldRepaint(StemPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(StemPainter oldDelegate) => false;
}
