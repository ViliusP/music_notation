import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_notation/src/notation_painter/layout/measure_stack.dart';

import 'package:music_notation/src/notation_painter/measure/measure_grid.dart';
import 'package:music_notation/src/notation_painter/measure/staff_lines.dart';
import 'package:music_notation/src/notation_painter/layout/positioning.dart';
import 'package:music_notation/src/notation_painter/models/range.dart';
import 'package:music_notation/src/notation_painter/notes/beaming.dart';

import 'package:music_notation/src/notation_painter/debug/debug_settings.dart';
import 'package:music_notation/src/notation_painter/measure/measure_barlines.dart';
import 'package:music_notation/src/notation_painter/layout/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/notes/chord_element.dart';
import 'package:music_notation/src/notation_painter/notes/note_element.dart';
import 'package:music_notation/src/notation_painter/notes/rest_element.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';

import 'package:music_notation/src/notation_painter/properties/notation_properties.dart';
import 'package:music_notation/src/notation_painter/utilities/number_extensions.dart';
import 'package:music_notation/src/notation_painter/utilities/type_extensions.dart';

/// A widget that lays out musical measures with notes, chords, beams, and  staff lines.
class MeasureContainer extends StatelessWidget {
  final MeasureGrid measure;

  final MeasureBarlines barlineSettings;

  final List<double> horizontalOffsets;

  const MeasureContainer({
    super.key,
    this.barlineSettings = const MeasureBarlines(),
    required this.measure,
    required this.horizontalOffsets,
  });

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    DebugSettings? dSettings = DebugSettings.of(context);

    double heightPerPosition = NotationLayoutProperties.baseSpacePerPosition;
    ElementPosition bottomRef = measure.floor - 1;
    ElementPosition topRef = measure.ceil;

    // Stave bottom values
    ElementPosition staveBottomRef = measure.staveBottom;
    ElementPosition staveTopRef = measure.staveTop;
    double staveBottom = staveBottomRef.distance(bottomRef) * heightPerPosition;
    staveBottom = staveBottom.scaledByContext(context);

    double measureWidth = horizontalOffsets.last;
    double measureHeight =
        (topRef.numeric - bottomRef.numeric) * heightPerPosition;

    var positionedElements = <Widget>[];

    for (var (index, entry) in measure.columns.entries.indexed) {
      for (var cellEntry in entry.value.cells.entries) {
        var cell = cellEntry.value;

        double? bottomOffset;
        Alignment alignment = cell.alignment;

        bottomOffset = cell.distanceToPosition(
          bottomRef,
          BoxSide.bottom,
          heightPerPosition,
        );

        double halfWidth = cell.size.width;
        double alignmentLeft = halfWidth + halfWidth * alignment.x;
        double left = horizontalOffsets[index] + alignmentLeft;

        var maybeRest = cell.child.tryAs<RestElement>();
        if (maybeRest is RestElement && maybeRest.isMeasure) {
          // Positions the rest element at the left side of the last measure attribute.
          left = horizontalOffsets[index];

          // Applies standard padding to shift the rest further left after the attributes.
          left -= NotationLayoutProperties.baseMeasurePadding;

          // Adjusts position to the right by half the distance between the last attribute and the measure's end.
          left += (measureWidth - left) / 2;

          // Centers the rest element by accounting for half its width.
          left -= cell.size.width / 2;
        }

        left = left.scaledByContext(context);
        bottomOffset = bottomOffset.scaledByContext(context);

        Widget elementToAdd = cell;

        switch (cell.child) {
          case NoteElement note:
            if (note.beams?.isNotEmpty == true && note.stem != null) {
              elementToAdd = BeamElement(
                beams: note.beams!,
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
            bottom: bottomOffset,
            child: elementToAdd,
          ),
        );

        if (dSettings != null) {
          if (dSettings.paintBBoxBelowStaff) {
            Size boxBelow = Size(
              cell.size.width.scaledByContext(context),
              cell
                  .heightBelowReference(staveBottomRef)
                  .scaledByContext(context),
            );
            positionedElements.add(
              Positioned(
                left: left,
                bottom: staveBottom - boxBelow.height,
                child: Container(
                  width: boxBelow.width,
                  height: boxBelow.height,
                  color: Color.fromRGBO(255, 10, 100, 0.2),
                ),
              ),
            );
          }

          if (dSettings.paintBBoxAboveStaff) {
            Size boxAbove = Size(
              cell.size.width.scaledByContext(context),
              cell.heightAboveReference(staveTopRef).scaledByContext(context),
            );
            positionedElements.add(
              Positioned(
                left: left,
                bottom: staveBottom + layoutProperties.staveHeight,
                child: Container(
                  width: boxAbove.width,
                  height: boxAbove.height,
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
            StaffLinesStack(bottom: staveBottom),
            if (barlineSettings.start != null)
              BarlineStack(
                type: barlineSettings.start!,
                location: BarlineLocation.start,
                baseline: staveBottom,
                baseHeight: layoutProperties.staveHeight,
              ),
            if (barlineSettings.end != null)
              BarlineStack(
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

class MeasureContainerV2 extends StatelessWidget {
  final MeasureGrid measure;

  final MeasureBarlines barlineSettings;

  final List<double> horizontalOffsets;

  const MeasureContainerV2({
    super.key,
    this.barlineSettings = const MeasureBarlines(),
    required this.measure,
    required this.horizontalOffsets,
  });

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    double measureWidth = horizontalOffsets.last;

    var positionedElements = <Widget>[];

    for (var (index, entry) in measure.columns.entries.indexed) {
      for (var cellEntry in entry.value.cells.entries) {
        var cell = cellEntry.value;

        Alignment alignment = cell.alignment;

        double halfWidth = cell.size.width;
        double alignmentLeft = halfWidth + halfWidth * alignment.x;
        double left = horizontalOffsets[index] + alignmentLeft;

        var maybeRest = cell.child.tryAs<RestElement>();
        if (maybeRest is RestElement && maybeRest.isMeasure) {
          // Positions the rest element at the left side of the last measure attribute.
          left = horizontalOffsets[index];

          // Applies standard padding to shift the rest further left after the attributes.
          left -= NotationLayoutProperties.baseMeasurePadding;

          // Adjusts position to the right by half the distance between the last attribute and the measure's end.
          left += (measureWidth - left) / 2;

          // Centers the rest element by accounting for half its width.
          left -= cell.size.width / 2;
        }

        left = left.scaledByContext(context);

        Widget elementToAdd = cell;

        switch (cell.child) {
          case NoteElement note:
            if (note.beams?.isNotEmpty == true && note.stem != null) {
              elementToAdd = BeamElement(
                beams: note.beams!,
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
          MusicElement(
            position: cell.position,
            alignment: cell.alignment,
            child: Padding(
              padding: EdgeInsets.only(left: left),
              child: elementToAdd,
            ),
          ),
        );

        // if (dSettings != null) {
        //   if (dSettings.paintBBoxBelowStaff) {
        //     Size boxBelow = Size(
        //       cell.size.width.scaledByContext(context),
        //       cell
        //           .heightBelowReference(staveBottomRef)
        //           .scaledByContext(context),
        //     );
        //     positionedElements.add(
        //       Positioned(
        //         left: left,
        //         child: Container(
        //           width: boxBelow.width,
        //           height: boxBelow.height,
        //           color: Color.fromRGBO(255, 10, 100, 0.2),
        //         ),
        //       ),
        //     );
        //   }

        //   if (dSettings.paintBBoxAboveStaff) {
        //     Size boxAbove = Size(
        //       cell.size.width.scaledByContext(context),
        //       cell.heightAboveReference(staveTopRef).scaledByContext(context),
        //     );
        //     positionedElements.add(
        //       Positioned(
        //         left: left,
        //         bottom: staveBottom + layoutProperties.staveHeight,
        //         child: Container(
        //           width: boxAbove.width,
        //           height: boxAbove.height,
        //           color: Color.fromRGBO(3, 154, 255, 0.2),
        //         ),
        //       ),
        //     );
        //   }
        // }
      }
    }

    return BeamCanvas(
      child: MeasureStack(
        range: PositionalRange(measure.ceil, measure.floor),
        debug: true,
        debugName: "In measure container",
        children: [
          MusicElement(
            position: ElementPosition.staffTop,
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: measureWidth * layoutProperties.staveSpace,
              child: StaffLines(),
            ),
          ),
          ...positionedElements,
          if (barlineSettings.start != null)
            PositionedBarlineElement.extended(
              position: ElementPosition.staffTop,
              height: layoutProperties.staveHeight,
              type: barlineSettings.start!,
            )

          // if (barlineSettings.end != null)
          //   Barline(
          //     type: barlineSettings.end!,
          //     location: BarlineLocation.end,
          //     baseline: staveBottom,
          //     baseHeight: layoutProperties.staveHeight,
          //   ),
        ],
      ),
    );
  }
}
