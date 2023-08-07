import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/elements/score/score.dart';
import 'package:music_notation/src/notation_painter/measure.dart';
import 'package:music_notation/src/notation_painter/music_grid.dart';
import 'package:music_notation/src/notation_painter/painters/barline_painter.dart';
import 'package:music_notation/src/notation_painter/staff_lines_painter.dart';
import 'package:music_notation/src/notation_painter/staff_painter_context.dart';

class MusicNotationCanvas extends StatelessWidget {
  final ScorePartwise scorePartwise;
  NotationGrid get grid => NotationGrid.fromScoreParts(
        scorePartwise.parts,
      );

  const MusicNotationCanvas({
    super.key,
    required this.scorePartwise,
  });

  @override
  Widget build(BuildContext context) {
    var context = StaffPainterContext();

    var staffs = <Widget>[];
    var barlines = <Widget>[];
    var measures = <Widget>[];

    List<double> staffDistances = [];
    for (int i = 0; i < grid.data.rowCount; i++) {
      staffDistances.add(context.offset.dy);
      // double staffLength = 0;

      var barlinePainter = BarlinePainter();

      barlines.add(
        Positioned(
          top: context.offset.dy,
          left: context.offset.dx,
          child: CustomPaint(
            size: barlinePainter.size,
            painter: barlinePainter,
          ),
        ),
      );
      context.moveX(12);

      // Iterating throug measures/part.
      for (var j = 0; j < grid.data.columnCount; j++) {
        var measureSequence = grid.data.getValue(i, j);
        measures.add(
          Positioned(
            top: context.offset.dy,
            left: context.offset.dx,
            child: Measure(sequence: measureSequence),
          ),
        );
        barlines.add(
          Positioned(
            top: context.offset.dy,
            left: context.offset.dx,
            child: CustomPaint(
              size: barlinePainter.size,
              painter: barlinePainter,
            ),
          ),
        );
        if (j != grid.data.columnCount - 1) {
          context.moveX(12);
        }
      }

      var staffLinePainter = StaffLinesPainter(context.offset.dx);

      staffs.add(
        Positioned(
          top: staffDistances[i],
          child: CustomPaint(
            size: staffLinePainter.size,
            painter: staffLinePainter,
          ),
        ),
      );
      context.resetX();
      context.moveY(120);
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        ...staffs,
        ...barlines,
      ],
    );
  }
}
