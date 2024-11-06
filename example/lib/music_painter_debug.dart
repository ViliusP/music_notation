import 'package:flutter/rendering.dart';
import 'package:music_notation/music_notation.dart';

const double _staffLineSpacing = 20; // Distance between staff lines

class StaffPainter extends CustomPainter {
  StaffPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromRGBO(0, 0, 0, 1)
      ..strokeWidth = 2.0;

    // Draw the five staff lines
    for (int i = 0; i < 5; i++) {
      double y = i * _staffLineSpacing;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class SmuflPainter extends CustomPainter {
  final SmuflGlyph glyph;
  final GlyphBBox glyphBBox;

  SmuflPainter(this.glyph, this.glyphBBox);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromRGBO(0, 0, 0, 0.5)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Calculate initial black box positions based on bounding box, scaled and translated by (0, 40)
    Offset o1 = fromCoordinates(c1(glyphBBox)).scale(20, 20).translate(0, 40);
    Offset o2 = fromCoordinates(c2(glyphBBox)).scale(20, 20).translate(0, 40);

    // Determine the top edge of the black box after the initial starting offset
    double blackBoxTop = o1.dy;

    // Reference top edge of the blue box, which remains at y = 0
    double blueBoxTop = 0;

    // Calculate the additional vertical offset to align black box’s top with the blue box’s top
    double verticalOffset = blueBoxTop - blackBoxTop;
    double horizontalOffset = 0 - o1.dx;

    // Apply the calculated alignment offset on top of the initial starting position
    o1 = o1.translate(0, verticalOffset);
    o2 = o2.translate(0, verticalOffset);

    // Apply the calculated alignment offset on top of the initial starting position
    o1 = o1.translate(horizontalOffset, 0);
    o2 = o2.translate(horizontalOffset, 0);

    // Draw the black box with adjusted offsets for alignment
    canvas.drawRect(
      Rect.fromPoints(o1, o2),
      paint,
    );

    // Draw the fixed blue box as a reference (does not move)
    canvas.drawRect(
      Rect.fromPoints(
        Offset(0, 0),
        Offset(size.width, size.height),
      ),
      paint
        ..color = Color.fromRGBO(0, 4, 255, 0.301)
        ..strokeWidth = 2,
    );

    final textPainter = _leLandPainter(glyph.codepoint);

    // Position the notehead on the staff
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(horizontalOffset.floorToDouble(), verticalOffset.floorToDouble()),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  Offset fromCoordinates(Coordinates c) {
    return Offset(c.x, c.y);
  }

  Coordinates c1(GlyphBBox bBox) {
    Coordinates ne = bBox.bBoxNE;
    Coordinates sw = bBox.bBoxSW;

    // Calculate NW point in the original Cartesian coordinate system
    Coordinates nw = Coordinates(x: sw.x, y: -ne.y);

    return nw;
  }

  Coordinates c2(GlyphBBox bBox) {
    Coordinates ne = bBox.bBoxNE;
    Coordinates sw = bBox.bBoxSW;

    // Calculate SE point in the original Cartesian coordinate system
    Coordinates se = Coordinates(x: ne.x, y: -sw.y);

    return se;
  }

  TextPainter _leLandPainter(String glyph, [double enlargeBy = 1.0]) {
    return TextPainter(
      text: TextSpan(
        text: glyph,
        style: TextStyle(
            fontFamily: 'Leland',
            fontSize: _staffLineSpacing * 4 * enlargeBy,
            color: Color.fromRGBO(0, 0, 0, 1),
            height: 1,
            backgroundColor: Color.fromRGBO(255, 32, 2, 0)),
      ),
      textDirection: TextDirection.ltr,
    );
  }
}
