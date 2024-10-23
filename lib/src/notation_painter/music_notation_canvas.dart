import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:collection/collection.dart';
import 'package:music_notation/src/models/elements/score/score.dart';
import 'package:music_notation/src/notation_painter/measure/barline_painting.dart';
import 'package:music_notation/src/notation_painter/measure/inherited_padding.dart';
import 'package:music_notation/src/notation_painter/measure/measure_layout.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/music_grid.dart';
import 'package:music_notation/src/notation_painter/notation_font.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';

import 'package:music_notation/src/notation_painter/sync_width_column.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

class MusicNotationCanvas extends StatelessWidget {
  final ScorePartwise scorePartwise;

  /// Determines if the music notation renderer should use specified beaming
  /// directly from the musicXML file.
  ///
  /// By default, the renderer will rely on the beaming data as it is
  /// directly provided in the musicXML file, without making any changes or
  /// assumptions.
  ///
  /// Set this property to `false` if the score contains raw or incomplete
  /// musicXML data, allowing the renderer to determine beaming based on its
  /// internal logic or algorithms.
  final bool useExplicitBeaming;

  final FontMetadata font;

  NotationGrid get grid => NotationGrid.fromScoreParts(
        scorePartwise.parts,
      );

  const MusicNotationCanvas({
    super.key,
    required this.scorePartwise,
    this.useExplicitBeaming = true,
    required this.font,
  });

  @override
  Widget build(BuildContext context) {
    var parts = <SyncWidthRowBuilder>[];
    for (int i = 0; i < grid.data.rowCount; i++) {
      var measures = <MeasureLayout>[];
      double maxTopPadding = 0;
      double maxBottomPadding = 0;
      for (var j = 0; j < grid.data.columnCount; j++) {
        var barlineSettings = BarlineSettings.fromGridData(
          gridX: j,
          gridY: i,
          maxX: grid.data.columnCount,
          maxY: grid.data.rowCount,
          staff: grid.staffForRow(i) ?? 1,
          staffCount: grid.staffCount(i) ?? 1,
        );

        var measure = MeasureLayout.fromMeasureData(
          font: font,
          measure: grid.data.getValue(i, j),
          staff: grid.staffForRow(i),
          barlineSettings: barlineSettings,
          notationContext: j != 0
              ? measures.last.contextAfter
              : const NotationContext(
                  divisions: null,
                  clef: null,
                  time: null,
                ),
        );
        maxTopPadding = [
          maxTopPadding,
          measure.verticalPadding.top,
        ].max;
        maxBottomPadding = [
          maxBottomPadding,
          measure.verticalPadding.bottom,
        ].max;

        measures.add(measure);
      }
      parts.add(SyncWidthRowBuilder(
        builder: (context, children) {
          return InheritedPadding(
            top: maxTopPadding,
            bottom: maxBottomPadding,
            child: SizedBox(
              height: [
                maxTopPadding,
                maxBottomPadding,
                NotationLayoutProperties.staveHeight,
              ].sum,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            ),
          );
        },
        children: measures,
      ));
    }
    return NotationFont(
      value: font,
      child: SyncWidthColumn(
        builders: parts,
      ),
    );
  }
}
