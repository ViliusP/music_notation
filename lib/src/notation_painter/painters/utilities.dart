import 'package:flutter/rendering.dart';

import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

class PainterUtilities {
  static void drawSmuflSymbol(
    Canvas canvas,
    String symbol, {
    Offset offset = const Offset(
      0,
      (-NotationLayoutProperties.staveSpace * 1.5),
    ),
    Color color = const Color.fromRGBO(0, 0, 0, 1.0),
  }) {
    TextStyle textStyle = TextStyle(
      fontFamily: 'Leland',
      fontSize: NotationLayoutProperties.staveHeight,
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
      offset,
    );
  }

  static void drawSmuflSymbolV2(
    Canvas canvas,
    String symbol,
    GlyphBBox bBox, {
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

    o1 = o1
        .scale(
          NotationLayoutProperties.staveSpace,
          NotationLayoutProperties.staveSpace,
        )
        .translate(0, NotationLayoutProperties.staveHeight / 2);

    o2 = o2
        .scale(
          NotationLayoutProperties.staveSpace,
          NotationLayoutProperties.staveSpace,
        )
        .translate(0, NotationLayoutProperties.staveHeight / 2);

    double verticalOffset = -o1.dy.ceilToDouble();

    if (drawBBox) {
      canvas.drawRect(
        Rect.fromPoints(
          o1.translate(0, verticalOffset),
          o2.translate(0, verticalOffset),
        ),
        paint,
      );
    }
    // -------------------------
    // Glyph painting
    // --------------------------
    TextStyle textStyle = TextStyle(
      fontFamily: 'Leland',
      fontSize: NotationLayoutProperties.staveHeight,
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
      Offset(0, verticalOffset),
    );
  }
}

extension FontPainting on GlyphBBox {
  Rect toRect([double staveSpace = NotationLayoutProperties.staveSpace]) {
    return Rect.fromPoints(
      Offset(
        topRight.x * staveSpace,
        48 - staveSpace * (topRight.y - bottomLeft.y),
      ),
      Offset(bottomLeft.x * staveSpace, 48),
    );
  }

  /// This function takes a `GlyphBBox` object and converts its bounding box coordinates
  /// from the Cartesian coordinate system used by SMuFL to the Flutter coordinate system.
  /// The Flutter coordinate system has the Y-axis inverted relative to Cartesian coordinates:
  /// in Cartesian, Y increases upwards; in Flutter, Y increases downwards.
  ///
  /// Returns tuple, where
  /// `o1` (first value of [Offset]) represents the NW corner;
  /// `o2` (second value of [Offset]) represents the SE corner.
  (Offset, Offset) toOffsets() {
    Coordinates ne = bBoxNE;
    Coordinates sw = bBoxSW;

    // Calculate the north-west (NW) corner in Flutter's coordinate system.
    // - `sw.x` is used for the X-coordinate (left side in Cartesian),
    // - `-ne.y` is used for the Y-coordinate to flip the Y-axis (top in Cartesian).
    Offset o1 = Offset(sw.x, -ne.y);

    // Calculate the south-east (SE) corner in Flutter's coordinate system.
    // - `ne.x` is used for the X-coordinate (right side in Cartesian),
    // - `-sw.y` is used for the Y-coordinate to flip the Y-axis (bottom in Cartesian).
    Offset o2 = Offset(ne.x, -sw.y);

    return (o1, o2);
  }
}
