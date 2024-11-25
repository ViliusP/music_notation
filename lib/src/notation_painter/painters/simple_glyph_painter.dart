import 'package:flutter/rendering.dart';

import 'package:music_notation/src/notation_painter/painters/utilities.dart';
import 'package:music_notation/src/notation_painter/utilities/number_extensions.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

class SimpleGlyphPainter extends CustomPainter {
  final String smufl;
  final GlyphBBox bBox;

  // Stave space
  final double height;

  SimpleGlyphPainter(this.smufl, this.bBox, this.height);

  @override
  void paint(Canvas canvas, Size size) {
    drawSmuflSymbol(canvas, smufl, bBox, height);
  }

  @override
  bool shouldRepaint(SimpleGlyphPainter oldDelegate) {
    return oldDelegate.bBox != bBox || oldDelegate.smufl != smufl;
  }

  @override
  bool shouldRebuildSemantics(SimpleGlyphPainter oldDelegate) => false;

  static void drawSmuflSymbol(
    Canvas canvas,
    String symbol,
    GlyphBBox bBox,
    double height, {
    Color color = const Color.fromRGBO(0, 0, 0, 1.0),
    bool drawBBox = false,
  }) {
    // -------------------------
    // BBox painting
    // --------------------------
    final paint = Paint()
      ..color = Color.fromRGBO(0, 0, 0, 0.5)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    var (o1, o2) = bBox.toOffsets();

    o1 = o1.scale(height, height).translate(0, height * 2);

    double verticalOffset = -o1.dy.roundTowardsZero();
    double horizontalOffset = -(o1.dx.roundAwayFromZero());

    if (drawBBox) {
      o2 = o2.scale(height, height).translate(0, height * 2);

      canvas.drawRect(
        Rect.fromPoints(
          o1.translate(horizontalOffset, verticalOffset),
          o2.translate(horizontalOffset, verticalOffset),
        ),
        paint,
      );
    }
    // -------------------------
    // Glyph painting
    // --------------------------
    TextStyle textStyle = TextStyle(
      fontFamily: 'Leland',
      fontSize: height * 4,
      color: color,
      // backgroundColor: Color.fromRGBO(124, 100, 0, 0.2),
      height: 1,
    );
    final textPainter = TextPainter(
      text: TextSpan(text: symbol, style: textStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(horizontalOffset, verticalOffset),
    );
  }
}
