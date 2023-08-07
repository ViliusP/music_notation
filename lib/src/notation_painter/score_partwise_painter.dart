import 'package:flutter/rendering.dart';

import 'package:music_notation/src/models/elements/score/score.dart';
import 'package:music_notation/src/notation_painter/music_grid.dart';
import 'package:music_notation/src/notation_painter/staff_lines_painter.dart';

class ScorePartwisePainter extends CustomPainter {
  final ScorePartwise score;
  NotationGrid get notationGrid => NotationGrid.fromScoreParts(
        score.parts,
      );

  const ScorePartwisePainter({required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    StaffPainter(score: score, notationGrid: notationGrid).paint(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
