import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/elements/score/score.dart';
import 'package:music_notation/src/notation_painter/measure.dart';
import 'package:music_notation/src/notation_painter/music_grid.dart';

import 'package:music_notation/src/notation_painter/staff_painter_context.dart';
import 'package:music_notation/src/notation_painter/sync_width_column.dart';

class MusicNotationCanvas extends StatelessWidget {
  final ScorePartwise scorePartwise;
  final StaffPainterContext painterContext = StaffPainterContext();
  NotationGrid get grid => NotationGrid.fromScoreParts(
        scorePartwise.parts,
      );

  MusicNotationCanvas({
    super.key,
    required this.scorePartwise,
  });

  @override
  Widget build(BuildContext context) {
    // var staffs = <Widget>[];
    // var barlines = <Widget>[];
    var parts = <Row>[];

    // List<double> staffDistances = [];

    for (int i = 0; i < grid.data.rowCount; i++) {
      // var barlinePainter = BarlinePainter();

      // barlines.add(
      //   Positioned(
      //     top: staffDistances[i],
      //     left: 0,
      //     child: CustomPaint(
      //       size: BarlinePainter.size,
      //       painter: barlinePainter,
      //     ),
      //   ),
      // );
      var measures = <Widget>[];
      // Iterating throug measures/part.
      for (var j = 0; j < grid.data.columnCount; j++) {
        var measureSequence = grid.data.getValue(i, j);
        measures.add(
          Measure(
            sequence: measureSequence,
          ),
        );
      }

      parts.add(Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: measures,
      ));
    }
    return SyncWidthColumn(
      // mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: parts,
    );
  }
}
