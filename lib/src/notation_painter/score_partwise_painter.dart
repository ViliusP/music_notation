import 'package:flutter/rendering.dart';

import 'package:music_notation/src/models/elements/score/score.dart';
import 'package:music_notation/src/notation_painter/staff_painter.dart';

class ScorePartwisePainter extends CustomPainter {
  final ScorePartwise score;

  const ScorePartwisePainter(this.score);

  @override
  void paint(Canvas canvas, Size size) {
    StaffPainter(score: score).paint(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
