import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/elements/score/score.dart';
import 'package:music_notation/src/notation_painter/staff_lines_painter.dart';

class MusicNotationCanvas extends StatelessWidget {
  final ScorePartwise scorePartwise;

  const MusicNotationCanvas({
    super.key,
    required this.scorePartwise,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ScorePartwisePainter(
        score: scorePartwise,
      ),
      size: const Size(double.infinity, double.infinity),
    );
  }
}
