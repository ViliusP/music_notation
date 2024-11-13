import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:collection/collection.dart';
import 'package:music_notation/src/models/elements/score/score.dart';
import 'package:music_notation/src/notation_painter/debug/debug_settings.dart';
import 'package:music_notation/src/notation_painter/measure/barline_painting.dart';
import 'package:music_notation/src/notation_painter/measure/inherited_padding.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/measure/measure_layout.dart';
import 'package:music_notation/src/notation_painter/measure/notation_widgetization.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/music_grid.dart';
import 'package:music_notation/src/notation_painter/notation_font.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';

import 'package:music_notation/src/notation_painter/sync_width_column.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

typedef _MeasureData = ({
  List<MeasureWidget> children,
  BarlineSettings barlineSettings
});

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
  ///
  /// Currently ignored!
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
      NotationContext lastNotationContext = NotationContext.empty();
      double maxTopPadding = 0;
      double maxBottomPadding = 0;
      int? staff = grid.staffForRow(i);
      List<_MeasureData> column = [];

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

        column.add((children: children, barlineSettings: barlineSettings));

        lastNotationContext = NotationWidgetization.contextFromWidgets(
          children,
          lastNotationContext,
        );

        var padding = MeasureLayout.calculateVerticalPadding(children);

        maxTopPadding = [
          maxTopPadding,
          padding.top,
        ].max;
        maxBottomPadding = [
          maxBottomPadding,
          padding.bottom,
        ].max;
      }
      var measures = <MeasureLayout>[];

      for (var data in column) {
        var measure = MeasureLayout(
          barlineSettings: data.barlineSettings,
          children: data.children,
        );
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
    return DebugSettings(
      paintBBoxAboveStaff: false,
      paintBBoxBelowStaff: false,
      extraStaveLineCount: 0,
      verticalStaveLineSpacingMultiplier: 0,
      extraStaveLines: ExtraStaveLines.none,
      beatMarkerMultiplier: 1,
      beatMarker: true,
      child: NotationFont(
        value: font,
        child: SyncWidthColumn(
          builders: parts,
        ),
      ),
    );
  }
}
