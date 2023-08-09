import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/elements/score/score.dart';
import 'package:music_notation/src/notation_painter/measure.dart';
import 'package:music_notation/src/notation_painter/music_grid.dart';

import 'package:music_notation/src/notation_painter/staff_painter_context.dart';

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
    var barlines = <Widget>[];
    var parts = <Widget>[];

    List<double> staffDistances = [];

    final List<double> alignments = [0.2, -0.5, 0.7];

    double maxAlignment = alignments
        .reduce((value, element) => value > element ? value : element);

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
            alignment: maxAlignment,
            sequence: measureSequence,
          ),
        );
      }

      parts.add(Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: measures,
      ));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: parts,
    );
  }
}
