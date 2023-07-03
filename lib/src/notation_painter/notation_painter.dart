import 'package:flutter/rendering.dart';

void paintNote(Canvas canvas, Offset position) {
  const textStyle = TextStyle(
    fontFamily: 'Sebastian', // name of your SMuFL font
    fontSize: 24,
  );

  final textSpan = TextSpan(
    text: String.fromCharCode(0xE1D2), // Unicode for quarter note in SMuFL
    style: textStyle,
  );

  final textPainter = TextPainter(
    text: textSpan,
    textDirection: TextDirection.ltr,
  );

  textPainter.layout();
  textPainter.paint(canvas, position);
}

class NotePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final position = Offset(size.width / 2, size.height / 2);
    paintNote(canvas, position);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
