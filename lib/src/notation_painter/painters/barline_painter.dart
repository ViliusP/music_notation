import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';

class BarlinePainter extends CustomPainter {
  // TODO: adjust correctly, currently it is magic number
  static const double strokeWidth =
      NotationLayoutProperties.staffLineStrokeWidth * 1.6;

  final Color color;

  final double offset;

  final double height;

  final bool end;

  BarlinePainter({
    this.color = const Color.fromRGBO(0, 0, 0, 1.0),
    required this.offset,
    required this.height,
    this.end = true,
  });

  static const Size size = Size(
    strokeWidth,
    NotationLayoutProperties.staveHeight,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePainter = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    double x = end ? size.width : 0;

    canvas.drawLine(
      Offset(x, height),
      Offset(x, offset),
      linePainter,
    );
  }

  @override
  bool shouldRepaint(BarlinePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BarlinePainter oldDelegate) => false;
}
