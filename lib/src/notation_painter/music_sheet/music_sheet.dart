import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/score/score.dart';
import 'package:music_notation/src/notation_painter/measure/barline_painting.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/measure/measure_grid.dart';
import 'package:music_notation/src/notation_painter/measure/notation_widgetization.dart';
import 'package:music_notation/src/notation_painter/measure/staff_lines.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/music_grid.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/properties/notation_properties.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

typedef _MeasureData = ({
  List<MeasureWidget> children,
  BarlineSettings barlineSettings
});

class MusicSheet extends StatelessWidget {
  final MusicSheetGrid grid;

  final FontMetadata font;

  final NotationLayoutProperties layoutProperties;

  const MusicSheet._({
    super.key,
    required this.grid,
    required this.font,
    required this.layoutProperties,
  });

  factory MusicSheet.fromScore({
    Key? key,
    required ScorePartwise score,
    required FontMetadata font,
    NotationLayoutProperties layoutProperties =
        const NotationLayoutProperties.standard(),
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

        var barlineSettings = BarlineSettings.fromGridData(
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

        col.add((children: children, barlineSettings: barlineSettings));

        contexts[i] = NotationWidgetization.contextFromWidgets(
          children,
          contexts[i],
        );
      }
      var colMeasures = <MeasureGrid>[];

      for (var data in col) {
        var measure = MeasureGrid.fromMeasureWidgets(
          barlineSettings: data.barlineSettings,
          children: data.children,
        );
        colMeasures.add(measure);
      }
      musicSheetGrid.add(colMeasures);
    }

    return MusicSheet._(
      key: key,
      grid: musicSheetGrid,
      font: font,
      layoutProperties: layoutProperties,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      spacing: 0,
      runAlignment: WrapAlignment.start,
      runSpacing: 0,
      crossAxisAlignment: WrapCrossAlignment.start,
      textDirection: TextDirection.ltr,
      verticalDirection: VerticalDirection.up,
      clipBehavior: Clip.none,
      children: grid.values
          .map((col) => _SheetMeasuresColumn(
                values: col,
              ))
          .toList(),
    );
  }
}

class _SheetMeasuresColumn extends StatelessWidget {
  final List<MeasureGrid> values;

  const _SheetMeasuresColumn({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    List<List<MeasureGridColumn>> columnColumns = MeasureGrid.toMeasureColumns(
      values,
    );

    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    return Row(
      children: columnColumns.mapIndexed((i, col) {
        double leftPadding = 0;
        double rightPadding = 0;

        if (!values.first.columns.keys.elementAt(i).isRhytmic ||
            i == columnColumns.length - 1) {
          rightPadding = layoutProperties.staveSpace;
        }
        if (i == 0) {
          leftPadding = layoutProperties.staveSpace;
        }
        return _MeasureColumn(
          columns: col,
          padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
        );
      }).toList(),
    );
  }
}

class _MeasureColumn extends StatelessWidget {
  final EdgeInsets? padding;
  final List<MeasureGridColumn> columns;

  const _MeasureColumn({
    super.key,
    required this.columns,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    var flattend = columns.expand((i) => i.values.entries).toList();

    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    double spacePerPosition = layoutProperties.spacePerPosition;
    ElementPosition bottomRef = columns.first.values.keys.last;
    ElementPosition topRef = columns.first.values.keys.first;
    const staveRef = ElementPosition(step: Step.F, octave: 4);

    double width = 0;
    for (var cell in flattend) {
      if (cell.value != null) {
        width = max(
          width,
          cell.value!.baseSize.width * layoutProperties.staveSpace,
        );
      }
    }
    width += padding?.horizontal ?? 0;

    return SizedBox(
      height: columns.first.values.length * spacePerPosition,
      width: width,
      child: Stack(
        fit: StackFit.loose,
        children: [
          Positioned(
            bottom: staveRef.distance(bottomRef) * spacePerPosition,
            child: StaffLines(),
          ),
          ...flattend.where((cell) => cell.value != null).map((cell) {
            var element = cell.value!;

            ElementPosition pos = element.position;
            AlignmentPosition alignment = element.alignmentPosition;
            double? top;
            double? bottom;

            if (alignment.top == null) {
              bottom = -alignment.bottom!;
              bottom += pos.distance(bottomRef) * spacePerPosition;
            } else {
              top = alignment.top!;
              top += topRef.distance(pos) * spacePerPosition;
            }

            return Positioned(
              left: padding?.left ?? 0,
              top: top,
              bottom: bottom,
              child: element,
            );
          })
        ],
      ),
    );
  }
}
