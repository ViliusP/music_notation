import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';

class BeamPainter extends CustomPainter {
  final Offset secondPoint;

  BeamPainter({
    required this.secondPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double beamWidth = NotationLayoutProperties.beamThickness;

    final p2 = secondPoint;
    final Path path = Path();
    path.moveTo(0, 0);
    path.relativeLineTo(0, beamWidth);
    path.lineTo(p2.dx, p2.dy + beamWidth);
    path.lineTo(p2.dx, p2.dy);
    path.close();
    final paint = Paint()
      ..color = Color.fromRGBO(129, 0, 0, .5)
      ..strokeWidth = 0;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BeamPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BeamPainter oldDelegate) => false;
}
