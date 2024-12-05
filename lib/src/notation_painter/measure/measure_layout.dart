import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import 'package:music_notation/src/notation_painter/debug/beat_mark_painter.dart';
import 'package:music_notation/src/notation_painter/measure/measure_grid.dart';
import 'package:music_notation/src/notation_painter/measure/staff_lines.dart';
import 'package:music_notation/src/notation_painter/models/vertical_edge_insets.dart';
import 'package:music_notation/src/notation_painter/notes/beaming.dart';

import 'package:music_notation/src/notation_painter/debug/debug_settings.dart';
import 'package:music_notation/src/notation_painter/measure/measure_barlines.dart';
import 'package:music_notation/src/notation_painter/measure/inherited_padding.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/notes/rest_element.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';

import 'package:music_notation/src/notation_painter/notes/rhythmic_element.dart';
import 'package:music_notation/src/notation_painter/properties/notation_properties.dart';
import 'package:music_notation/src/notation_painter/spacing/timeline.dart';
import 'package:music_notation/src/notation_painter/utilities/number_extensions.dart';

/// A widget that lays out musical measures with notes, chords, beams, and staff lines.
class MeasureLayout extends StatelessWidget {
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

  final List<MeasureWidget> children;

  final BeatTimeline? beatTimeline;

  final MeasureBarlines barlineSettings;

  const MeasureLayout({
    super.key,
    this.useExplicitBeaming = false,
    this.barlineSettings = const MeasureBarlines(),
    this.beatTimeline,
    required this.children,
  });

  /// Calculates the vertical padding needed based on the largest bounding box
  /// extensions above and below the staff across all child elements.
  ///
  /// This method iterates through each child widget and finds the maximum height
  /// required for padding above and below the staff, ensuring adequate space for
  /// elements that extend beyond the staff lines.
  ///
  /// Parameters:
  /// - [children] - A list of [MeasureWidget] elements to evaluate.
  ///
  /// Returns:
  /// An [EdgeInsets] object with calculated top and bottom padding.
  static VerticalEdgeInsets calculateVerticalPadding(
    List<MeasureWidget> children,
    double scale,
  ) {
    double top = 0;
    double bottom = 0;

    for (var child in children) {
      top = max(top, child.boxAboveStaff(scale).height);
      bottom = max(bottom, child.boxBelowStaff(scale).height);
    }

    return VerticalEdgeInsets(
      bottom: bottom,
      top: top,
    );
  }

  @override
  Widget build(BuildContext context) {
    NotationLayoutProperties layoutProperties =
        NotationProperties.of(context)?.layout ??
            NotationLayoutProperties.standard();

    final BeatTimeline measureBeatline = beatTimeline ??
        BeatTimeline.fromTimeline(MeasureTimeline.fromMeasureElements(
          children,
        ));

    List<double> spacings = measureBeatline.toSpacings(children);

    List<double> scaledSpacings =
        spacings.map((s) => s * layoutProperties.staveSpace).toList();

    double width = scaledSpacings.last;

    double spacePerPosition = layoutProperties.spacePerPosition;

    var inheritedPadding = InheritedPadding.of(context)?.padding;
    var padding = inheritedPadding ??
        calculateVerticalPadding(children, layoutProperties.staveSpace);

    DebugSettings? dSettings = DebugSettings.of(context);

    return LayoutBuilder(builder: (context, constraints) {
      List<Widget> beamGroups = [];

      BeamGroupV2 beaming = BeamGroupV2();

      var positionedElements = <Widget>[];
      for (var (index, child) in children.indexed) {
        BeamingResult? beamingResult;

        double? topOffset;
        double? bottomOffset;

        AlignmentPosition alignmentPosition = child.alignmentPosition.scale(
          layoutProperties.staveSpace,
        );

        if (alignmentPosition.top != null) {
          topOffset = alignmentPosition.top!;

          // Calculate the interval from staff top to the child's position.
          int intervalFromTheF5 = ElementPosition.staffTop.numeric;
          intervalFromTheF5 -= child.position.numeric;
          topOffset += intervalFromTheF5 * spacePerPosition;

          topOffset += padding.top;
        }
        if (alignmentPosition.bottom != null) {
          bottomOffset = 0;
          bottomOffset = alignmentPosition.bottom ?? 0;

          // Calculate the interval from staff bottom to the child's position.
          int intervalFromTheE4 = ElementPosition.staffBottom.numeric;
          intervalFromTheE4 -= child.position.numeric;
          bottomOffset -= intervalFromTheE4 * spacePerPosition;

          bottomOffset += padding.bottom;
        }
        if (child is RhythmicElement) {
          beamingResult = beaming.add(
            child,
            AlignmentPosition(
              left: spacings[index],
              top: topOffset,
              bottom: bottomOffset,
            ),
          );
        }

        if (beaming.isFinalized) {
          beamGroups.add(
            Positioned.fill(child: BeamGroup.fromBeaming(beaming, padding)),
          );
          beaming = BeamGroupV2();
        }

        if (beamingResult == null || beamingResult == BeamingResult.skipped) {
          positionedElements.add(
            Positioned(
              left: scaledSpacings[index],
              top: topOffset,
              bottom: bottomOffset,
              child: child,
            ),
          );
        }

        if (dSettings != null) {
          Rect boxBelow = child.boxBelowStaff(layoutProperties.staveSpace);
          if (dSettings.paintBBoxBelowStaff && boxBelow.height > 0) {
            positionedElements.add(
              Positioned(
                left: scaledSpacings[index],
                top: padding.top + layoutProperties.staveHeight,
                child: Container(
                  width: boxBelow.width,
                  height: [boxBelow.height, 0].max.toDouble(),
                  color: Color.fromRGBO(255, 10, 100, 0.2),
                ),
              ),
            );
          }

          Rect boxAbove = child.boxAboveStaff(layoutProperties.staveSpace);
          if (dSettings.paintBBoxAboveStaff && boxAbove.height > 0) {
            positionedElements.add(
              Positioned(
                left: scaledSpacings[index],
                bottom: padding.bottom + layoutProperties.staveHeight,
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

      return Stack(
        fit: StackFit.loose,
        children: [
          Padding(
            padding: padding,
            child: SizedBox.fromSize(
              size: Size(width, layoutProperties.staveHeight),
            ),
          ),

          SizedBox(
            width: width,
            height: padding.vertical + layoutProperties.staveHeight,
            child: StaffLines(bottom: padding.bottom),
          ),
          // SizedBox(
          //   height: 0,
          //   width: width,
          //   child: Barlines(
          //     startExtension: barlineSettings.startExtension,
          //     endExtension: barlineSettings.endExtension,
          //     padding: padding,
          //   ),
          // ),
          if (dSettings?.beatMarker == true)
            Padding(
              padding: padding,
              child: CustomPaint(
                size: Size(
                  constraints.maxWidth.isFinite ? constraints.maxWidth : width,
                  layoutProperties.staveHeight,
                ),
                painter: BeatMarkPainter(
                  dSettings!.beatMarkerMultiplier,
                  measureBeatline,
                ),
              ),
            ),
          ...beamGroups,
          ...positionedElements,
        ],
      );
    });
  }
}

/// A widget that lays out musical measures with notes, chords, beams, and staff lines.
class MeasureLayoutV2 extends StatelessWidget {
  final MeasureGrid grid;

  final MeasureBarlines barlineSettings;

  final List<double> widths;

  const MeasureLayoutV2({
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

    double measureWidth = spacings.last;

    double spacePerPosition = NotationLayoutProperties.baseSpacePerPosition;
    ElementPosition bottomRef = grid.minPosition;
    ElementPosition topRef = grid.maxPosition;
    ElementPosition staveBottomRef = grid.staveBottom;

    double staveBottom =
        (staveBottomRef.distance(bottomRef)) * spacePerPosition;
    staveBottom = staveBottom.scaledByContext(context);

    List<BeamData> beams = [];

    var positionedElements = <Widget>[];

    BeamGroupV2 beaming = BeamGroupV2();

    for (var (index, entry) in grid.columns.entries.indexed) {
      for (var cellEntry in entry.value.cells.entries) {
        var position = cellEntry.key;
        var cell = cellEntry.value;
        if (cell == null) continue;

        double? topOffset;
        double? bottomOffset;
        AlignmentPosition alignmentPosition = cell.alignmentPosition;

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

        if (cell is RhythmicElement) {
          beaming.add(
            cell,
            AlignmentPosition(
              left: spacings[index],
              top: topOffset,
              bottom: bottomOffset,
            ),
          );
        }

        if (beaming.isFinalized) {
          beams.add(BeamData.fromBeamGroup(group: beaming));
          beaming = BeamGroupV2();
        }

        double left = spacings[index];

        if (cell is RestElement && cell.isMeasure) {
          // Positions the rest element at the left side of the last measure attribute.
          left = spacings[index];

          // Applies standard padding to shift the rest further left after the attributes.
          left -= NotationLayoutProperties.baseMeasurePadding;

          // Adjusts position to the right by half the distance between the last attribute and the measure's end.
          left += (measureWidth - left) / 2;

          // Centers the rest element by accounting for half its width.
          left -= cell.baseSize.width / 2;
        }

        left = left.scaledByContext(context);
        topOffset = topOffset?.scaledByContext(context);
        bottomOffset = bottomOffset?.scaledByContext(context);

        positionedElements.add(
          Positioned(
            left: left,
            top: topOffset,
            bottom: bottomOffset,
            child: cell,
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

    double measureHeight =
        (topRef.numeric - bottomRef.numeric) * spacePerPosition;

    return SizedBox(
      height: measureHeight.scaledByContext(context),
      width: measureWidth.scaledByContext(context),
      child: Stack(
        fit: StackFit.loose,
        children: [
          if (beams.isNotEmpty) BeamCanvas(beams: beams),
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
    );
  }
}
