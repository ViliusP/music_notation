import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/elements/score/score.dart';
import 'package:music_notation/src/notation_painter/debug/debug_settings.dart';
import 'package:music_notation/src/notation_painter/measure/measure_barlines.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/measure/measure_grid.dart';
import 'package:music_notation/src/notation_painter/measure/measure_layout.dart';
import 'package:music_notation/src/notation_painter/measure/notation_widgetization.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/music_grid.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

typedef _MeasureData = ({
  List<MeasureElement> children,
  MeasureBarlines barlineSettings,
  double divisions,
});

class MusicSheet extends StatelessWidget {
  final MusicSheetGrid grid;

  final FontMetadata font;

  const MusicSheet._({
    super.key,
    required this.grid,
    required this.font,
  });

  factory MusicSheet.fromScore({
    Key? key,
    required ScorePartwise score,
    required FontMetadata font,
  }) {
    var grid = RawMeasureGrid.fromScoreParts(score.parts);
    MusicSheetGrid musicSheetGrid = MusicSheetGrid(grid.data.rowCount);
    var contexts = List.generate(
      grid.data.rowCount,
      (_) => NotationContext.empty(),
    );
    for (int j = 0; j < grid.data.columnCount; j++) {
      List<_MeasureData> col = [];
      for (var i = 0; i < grid.data.rowCount; i++) {
        int? staff = grid.staffForRow(i);

        var barlineSettings = MeasureBarlines.fromGridData(
          gridX: j,
          gridY: i,
          maxX: grid.data.columnCount,
          maxY: grid.data.rowCount,
          staff: staff ?? 1,
          staffCount: grid.staffCount(i) ?? 1,
        );

        var children = NotationWidgetization.widgetsFromMeasure(
          context: contexts[i],
          staff: staff,
          measure: grid.data.getValue(i, j),
          font: font,
        );

        contexts[i] = contexts[i].afterMeasure(
          staff: staff,
          measure: grid.data.getValue(i, j),
        );

        col.add((
          children: children,
          barlineSettings: barlineSettings,
          divisions: contexts[i].divisions!,
        ));
      }
      var colMeasures = <MeasureGrid>[];

      for (var data in col) {
        var measure = MeasureGrid.fromMeasureWidgets(
          barlineSettings: data.barlineSettings,
          children: data.children,
          divisions: data.divisions,
        );
        colMeasures.add(measure);
      }
      musicSheetGrid.add(colMeasures);
    }

    return MusicSheet._(
      key: key,
      grid: musicSheetGrid,
      font: font,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DebugSettings(
      paintBBoxAboveStaff: false,
      paintBBoxBelowStaff: false,
      extraStaveLineCount: 0,
      verticalStaveLineSpacingMultiplier: 0,
      extraStaveLines: ExtraStaveLines.none,
      beatMarkerMultiplier: 1,
      beatMarker: false,
      alignmentDebugOptions: {
        // AlignmentDebugOption.bottom,
        // AlignmentDebugOption.bottomEffective,
        // AlignmentDebugOption.top,
        // AlignmentDebugOption.topEffective,
      },
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        spacing: 0,
        runAlignment: WrapAlignment.start,
        runSpacing: 0,
        crossAxisAlignment: WrapCrossAlignment.start,
        textDirection: TextDirection.ltr,
        verticalDirection: VerticalDirection.down,
        clipBehavior: Clip.none,
        children: grid.values
            .mapIndexed((i, col) => _SheetMeasuresColumn(
                  number: i,
                  values: col,
                ))
            .toList(),
      ),
    );
  }
}

class _SheetMeasuresColumn extends StatelessWidget {
  final int number;
  final List<MeasureGrid> values;

  const _SheetMeasuresColumn({
    super.key,
    required this.values,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: values
          .map((value) => MeasureLayout(
                grid: value,
                barlineSettings: MeasureBarlines(
                  start: number == 0 ? value.barlines.start : null,
                  end: value.barlines.end,
                ),
                widths: MusicSheetGrid.widthsByPosition(values),
              ))
          .toList(),
    );
  }
}
