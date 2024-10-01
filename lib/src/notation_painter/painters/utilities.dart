import 'package:flutter/rendering.dart';

class PainterUtilities {
  static void drawSmuflSymbol(
    Canvas canvas,
    String symbol, {
    Offset offset = Offset.zero,
    Color color = const Color.fromRGBO(0, 0, 0, 1.0),
  }) {
    TextStyle textStyle = TextStyle(
      fontFamily: 'Sebastian',
      fontSize: 48,
      color: color,
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
