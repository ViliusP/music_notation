import 'package:flutter/rendering.dart';

class BarlinePainter extends CustomPainter {
  final Color color;

  final double offset;

  final double height;

  final bool end;

  final double thicknes;

  BarlinePainter({
    this.color = const Color.fromRGBO(0, 0, 0, 1.0),
    required this.offset,
    required this.height,
    required this.thicknes,
    this.end = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePainter = Paint()
      ..color = color
      ..strokeWidth = thicknes;

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
