import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';

class BeamPainter extends CustomPainter {
  final bool flip;
  final Color? color;

  BeamPainter({this.color, this.flip = false});

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
      ..color = color ?? const Color.fromRGBO(0, 0, 0, 1)
      ..strokeWidth = 0;

    if (flip) {
      // Center the flip to avoid shifting the entire coordinate system
      canvas.translate(size.width / 2, size.height / 2);
      // Flip vertically, or use (-1, 1) for horizontal flip
      canvas.scale(1, -1);
      // Restore translation
      canvas.translate(-size.width / 2, -size.height / 2);
    }

    // Draw the path (now flipped if `flip` is true)
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BeamPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BeamPainter oldDelegate) => false;
}
