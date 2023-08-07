import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/elements/music_data/print.dart';
import 'package:music_notation/src/models/elements/score/score.dart';
import 'package:music_notation/src/notation_painter/music_grid.dart';
import 'package:music_notation/src/notation_painter/staff_lines_painter.dart';

class MusicNotationCanvas extends StatelessWidget {
  final ScorePartwise scorePartwise;
  NotationGrid get notationGrid => NotationGrid.fromScoreParts(
        scorePartwise.parts,
      );

  const MusicNotationCanvas({
    super.key,
    required this.scorePartwise,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> staffs = [];
    List<double> staffDistances = [];
    for (int i = 0; i < notationGrid.data.rowCount; i++) {
      double staffDistance = 0;
      // ...some calculations.
      staffDistance = i * 100;

      staffDistances.add(staffDistance);
      double staffLength = 0;
      // ...some calculations.
      staffLength = 500;

      var staffLinePainter = StaffLinesPainter(staffLength);

      staffs.add(
        Positioned(
          top: staffDistances[i],
          child: CustomPaint(
            size: staffLinePainter.size,
            painter: staffLinePainter,
          ),
        ),
      );
    }
    return Stack(
      children: [
        ...staffs,
      ],
    );
  }
}
