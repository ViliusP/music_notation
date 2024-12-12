import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import 'package:music_notation/src/notation_painter/measure/measure_grid.dart';
import 'package:music_notation/src/notation_painter/measure/staff_lines.dart';
import 'package:music_notation/src/notation_painter/notes/beaming.dart';

import 'package:music_notation/src/notation_painter/debug/debug_settings.dart';
import 'package:music_notation/src/notation_painter/measure/measure_barlines.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/notes/chord_element.dart';
import 'package:music_notation/src/notation_painter/notes/note_element.dart';
import 'package:music_notation/src/notation_painter/notes/rest_element.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';

import 'package:music_notation/src/notation_painter/properties/notation_properties.dart';
import 'package:music_notation/src/notation_painter/utilities/number_extensions.dart';
import 'package:music_notation/src/notation_painter/utilities/type_extensions.dart';

/// A widget that lays out musical measures with notes, chords, beams, and staff lines.
class MeasureLayout extends StatelessWidget {
  final MeasureGrid grid;

  final MeasureBarlines barlineSettings;

  final List<double> widths;

  const MeasureLayout({
    super.key,
    this.barlineSettings = const MeasureBarlines(),
    required this.grid,
    required this.widths,
  });

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    DebugSettings? dSettings = DebugSettings.of(context);

    // Spacing
    List<double> spacings = [];
    double spacing = 0;
    for (var (i, width) in widths.indexed) {
      if (i == 0) {
        spacing = NotationLayoutProperties.baseMeasurePadding;
      }
      spacings.add(spacing);
      spacing += width;
      if (!grid.columns.entries.elementAt(i).key.isRhytmic) {
        spacing += NotationLayoutProperties.baseMeasurePadding;
      }
    }
    spacings.add(spacing + 1);

    double spacePerPosition = NotationLayoutProperties.baseSpacePerPosition;
    ElementPosition bottomRef = grid.minPosition;
    ElementPosition topRef = grid.maxPosition;

    // Stave bottom values
    ElementPosition staveBottomRef = grid.staveBottom;
    double staveBottom =
        (staveBottomRef.distance(bottomRef)) * spacePerPosition;
    staveBottom = staveBottom.scaledByContext(context);

    double measureWidth = spacings.last;
    double measureHeight =
        (topRef.numeric - bottomRef.numeric) * spacePerPosition;

    var positionedElements = <Widget>[];

    for (var (index, entry) in grid.columns.entries.indexed) {
      for (var cellEntry in entry.value.cells.entries) {
        var position = cellEntry.key;
        var cell = cellEntry.value;
        if (cell == null) continue;

        double? topOffset;
        double? bottomOffset;
        AlignmentPosition alignmentPosition = cell.alignmentOffset;

        if (alignmentPosition.top != null) {
          topOffset = alignmentPosition.top!;

          // Calculate the interval from staff top to the child's position.
          int interval = topRef.numeric;
          interval -= position.numeric;
          topOffset += interval * spacePerPosition;
        }
        if (alignmentPosition.bottom != null) {
          bottomOffset = alignmentPosition.bottom ?? 0;

          // Calculate the interval from staff bottom to the child's position.
          int interval = bottomRef.numeric;
          interval -= position.numeric;
          bottomOffset -= interval * spacePerPosition;
        }

        double left = spacings[index] + alignmentPosition.left;

        var maybeRest = cell.child.tryAs<RestElement>();
        if (maybeRest is RestElement && maybeRest.isMeasure) {
          // Positions the rest element at the left side of the last measure attribute.
          left = spacings[index];

          // Applies standard padding to shift the rest further left after the attributes.
          left -= NotationLayoutProperties.baseMeasurePadding;

          // Adjusts position to the right by half the distance between the last attribute and the measure's end.
          left += (measureWidth - left) / 2;

          // Centers the rest element by accounting for half its width.
          left -= cell.size.width / 2;
        }

        left = left.scaledByContext(context);
        topOffset = topOffset?.scaledByContext(context);
        bottomOffset = bottomOffset?.scaledByContext(context);

        Widget elementToAdd = cell;

        switch (cell.child) {
          case NoteElement note:
            if (note.beams.isNotEmpty && note.stem != null) {
              elementToAdd = BeamElement(
                beams: note.beams,
                child: elementToAdd,
              );
            }
            break;
          case Chord chord:
            if (chord.beams.isNotEmpty && chord.stem != null) {
              elementToAdd = BeamElement(
                beams: chord.beams,
                child: elementToAdd,
              );
            }

            break;
        }

        positionedElements.add(
          Positioned(
            left: left,
            top: topOffset,
            bottom: bottomOffset,
            child: elementToAdd,
          ),
        );

        if (dSettings != null) {
          Rect boxBelow = cell.boxBelowStaff(layoutProperties.staveSpace);
          if (dSettings.paintBBoxBelowStaff && boxBelow.height > 0) {
            positionedElements.add(
              Positioned(
                left: left,
                bottom: staveBottom - boxBelow.height,
                child: Container(
                  width: boxBelow.width,
                  height: [boxBelow.height, 0].max.toDouble(),
                  color: Color.fromRGBO(255, 10, 100, 0.2),
                ),
              ),
            );
          }

          Rect boxAbove = cell.boxAboveStaff(layoutProperties.staveSpace);
          if (dSettings.paintBBoxAboveStaff && boxAbove.height > 0) {
            positionedElements.add(
              Positioned(
                left: left,
                bottom: staveBottom + layoutProperties.staveHeight,
                child: Container(
                  width: boxAbove.width,
                  height: [boxAbove.height, 0].max.toDouble(),
                  color: Color.fromRGBO(3, 154, 255, 0.2),
                ),
              ),
            );
          }
        }
      }
    }

    return SizedBox(
      height: measureHeight.scaledByContext(context),
      width: measureWidth.scaledByContext(context),
      child: BeamCanvas(
        child: Stack(
          fit: StackFit.loose,
          children: [
            StaffLines(
              bottom: staveBottom,
            ),
            if (barlineSettings.start != null)
              Barline(
                type: barlineSettings.start!,
                location: BarlineLocation.start,
                baseline: staveBottom,
                baseHeight: layoutProperties.staveHeight,
              ),
            if (barlineSettings.end != null)
              Barline(
                type: barlineSettings.end!,
                location: BarlineLocation.end,
                baseline: staveBottom,
                baseHeight: layoutProperties.staveHeight,
              ),
            ...positionedElements,
          ],
        ),
      ),
    );
  }
}
