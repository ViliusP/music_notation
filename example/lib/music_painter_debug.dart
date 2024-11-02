import 'package:flutter/rendering.dart';

const double _staffLineSpacing = 20; // Distance between staff lines

class MusicPainter extends CustomPainter {
  MusicPainter();

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
    List<String> glyphs = [
      '\uE050',
      '\uE084',
      '\uE240',
      '\uE0A4',
      '\uE4E3',
      '\uE4E4',
      '\uE1D5',
      Accidentals
      // '\uD158',
    ];
    for (int i = 0; i < glyphs.length; i++) {
      // Set the font size to 4 times the staff spacing
      final textPainter = _bravuraPainter(glyphs[i]);

      // Position the notehead on the staff
      textPainter.layout();
      // For this example, we position it relative to the bottom line of the staff
      textPainter.paint(
        canvas,
        Offset(50 + i * 100, _staffLineSpacing),
      ); // E4 note on the bottom line
    }

    for (int i = 0; i < 3; i++) {
      // if ([0, 2].contains(i)) continue;
      // Set the font size to 4 times the staff spacing
      // double enlargeBy = 1;
      // final textPainter = _bravuraPainter('\uE0A4', enlargeBy);
      final textPainter = _bravuraPainter('\uE0A4');

      // Position the notehead on the staff
      textPainter.layout();
      // For this example, we position it relative to the bottom line of the staff
      textPainter.paint(
        canvas,
        Offset(80 + 6 * 100, (_staffLineSpacing * i)),
      ); // E4 note on the bottom line
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

TextPainter _bravuraPainter(String glyph, [double enlargeBy = 1.0]) {
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
          backgroundColor: Color.fromRGBO(255, 100, 2, 0.2)),
    ),
    textDirection: TextDirection.ltr,
  );
}
