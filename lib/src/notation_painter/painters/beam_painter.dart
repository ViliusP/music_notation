import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';

class BeamPainter extends CustomPainter {
  final bool downward;
  final Color? color;

  BeamPainter({this.color, required this.downward});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ?? const Color.fromRGBO(0, 0, 0, 1)
      ..strokeWidth = 0;

    double beamThickness = NotationLayoutProperties.beamThickness;
    final Path path = Path();
    if (!downward) {
      path.moveTo(0, size.height - beamThickness);
      path.relativeLineTo(0, beamThickness);
      path.lineTo(size.width, beamThickness);
      path.lineTo(size.width, 0);
    }
    if (downward) {
      path.moveTo(0, 0);
      path.relativeLineTo(0, beamThickness);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, size.height - beamThickness);
      paint.color = const Color.fromRGBO(255, 100, 0, 0.5);
    }

    // Draw the path (now flipped if `flip` is true)
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BeamPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BeamPainter oldDelegate) => false;
}
