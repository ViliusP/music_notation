import 'package:flutter/rendering.dart';

class PainterUtilities {
  static void drawSmuflSymbol(
    Canvas canvas,
    String symbol, {
    Offset offset = Offset.zero,
  }) {
    const textStyle = TextStyle(
      fontFamily: 'Sebastian',
      fontSize: 48,
      color: Color.fromRGBO(0, 0, 0, 1.0),
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
