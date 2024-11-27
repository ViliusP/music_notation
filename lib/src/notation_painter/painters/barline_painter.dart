import 'package:flutter/rendering.dart';

class BarlinePainter extends CustomPainter {
  final Color color;

  BarlinePainter({
    this.color = const Color.fromRGBO(0, 0, 0, 1.0),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePainter = Paint()
      ..color = color
      ..strokeWidth = size.width;

    canvas.drawRect(
      Rect.fromPoints(
        Offset(0, 0),
        Offset(size.width, size.height),
      ),
      linePainter,
    );
  }

  @override
  bool shouldRepaint(BarlinePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BarlinePainter oldDelegate) => false;
}
