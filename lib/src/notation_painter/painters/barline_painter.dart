import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';

class BarlinePainter extends CustomPainter {
  static const double strokeWidth = 1.5;

  final Paint _linePainter = Paint()
    ..color = const Color.fromRGBO(0, 0, 0, 1.0)
    ..strokeWidth = 1.5;

  static const Size size = Size(
    strokeWidth,
    NotationLayoutProperties.staveHeight,
  );

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      const Offset(0, 0),
      const Offset(0, NotationLayoutProperties.staveHeight),
      _linePainter,
    );
  }

  @override
  bool shouldRepaint(BarlinePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BarlinePainter oldDelegate) => false;
}
