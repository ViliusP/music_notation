import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/score/score.dart';
import 'package:music_notation/src/notation_painter/debug/debug_settings.dart';
import 'package:music_notation/src/notation_painter/measure/measure_barlines.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/measure/measure_grid.dart';
import 'package:music_notation/src/notation_painter/measure/notation_widgetization.dart';
import 'package:music_notation/src/notation_painter/measure/staff_lines.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/music_grid.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/properties/notation_properties.dart';
import 'package:music_notation/src/notation_painter/utilities/number_extensions.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

typedef _MeasureData = ({
  List<MeasureWidget> children,
  MeasureBarlines barlineSettings
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return DebugSettings(
      extraStaveLineCount: 0,
      extraStaveLines: ExtraStaveLines.none,
      child: Wrap(
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
      ),
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
        List<BarlineExtension>? startBarlines;
        List<BarlineExtension>? endBarlines;

        double leftPadding = 0;
        double rightPadding = 0;

        if (i == 0) {
          leftPadding = layoutProperties.staveSpace;
          startBarlines = values.map((value) => value.barlines.start).toList();
        }

        if (i == columnColumns.length - 1) {
          endBarlines = values.map((value) => value.barlines.end).toList();
        }
        if (!values.first.columns.keys.elementAt(i).isRhytmic ||
            i == columnColumns.length - 1) {
          rightPadding = layoutProperties.staveSpace;
        }

        return _MultiPartMeasuresColumn(
          columns: col,
          padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
          startBarlines: startBarlines,
          endBarlines: endBarlines,
        );
      }).toList(),
    );
  }
}

class _MultiPartMeasuresColumn extends StatelessWidget {
  final EdgeInsets? padding;
  final List<MeasureGridColumn> columns;
  final List<BarlineExtension>? startBarlines;
  final List<BarlineExtension>? endBarlines;

  const _MultiPartMeasuresColumn({
    super.key,
    required this.columns,
    this.padding,
    this.startBarlines,
    this.endBarlines,
  });

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    double width = 0;
    for (var cell in columns.expand((i) => i.values.entries)) {
      if (cell.value != null) {
        width = max(
          width,
          cell.value!.baseSize.width * layoutProperties.staveSpace,
        );
      }
    }

    // Temp fix for spaces between painted stave line
    width = width.ceilToDouble();

    return Column(
      children: columns.mapIndexed((i, column) {
        ({BarlineLocation location, BarlineExtension type})? barline;
        if (startBarlines?.elementAt(i) != null) {
          barline = (location: BarlineLocation.start, type: startBarlines![i]);
        } else if (endBarlines?.elementAt(i) != null) {
          barline = (location: BarlineLocation.end, type: endBarlines![i]);
        }

        return _MeasureColumn(
          column: column,
          width: width,
          padding: padding,
          barline: barline,
        );
      }).toList(),
    );
  }
}

class _MeasureColumn extends StatelessWidget {
  final EdgeInsets? padding;
  final MeasureGridColumn column;
  final double width;
  final ({BarlineLocation location, BarlineExtension type})? barline;

  const _MeasureColumn({
    super.key,
    required this.column,
    required this.width,
    this.padding,
    this.barline,
  });

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    double spacePerPosition = layoutProperties.spacePerPosition;
    ElementPosition bottomRef = column.values.keys.last;
    ElementPosition topRef = column.values.keys.first;
    const staveRef = ElementPosition(step: Step.E, octave: 4);
    double staveBottom = (staveRef.distance(bottomRef)) * spacePerPosition;

    return SizedBox(
      height: (topRef.numeric - bottomRef.numeric) * spacePerPosition,
      width: width + (padding?.horizontal ?? 0),
      child: Stack(
        fit: StackFit.loose,
        children: [
          if (barline != null)
            Barline(
              type: barline!.type,
              location: barline!.location,
              baseline: staveBottom,
              baseHeight: layoutProperties.staveHeight,
            ),
          Positioned(
            bottom: staveBottom,
            child: SizedBox(
              width: double.maxFinite,
              child: StaffLines(),
            ),
          ),
          ...column.values.entries
              .where((cell) => cell.value != null)
              .map((cell) {
            var element = cell.value!;

            ElementPosition pos = element.position;
            AlignmentPosition alignment = element.alignmentPosition;
            double? top;
            double? bottom;

            if (alignment.top == null) {
              bottom = alignment.bottom!.scaledByContext(context);
              bottom += bottomRef.distance(pos) * spacePerPosition;
            } else {
              top = alignment.top!.scaledByContext(context);
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
