import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/notes/beaming.dart';

/// Custom painter for drawing musical beams with adjustable properties.
///
/// This painter supports angled beams, hooks, and multiple alignment modes.
/// It can also render debug lines for visualization of the alignment and
/// beam boundaries.
///
/// ## Properties:
/// - [data] - The list of beam note data defining positions and beam structures.
/// - [hookLength], [thickness], [spacing] - Visual attributes for the beams.
/// - [color] - Optional beam color. Defaults to black.
/// - [debug] -Enables debug visualization of beams and alignment lines.
class BeamPainter extends CustomPainter {
  final BeamGroupPattern pattern;
  final Color? color;

  final double hookLength;
  final double thickness;
  final double spacing;

  final bool flip;

  final bool debug;

  BeamPainter({
    required this.pattern,
    this.color,
    required this.hookLength,
    required this.thickness,
    this.flip = false,
    this.debug = false,
    required this.spacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var e in pattern.map.entries) {
      var level = e.key;
      var beams = e.value;

      // Calculate start and end based on the beam direction
      Offset start = pattern.start;
      Offset end = pattern.end;

      // Calculate beam angle
      double angle = atan2(end.dy - start.dy, end.dx - start.dx);

      for (var beam in beams) {
        double yOffset = (spacing + thickness) * (level - 1);
        if (flip) {
          yOffset += thickness;
          yOffset = yOffset * (-1);
        }

        double endpointsHorizontalSpan = end.dx - start.dx;
        switch (beam.type) {
          case BeamType.full:
            drawAngledBeam(
              canvas: canvas,
              angle: angle,
              start: start.translate(0, yOffset),
              length: endpointsHorizontalSpan,
              alignmentLineLength: 0,
              alignmentLineOffset: 0,
              alignment: Alignment.start,
              alignmentLineByHorizontalSpan: true,
              beamByHorizontalSpan: true,
              beamThickness: thickness,
              color: color ?? const Color.fromRGBO(0, 0, 0, 1),
              debug: debug,
            );
            break;

          case BeamType.backwardHook:
            drawAngledBeam(
              canvas: canvas,
              angle: angle,
              start: start.translate(0, yOffset),
              length: hookLength,
              alignmentLineLength: endpointsHorizontalSpan,
              alignment: Alignment.end,
              alignmentLineByHorizontalSpan: true,
              beamByHorizontalSpan: false,
              beamThickness: thickness,
              color: color ?? const Color.fromRGBO(0, 0, 0, 1),
              debug: debug,
            );
          default:
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
  /// The [alignment] parameter determines the beam's position along the alignment line, allowing for
  /// alignment at the start, middle, or end. The [alignmentLineByHorizontalSpan] and [beamByHorizontalSpan]
  /// flags determine if the specified lengths should be adjusted by their horizontal spans.
  ///
  /// * [canvas] - The canvas to draw on.
  /// * [start] - The starting point of the beam.
  /// * [angle] - The angle (in radians) at which the beam extends from the start point.
  /// * [alignmentLineLength] - Length of the alignment line for the beam.
  /// * [length] - The actual length of the beam.
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
  ///   length: 80,
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
    required double length,
    required Alignment alignment,
    required double beamThickness,
    bool alignmentLineByHorizontalSpan = false,
    bool beamByHorizontalSpan = false,
    double alignmentLineOffset = 0,
    Color color = const Color.fromRGBO(0, 0, 0, 1),
    bool debug = false,
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
        beamByHorizontalSpan ? length / cos(angle) : length;

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
      originalStart.dx + length,
      originalStart.dy,
    );

    // Define the alignment line, borders for top and bottom lines
    List<_DebugLine> lines = [
      _DebugLine(
        start: adjustedAlignmentLineStart,
        end: Offset(
          adjustedAlignmentLineStart.dx +
              cos(angle) * adjustedAlignmentLineLength,
          adjustedAlignmentLineStart.dy +
              sin(angle) * adjustedAlignmentLineLength,
        ),
        color: Color.fromRGBO(255, 10, 100, 0.35),
        thickness: 2.0,
      ),
      _DebugLine(
        start: originalStart,
        end: horizontalEnd,
        color: Color.fromRGBO(255, 0, 0, 0.5),
        thickness: 2.0,
      ),
      _DebugLine(
        start: Offset(originalStart.dx, originalStart.dy + beamThickness),
        end: Offset(horizontalEnd.dx, horizontalEnd.dy + beamThickness),
        color: Color.fromRGBO(200, 0, 0, 0.5),
        thickness: 2.0,
      ),
      _DebugLine(
        start: adjustedStart,
        end: angledEnd,
        color: Color.fromRGBO(0, 0, 255, 0.5),
        thickness: 2.0,
      ),
      _DebugLine(
        start: Offset(adjustedStart.dx, adjustedStart.dy + beamThickness),
        end: Offset(angledEnd.dx, angledEnd.dy + beamThickness),
        color: Color.fromRGBO(0, 0, 200, 0.5),
        thickness: 2.0,
      ),
    ];

    // Draw debug lines (alignment line and beam borders)
    if (debug) _drawDebugLines(canvas, lines);

    // Create the main beam path for the angled beam
    final Path beamPath = Path();
    beamPath.moveTo(adjustedStart.dx, adjustedStart.dy);
    beamPath.lineTo(adjustedStart.dx, adjustedStart.dy + beamThickness);
    beamPath.lineTo(angledEnd.dx, angledEnd.dy + beamThickness);
    beamPath.lineTo(angledEnd.dx, angledEnd.dy);
    beamPath.close();

    // Paint the main beam
    final Paint beamPaint = Paint()
      ..color = debug ? color.withOpacity(0.25) : color
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
  void _drawDebugLines(Canvas canvas, List<_DebugLine> lines) {
    for (var line in lines) {
      final paint = Paint()
        ..color = line.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = line.thickness;

      if (line.start == line.end) {
        canvas.drawCircle(line.start, line.thickness * 2, paint);
      } else {
        canvas.drawLine(line.start, line.end, paint);
      }
    }
  }

  @override
  bool shouldRepaint(BeamPainter oldDelegate) {
    return pattern != oldDelegate.pattern ||
        color != oldDelegate.color ||
        hookLength != oldDelegate.hookLength ||
        thickness != oldDelegate.thickness ||
        spacing != oldDelegate.spacing ||
        debug != oldDelegate.debug;
  }

  @override
  bool shouldRebuildSemantics(BeamPainter oldDelegate) => false;
}

class _DebugLine {
  final Offset start;
  final Offset end;
  final Color color;
  final double thickness;

  _DebugLine({
    required this.start,
    required this.end,
    required this.color,
    required this.thickness,
  });
}

enum Alignment {
  start,
  middle,
  end,
}
