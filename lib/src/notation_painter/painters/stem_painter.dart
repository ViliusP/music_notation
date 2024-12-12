import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';

class StemPainter extends CustomPainter {
  final double thickness;
  final StemDirection direction;

  StemPainter({
    this.direction = StemDirection.up,
    required this.thickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color.fromRGBO(0, 0, 0, 1.0)
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.butt;

    canvas.drawLine(Offset.zero, Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(StemPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(StemPainter oldDelegate) => false;
}
