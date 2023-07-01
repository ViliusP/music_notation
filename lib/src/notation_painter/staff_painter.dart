import 'package:flutter/material.dart';
import 'package:music_notation/src/models/elements/score/score.dart';

class StaffPainter extends CustomPainter {
  final ScorePartwise score;

  /// Settings
  static const double staffHeight = 48;
  static const lineSpacing = staffHeight / 4;
  static const int _staffLines = 5;
  static const double _staffLineStrokeWidth = 1;
  static const bool debugFrame = false;

  StaffPainter({
    required this.score,
  });

  final Paint _linePaint = Paint()
    ..color = const Color.fromRGBO(0, 0, 0, 1.0)
    ..strokeWidth = _staffLineStrokeWidth;

  final Paint _axisPaint = Paint()
    ..color = Colors.redAccent
    ..strokeWidth = 1.0;

  static const List<String> clefSymbols = [
    '\uE050', // Treble Clef -5 y offset
    '\uE062', // Bass Clef
    '\uE05C', // Tenor Clef
    '\uE058', // Alto Clef
    '\uE063', // Percussion Clef
    '\uE057', // Soprano Clef
    '\uE059', // Mezzo-soprano Clef
    '\uE05E', // Baritone Clef
    '\uE055', // French Violin Clef
    '\uE061', // Tab Clef
    '\uE05F', // Neutral Clef
    '\uE1D6',
    '\uE1DC',
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (var (i, symbol) in clefSymbols.indexed) {
      drawSmuflSymbol(canvas, Offset((i + 1) * 50, -5), symbol);
    }

    _paintStaffLines(canvas, size);
    debugFrame ? paintCoordinates(canvas, size) : () {};
  }

  void _paintStaffLines(Canvas canvas, Size size) {
    var lineY = 0.0;
    for (var i = 0; i < _staffLines; i++) {
      canvas.drawLine(
        Offset(0, lineY),
        Offset(size.width, lineY),
        Paint()
          ..color = Colors.black
          ..strokeWidth = _staffLineStrokeWidth,
      );
      lineY = (i + 1) * (lineSpacing);
    }
  }

  void paintCoordinates(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(0, size.height - 10),
      Offset(size.width, size.height - 10),
      _axisPaint,
    );
    for (double i = 0; i < size.width; i += 12) {
      canvas.drawLine(
        Offset(i, size.height - 12),
        Offset(i, size.height - 24),
        _axisPaint,
      );
    }

    for (double i = 0; i < size.height; i += 12) {
      canvas.drawLine(
        Offset(12, i),
        Offset(24, i),
        _axisPaint,
      );
    }

    // Draw y-axis
    canvas.drawLine(
      const Offset(10, 0),
      Offset(10, size.height),
      _axisPaint,
    );
  }

  void drawSmuflSymbol(
    Canvas canvas,
    Offset offset,
    String symbol, [
    double fontSize = 48,
  ]) {
    final textStyle = TextStyle(
      fontFamily: 'Sebastian',
      fontSize: fontSize,
      color: const Color.fromRGBO(0, 0, 0, 1.0),
    );
    final textPainter = TextPainter(
      text: TextSpan(text: symbol, style: textStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final borderRect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      textPainter.width + 8.0,
      textPainter.height + 8.0,
    );
    if (debugFrame) {
      final borderPaint = Paint()
        ..color = Colors.pinkAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawRect(borderRect, borderPaint);
    }
    textPainter.paint(
      canvas,
      Offset(offset.dx, offset.dy),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
