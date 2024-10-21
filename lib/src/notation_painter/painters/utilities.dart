import 'package:flutter/rendering.dart';

import 'package:music_notation/music_notation.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';

class PainterUtilities {
  static void drawSmuflSymbol(
    Canvas canvas,
    String symbol, {
    Offset offset = const Offset(0, -NotationLayoutProperties.staveSpace * 1.5),
    Color color = const Color.fromRGBO(0, 0, 0, 1.0),
  }) {
    TextStyle textStyle = TextStyle(
      fontFamily: 'Bravura',
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
}
