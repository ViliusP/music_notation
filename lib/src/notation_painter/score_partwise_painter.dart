import 'package:flutter/rendering.dart';
import 'package:music_notation/src/models/elements/score/score.dart';

class ScorePartwisePainter extends CustomPainter {
  final ScorePartwise score;

  ScorePartwisePainter(this.score);

  @override
  void paint(Canvas canvas, Size size) {
    // Logic to paint the score goes here
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
