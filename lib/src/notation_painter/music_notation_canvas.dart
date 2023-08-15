import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/elements/score/score.dart';
import 'package:music_notation/src/notation_painter/measure_layout.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/music_grid.dart';

import 'package:music_notation/src/notation_painter/sync_width_column.dart';

class MusicNotationCanvas extends StatelessWidget {
  final ScorePartwise scorePartwise;
  NotationGrid get grid => NotationGrid.fromScoreParts(
        scorePartwise.parts,
      );

  MusicNotationCanvas({
    super.key,
    required this.scorePartwise,
  });

  @override
  Widget build(BuildContext context) {
    var parts = <Row>[];

    for (int i = 0; i < grid.data.rowCount; i++) {
      var measures = <MeasureLayout>[];

      for (var j = 0; j < grid.data.columnCount; j++) {
        var measure = MeasureLayout.fromMeasureData(
          measure: grid.data.getValue(i, j),
          staff: grid.staffForRow(i),
          notationContext: j != 0
              ? measures.last.contextAfter
              : NotationContext(
                  divisions: null,
                  clef: null,
                  time: null,
                ),
        );

        measures.add(measure);
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
