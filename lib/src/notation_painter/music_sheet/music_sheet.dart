import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/models/elements/score/score.dart';
import 'package:music_notation/src/notation_painter/debug/debug_settings.dart';
import 'package:music_notation/src/notation_painter/measure/measure_barlines.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/measure/measure_grid.dart';
import 'package:music_notation/src/notation_painter/measure/measure_layout.dart';
import 'package:music_notation/src/notation_painter/measure/notation_widgetization.dart';
import 'package:music_notation/src/notation_painter/measure/staff_lines.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/music_grid.dart';
import 'package:music_notation/src/notation_painter/music_sheet/measure_stack.dart';
import 'package:music_notation/src/notation_painter/notes/note_parts.dart';
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
        var measure = MeasureGrid.fromMeasureElements(
          barlines: data.barlineSettings,
          children: data.children,
          divisions: data.divisions,
        );
        colMeasures.add(measure);
      }
      musicSheetGrid.add(MeasuresColumn.empty()..addAll(colMeasures));
    }

    return MusicSheet._(
      key: key,
      grid: musicSheetGrid,
      font: font,
    );
  }

  @override
  Widget build(BuildContext context) {
    var head1 = NoteheadElement(type: NoteTypeValue.eighth, font: font);
    var head2 = NoteheadElement(type: NoteTypeValue.half, font: font);
    var head3 = NoteheadElement(type: NoteTypeValue.whole, font: font);
    // Stack()
    var abc = MeasureColumn(
      debug: true,
      strictBounds: false,
      debugName: "Outer",
      children: [
        MeasureColumn(
          debug: true,
          strictBounds: false,
          debugName: "Inner",
          children: [
            MeasureElementV2(
              position: ElementPosition.staffMiddle - 2,
              size: head3.size,
              offset: head3.offset,
              duration: 0,
              child: head3,
            ),
          ],
        ),
        // MeasureElementV2(
        //   position: ElementPosition.staffTop,
        //   size: Size(0, 0),
        //   offset: AlignmentOffset.fromTop(left: 0, top: 0, height: 4),
        //   duration: 0,
        //   child: StaffLines(),
        // ),
        MeasureElementV2(
          position: ElementPosition.staffMiddle,
          size: head2.size,
          offset: head2.offset,
          duration: 0,
          child: head2,
        ),
        MeasureElementV2(
          position: ElementPosition.staffMiddle + 2,
          size: head1.size,
          offset: head1.offset,
          duration: 0,
          child: head1,
        ),
      ],
    );

    // var def = Stack(
    //   children: [
    //     Positioned(
    //       top: 10,
    //       left: 10,
    //       child: ColoredBox(
    //         color: Color.fromRGBO(13, 88, 3, 1),
    //         child: SizedBox(
    //           width: 40,
    //           height: 40,
    //         ),
    //       ),
    //     ),
    //     // ColoredBox(
    //     //   color: Color.fromRGBO(160, 6, 6, 1),
    //     //   child: SizedBox(
    //     //     width: 50,
    //     //     height: 30,
    //     //   ),
    //     // ),
    //     Positioned(
    //       bottom: 20,
    //       right: 100,
    //       child: ColoredBox(
    //         color: Color.fromRGBO(160, 6, 6, 1),
    //         child: SizedBox(
    //           width: 200,
    //           height: 20,
    //         ),
    //       ),
    //     ),
    //   ],
    // );

    return Column(
      children: [
        DebugSettings(
          paintBBoxAboveStaff: false,
          paintBBoxBelowStaff: false,
          extraStaveLineCount: 0,
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
            children: grid.columns
                .mapIndexed((i, col) => _SheetMeasuresColumn(
                      number: i,
                      column: col,
                    ))
                .toList(),
          ),
        ),
        ColoredBox(
          color: Color.fromRGBO(0, 0, 0, 1),
          child: SizedBox(
            width: 200,
            height: 1,
          ),
        ),
        // abc,
        ColoredBox(
          color: Color.fromRGBO(0, 0, 0, 1),
          child: SizedBox(
            width: 200,
            height: 1,
          ),
        ),
        abc
      ],
    );
  }
}

class _SheetMeasuresColumn extends StatelessWidget {
  final int number;
  final MeasuresColumn column;

  const _SheetMeasuresColumn({
    super.key,
    required this.column,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: column.measures
          .map((value) => MeasureLayout(
                measure: value,
                barlineSettings: MeasureBarlines(
                  start: number == 0 ? value.barlines.start : null,
                  end: value.barlines.end,
                ),
                horizontalOffsets: column.horizontalOffsets,
              ))
          .toList(),
    );
  }
}
