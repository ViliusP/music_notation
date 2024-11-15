import 'package:flutter/material.dart';
import 'package:music_notation/src/models/elements/score/score.dart';
import 'package:music_notation/src/notation_painter/measure/barline_painting.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/measure/measure_layout.dart';
import 'package:music_notation/src/notation_painter/measure/notation_widgetization.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/music_grid.dart';
import 'package:music_notation/src/notation_painter/music_sheet/grid.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/properties/notation_properties.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

typedef _MeasureData = ({
  List<MeasureWidget> children,
  BarlineSettings barlineSettings
});

class MusicSheet extends StatelessWidget {
  final List<List<MeasureLayout>> parts;

  final FontMetadata font;

  final NotationLayoutProperties layoutProperties;

  const MusicSheet._({
    super.key,
    required this.parts,
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
    List<List<MeasureLayout>> parts = [];

    for (int i = 0; i < grid.data.rowCount; i++) {
      NotationContext lastNotationContext = NotationContext.empty();
      int? staff = grid.staffForRow(i);
      List<_MeasureData> row = [];

      for (var j = 0; j < grid.data.columnCount; j++) {
        var barlineSettings = BarlineSettings.fromGridData(
          gridX: j,
          gridY: i,
          maxX: grid.data.columnCount,
          maxY: grid.data.rowCount,
          staff: staff ?? 1,
          staffCount: grid.staffCount(i) ?? 1,
        );

        var children = NotationWidgetization.widgetsFromMeasure(
          context: lastNotationContext,
          staff: staff,
          measure: grid.data.getValue(i, j),
          font: font,
        );

        row.add((children: children, barlineSettings: barlineSettings));

        lastNotationContext = NotationWidgetization.contextFromWidgets(
          children,
          lastNotationContext,
        );
      }
      var measures = <MeasureLayout>[];

      for (var data in row) {
        var measure = MeasureLayout(
          barlineSettings: data.barlineSettings,
          children: data.children,
        );
        measures.add(measure);
      }
      parts.add(measures);
    }

    return MusicSheet._(
      key: key,
      parts: parts,
      font: font,
      layoutProperties: layoutProperties,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotationProperties(
      font: font,
      layout: layoutProperties,
      child: Column(
          children: parts
              .map(
                (p) => AlignedRow(children: p),
              )
              .toList()),
    );
  }
}
