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
  final GlyphBBox? glyphBBox;

  SmuflPainter(this.glyph, [this.glyphBBox]);

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = _leLandPainter(glyph.codepoint);

    // Position the notehead on the staff
    textPainter.layout();
    // For this example, we position it relative to the bottom line of the staff
    textPainter.paint(
      canvas,
      Offset(0, 0),
    );
    if (glyphBBox != null) {
      final paint = Paint()
        ..color = Color.fromRGBO(0, 0, 0, 0.1)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      canvas.drawRect(
        Rect.fromPoints(
          Offset(0, 0),
          Offset(size.width, size.height),
        ),
        paint,
      );
    }
    if (glyphBBox != null) {
      final paint = Paint()
        ..color = Color.fromRGBO(0, 0, 0, 0.5)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      Offset o1 =
          fromCoordinates(c1(glyphBBox!)).scale(20, 20).translate(0, 40);
      Offset o2 =
          fromCoordinates(c2(glyphBBox!)).scale(20, 20).translate(0, 40);

      canvas.drawRect(
        Rect.fromPoints(o1, o2),
        paint,
      );
    }
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

  // Coordinates c1(GlyphBBox bBox) {
  //   Coordinates ne = bBox.bBoxNE;
  //   Coordinates sw = bBox.bBoxSW;

  //   // Calculate NW point in the original Cartesian coordinate system
  //   Coordinates nw = Coordinates(x: sw.x, y: ne.y);
  //   // Shift coordinates by minX and minY (bottom-left corner) to make all values non-negative
  //   double minX = sw.x;
  //   double minY = sw.y;

  //   return Coordinates(x: nw.x - minX, y: nw.y - minY);
  // }

  // Coordinates c2(GlyphBBox bBox) {
  //   Coordinates ne = bBox.bBoxNE;
  //   Coordinates sw = bBox.bBoxSW;

  //   // Calculate SE point in the original Cartesian coordinate system
  //   Coordinates se = Coordinates(x: ne.x, y: sw.y);

  //   // Shift coordinates by minX and minY (bottom-left corner) to make all values non-negative
  //   double minX = sw.x;
  //   double minY = sw.y;

  //   return Coordinates(x: se.x - minX, y: se.y - minY);
  // }

  TextPainter _leLandPainter(String glyph, [double enlargeBy = 1.0]) {
    return TextPainter(
      text: TextSpan(
        text: glyph, // Example notehead (G clef) from SMuFL font
        style: TextStyle(
            fontFamily: 'Leland',
            fontSize: _staffLineSpacing *
                4 *
                enlargeBy, // Corrected font size for notehead
            color: Color.fromRGBO(0, 0, 0, 1),
            height: 1,
            // textBaseline: TextBaseline.ideographic,
            // decoration: TextDecoration.underline,
            backgroundColor: Color.fromRGBO(255, 100, 2, 0.05)),
      ),
      textDirection: TextDirection.ltr,
    );
  }
}
