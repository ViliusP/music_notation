import 'package:flutter/rendering.dart';

class BeamPainter extends CustomPainter {
  final Offset secondPoint;

  BeamPainter({
    required this.secondPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const p1 = Offset(0, 0);
    final p2 = secondPoint;
    final paint = Paint()
      ..color = Color.fromRGBO(0, 0, 0, 1)
      ..strokeWidth = 4;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(BeamPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BeamPainter oldDelegate) => false;
}
