import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import 'package:music_notation/src/notation_painter/debug/beat_mark_painter.dart';
import 'package:music_notation/src/notation_painter/measure/staff_lines.dart';
import 'package:music_notation/src/notation_painter/models/vertical_edge_insets.dart';
import 'package:music_notation/src/notation_painter/music_sheet/grid.dart';
import 'package:music_notation/src/notation_painter/notes/beaming.dart';

import 'package:music_notation/src/notation_painter/debug/debug_settings.dart';
import 'package:music_notation/src/notation_painter/measure/barline_painting.dart';
import 'package:music_notation/src/notation_painter/measure/inherited_padding.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';

import 'package:music_notation/src/notation_painter/notes/rhythmic_element.dart';
import 'package:music_notation/src/notation_painter/properties/notation_properties.dart';
import 'package:music_notation/src/notation_painter/spacing/timeline.dart';

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

  final BarlineSettings barlineSettings;

  const MeasureLayout({
    super.key,
    this.useExplicitBeaming = false,
    this.barlineSettings = const BarlineSettings(),
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

      BeamGrouping beaming = BeamGrouping();

      var positionedElements = <Widget>[];
      for (var (index, child) in children.indexed) {
        BeamingResult? beamingResult;
        if (child is RhythmicElement) {
          beamingResult = beaming.add(child, spacings[index]);
        }

        if (beaming.isFinalized) {
          beamGroups.add(
            Positioned.fill(child: BeamGroup.fromBeaming(beaming, padding)),
          );
          beaming = BeamGrouping();
        }

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
            child: AlignTarget(
              child: SizedBox.fromSize(
                size: Size(width, layoutProperties.staveHeight),
                child: StaffLines(),
              ),
            ),
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
