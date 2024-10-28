import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:music_notation/src/models/elements/music_data/note/beam.dart';
import 'package:music_notation/src/models/elements/music_data/note/notations/notation.dart';
import 'package:music_notation/src/models/elements/music_data/note/stem.dart';
import 'package:music_notation/src/notation_painter/beaming.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';

class BeamPainter extends CustomPainter {
  final List<NoteBeams> beamsPattern;

  final bool downward;
  final Color? color;

  BeamPainter({
    required this.beamsPattern,
    required this.downward,
    this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double beamThickness = NotationLayoutProperties.beamThickness;

    // Calculate start and end based on the beam direction
    Offset start;
    Offset end;
    if (!downward) {
      start = Offset(0, size.height - beamThickness);
      end = Offset(size.width, 0);
    } else {
      start = Offset(0, 0);
      end = Offset(size.width, size.height - beamThickness);
    }
    // Calculate beam angle
    double angle = atan2(end.dy - start.dy, end.dx - start.dx);

    for (var (index, noteBeams) in beamsPattern.indexed) {
      double offsetX = noteBeams.leftOffset;

      for (var beams in noteBeams.values) {
        double yOffset =
            NotationLayoutProperties.beamSpacing * 1.5 * (beams.number - 1);

        if (noteBeams.stem == StemValue.down) {
          yOffset = yOffset * (-1);
        }

        if (beams.value == BeamValue.begin ||
            beams.value == BeamValue.bContinue) {
          double beamLength = beamsPattern[index + 1].leftOffset;
          beamLength -= noteBeams.leftOffset;

          drawAngledBeam(
            angle: angle,
            canvas: canvas,
            start: Offset(start.dx, start.dy + yOffset),
            beamLength: beamLength,
            alignmentLineLength: 0,
            alignmentLineOffset: offsetX,
            alignment: Alignment.start,
            alignmentLineByHorizontalSpan: true,
            beamByHorizontalSpan: true,
            beamThickness: NotationLayoutProperties.beamThickness,
            color: color ?? const Color.fromRGBO(0, 0, 0, .25),
          );
        }

        if (beams.value == BeamValue.backwardHook) {
          drawAngledBeam(
            angle: angle,
            canvas: canvas,
            start: Offset(start.dx, start.dy + yOffset),
            beamLength: NotationLayoutProperties.defaultNoteheadHeight,
            // lineOffset: startingX,
            alignmentLineLength: offsetX - beamsPattern[index - 1].leftOffset,
            alignment: Alignment.end,
            alignmentLineByHorizontalSpan: true,
            beamByHorizontalSpan: false,
            beamThickness: NotationLayoutProperties.beamThickness,
            color: color ?? const Color.fromRGBO(0, 0, 0, 1),
          );
        }
      }
    }
  }

  /// Draws an angled beam on the canvas with adjustable alignment and length options.
  ///
  /// This function renders an angled beam starting from a specified point and extending at a given angle.
  /// The beam can be aligned and adjusted in length along an alignment line, making it flexible for various
  /// musical notation or custom visualizations. The function also provides options to draw a visual
  /// alignment line and border lines for the beam.
  ///
  /// The `alignment` parameter determines the beam's position along the alignment line, allowing for
  /// alignment at the start, middle, or end. The `alignmentLineByHorizontalSpan` and `beamByHorizontalSpan`
  /// flags determine if the specified lengths should be adjusted by their horizontal spans.
  ///
  /// * [canvas] - The canvas to draw on.
  /// * [start] - The starting point of the beam.
  /// * [angle] - The angle (in radians) at which the beam extends from the start point.
  /// * [alignmentLineLength] - Length of the alignment line for the beam.
  /// * [beamLength] - The actual length of the beam.
  /// * [alignment] - The alignment of the beam along the alignment line (start, middle, end).
  /// * [beamThickness] - Thickness of the beam.
  /// * [alignmentLineByHorizontalSpan] - When true, calculates the alignment line's length by its horizontal span.
  /// * [beamByHorizontalSpan] - When true, calculates the beam's length by its horizontal span.
  /// * [alignmentLineOffset] - Offset distance for the alignment line along the angle direction.
  /// * [color] - Color of the main beam.
  ///
  /// ## Example:
  ///
  /// ```dart
  /// drawAngledBeam(
  ///   canvas: canvas,
  ///   start: Offset(0, 0),
  ///   angle: pi / 4,
  ///   alignmentLineLength: 100,
  ///   beamLength: 80,
  ///   alignment: Alignment.middle,
  ///   beamThickness: 4.0,
  ///   alignmentLineByHorizontalSpan: true,
  ///   beamByHorizontalSpan: false,
  ///   alignmentLineOffset: 10,
  ///   color: Color.fromRGBO(0, 0, 0, 1),
  /// );
  /// ```
  void drawAngledBeam({
    required Canvas canvas,
    required Offset start,
    required double angle,
    required double alignmentLineLength,
    required double beamLength,
    required Alignment alignment,
    required double beamThickness,
    bool alignmentLineByHorizontalSpan = false,
    bool beamByHorizontalSpan = false,
    double alignmentLineOffset = 0,
    Color color = const Color.fromRGBO(0, 0, 0, 1),
  }) {
    // Adjust alignment line length to ensure it spans the correct horizontal distance
    double adjustedAlignmentLineLength = alignmentLineByHorizontalSpan
        ? alignmentLineLength / cos(angle)
        : alignmentLineLength;

    // Apply the offset along the angle direction to the alignment line's start point
    Offset adjustedAlignmentLineStart = Offset(
      start.dx + alignmentLineOffset,
      start.dy + sin(angle) * alignmentLineOffset,
    );

    // Calculate actual beam length based on the `beamByHorizontalSpan` flag
    double adjustedBeamLength =
        beamByHorizontalSpan ? beamLength / cos(angle) : beamLength;

    // Alignment adjustment for both the horizontal and angled beams
    Offset adjustedStart;
    double alignmentOffset;

    switch (alignment) {
      case Alignment.start:
        adjustedStart = adjustedAlignmentLineStart;
        alignmentOffset = 0;
        break;
      case Alignment.middle:
        alignmentOffset =
            (adjustedAlignmentLineLength - adjustedBeamLength) / 2;
        adjustedStart = Offset(
          adjustedAlignmentLineStart.dx + cos(angle) * alignmentOffset,
          adjustedAlignmentLineStart.dy + sin(angle) * alignmentOffset,
        );
        break;
      case Alignment.end:
        alignmentOffset = adjustedAlignmentLineLength - adjustedBeamLength;
        adjustedStart = Offset(
          adjustedAlignmentLineStart.dx + cos(angle) * alignmentOffset,
          adjustedAlignmentLineStart.dy + sin(angle) * alignmentOffset,
        );
        break;
    }

    // Calculate the end points for both the angled and horizontal beams
    Offset angledEnd = Offset(
      adjustedStart.dx + cos(angle) * adjustedBeamLength,
      adjustedStart.dy + sin(angle) * adjustedBeamLength,
    );

    Offset originalStart = Offset(
      start.dx + alignmentLineOffset + alignmentOffset,
      start.dy,
    );
    Offset horizontalEnd = Offset(
      originalStart.dx + beamLength,
      originalStart.dy,
    );

    // Define the alignment line, borders for top and bottom lines
    List<Map<String, dynamic>> lines = [
      {
        'start': adjustedAlignmentLineStart,
        'end': Offset(
          adjustedAlignmentLineStart.dx +
              cos(angle) * adjustedAlignmentLineLength,
          adjustedAlignmentLineStart.dy +
              sin(angle) * adjustedAlignmentLineLength,
        ),
        'color': Color.fromRGBO(255, 10, 100, 0.35),
        'thickness': 2.0,
      },
      {
        'start': originalStart,
        'end': horizontalEnd,
        'color': Color.fromRGBO(255, 0, 0, 0.5),
        'thickness': 2.0,
      },
      {
        'start': Offset(originalStart.dx, originalStart.dy + beamThickness),
        'end': Offset(horizontalEnd.dx, horizontalEnd.dy + beamThickness),
        'color': Color.fromRGBO(200, 0, 0, 0.5),
        'thickness': 2.0,
      },
      {
        'start': adjustedStart,
        'end': angledEnd,
        'color': Color.fromRGBO(0, 0, 255, 0.5),
        'thickness': 2.0,
      },
      {
        'start': Offset(adjustedStart.dx, adjustedStart.dy + beamThickness),
        'end': Offset(angledEnd.dx, angledEnd.dy + beamThickness),
        'color': Color.fromRGBO(0, 0, 200, 0.5),
        'thickness': 2.0,
      },
    ];

    // Draw debug lines (alignment line and beam borders)
    _drawDebugLines(canvas, lines);

    // Create the main beam path for the angled beam
    final Path beamPath = Path();
    beamPath.moveTo(adjustedStart.dx, adjustedStart.dy);
    beamPath.lineTo(adjustedStart.dx, adjustedStart.dy + beamThickness);
    beamPath.lineTo(angledEnd.dx, angledEnd.dy + beamThickness);
    beamPath.lineTo(angledEnd.dx, angledEnd.dy);
    beamPath.close();

    // Paint the main beam
    final Paint beamPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(beamPath, beamPaint);
  }

  /// Draws debug lines on the canvas based on provided start and end points, colors, and thicknesses.
  ///
  /// This function paints multiple lines on the canvas based on a list of debug line data,
  /// including the alignment line and the beam borders. Each debug line is drawn with a specified
  /// start and end offset, color, and line thickness. If the start and end points are the same,
  /// a dot is drawn instead of a line.
  ///
  /// Parameters:
  /// - `canvas`: The canvas to draw on.
  /// - `lines`: A list of maps, where each map specifies:
  ///     - `start`: Offset - Starting point of the line.
  ///     - `end`: Offset - Ending point of the line.
  ///     - `color`: Color - Color of the line.
  ///     - `thickness`: double - Line thickness.
  ///
  /// Example usage:
  /// ```dart
  /// _drawDebugLines(
  ///   canvas,
  ///   [
  ///     {
  ///       'start': Offset(0, 0),
  ///       'end': Offset(100, 0),
  ///       'color': Color.fromRGBO(255, 0, 0, 0.5),
  ///       'thickness': 2.0,
  ///     },
  ///     {
  ///       'start': Offset(0, 10),
  ///       'end': Offset(0, 10), // Dot instead of a line
  ///       'color': Color.fromRGBO(0, 255, 0, 0.5),
  ///       'thickness': 4.0,
  ///     },
  ///   ],
  /// );
  /// ```
  void _drawDebugLines(Canvas canvas, List<Map<String, dynamic>> lines) {
    for (var line in lines) {
      final Paint paint = Paint()
        ..color = line['color'] as Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = line['thickness'] as double;

      // Check if start and end points are the same to draw a dot instead of a line
      if (line['start'] == line['end']) {
        canvas.drawCircle(
          line['start'] as Offset,
          (line['thickness'] as double) * 2,
          paint,
        );
      } else {
        canvas.drawLine(line['start'] as Offset, line['end'] as Offset, paint);
      }
    }
  }

  @override
  bool shouldRepaint(BeamPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BeamPainter oldDelegate) => false;
}

enum Alignment {
  start,
  middle,
  end,
}
