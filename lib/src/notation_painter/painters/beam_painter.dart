import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';

class BeamPainter extends CustomPainter {
  BeamPainter();

  @override
  void paint(Canvas canvas, Size size) {
    double beamThickness = NotationLayoutProperties.beamThickness;
    final Path path = Path();
    path.moveTo(0, 0);
    path.relativeLineTo(0, beamThickness);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height - beamThickness);
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
