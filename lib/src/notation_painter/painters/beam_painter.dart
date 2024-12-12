import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/notes/beaming.dart';

/// Custom painter for drawing musical beams with adjustable properties.
///
/// This painter supports the rendering of musical beams with the following features:
/// - Angled beams that follow the slope between start and end points.
/// - Support for hooks (forward and backward) to handle non-continuous beams.
/// - Configurable alignment modes (start, middle, end) for beam placement.
/// - Customizable visual properties such as beam thickness, spacing, color, and flipping for inverted beams.
///
/// ## Properties:
/// - [pattern] - Defines the positions and structures of the beams for each level.
/// - [hookLength] - The length of the hooks for forward/backward hook beams.
/// - [thickness] - The thickness of each beam.
/// - [spacing] - The vertical spacing between consecutive beam levels.
/// - [color] - The color of the beams. Defaults to black if not specified.
/// - [flip] - If true, flips the beam alignment vertically (used for downward stems).
class BeamPainter extends CustomPainter {
  /// The structure defining beam levels and their respective positions.
  final BeamGroupPattern pattern;

  /// The color of the beams. Defaults to black.
  final Color? color;

  /// The length of the hooks for forward and backward beam types.
  final double hookLength;

  /// The thickness of the beams.
  final double thickness;

  /// The vertical spacing between consecutive levels of beams.
  final double spacing;

  /// Whether to flip the beams vertically (e.g., for downward stems).
  final bool flip;

  BeamPainter({
    required this.pattern,
    this.color,
    required this.hookLength,
    required this.thickness,
    this.flip = false,
    required this.spacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _BeamGroupBase beamGroupBase = _BeamGroupBase(
      start: pattern.start,
      end: pattern.end,
    );

    for (var e in pattern.map.entries) {
      var level = e.key;
      var beams = e.value;

      for (var beam in beams) {
        // Calculate start and end based on the beam direction

        double yOffset = (spacing + thickness) * (level - 1);
        if (flip) {
          yOffset += thickness;
          yOffset = yOffset * (-1);
        }

        switch (beam.type) {
          case BeamType.full:
            var points = beamGroupBase
                .shiftVertically(yOffset)
                .beamPoints(from: beam.startX, to: beam.endX);
            _drawBeam(
              canvas: canvas,
              start: points.start,
              end: points.end,
              thickness: thickness,
              color: color ?? const Color.fromRGBO(0, 0, 0, 1),
            );

          case BeamType.backwardHook:
            var points = beamGroupBase.shiftVertically(yOffset).beamPoints(
                  from: beam.startX,
                  to: beam.endX,
                  length: hookLength,
                  alignment: _Alignment.end,
                );
            _drawBeam(
              canvas: canvas,
              start: points.start,
              end: points.end,
              thickness: thickness,
              color: color ?? const Color.fromRGBO(0, 0, 0, 1),
            );
            break;

          case BeamType.forwardHook:
            var points = beamGroupBase.shiftVertically(yOffset).beamPoints(
                  from: beam.startX,
                  to: beam.endX,
                  length: hookLength,
                  alignment: _Alignment.start,
                );
            _drawBeam(
              canvas: canvas,
              start: points.start,
              end: points.end,
              thickness: thickness,
              color: color ?? const Color.fromRGBO(0, 0, 0, 1),
            );
            break;
        }
      }
    }
  }

  /// Helper method to draw a single beam segment on the canvas.
  ///
  /// Parameters:
  /// - [canvas] - The canvas on which to draw the beam.
  /// - [start] - The starting point of the beam.
  /// - [end] - The ending point of the beam.
  /// - [thickness] - The thickness of the beam.
  /// - [color] - The color of the beam. Defaults to black.
  void _drawBeam({
    required Canvas canvas,
    required Offset start,
    required Offset end,
    required double thickness,
    Color color = const Color.fromRGBO(0, 0, 0, 1),
  }) {
    // Create the main beam path for the angled beam
    final Path beamPath = Path();
    beamPath.moveTo(start.dx, start.dy);
    beamPath.lineTo(start.dx, start.dy + thickness);
    beamPath.lineTo(end.dx, end.dy + thickness);
    beamPath.lineTo(end.dx, end.dy);
    beamPath.close();

    // Paint the main beam
    final Paint beamPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(beamPath, beamPaint);
  }

  @override
  bool shouldRepaint(BeamPainter oldDelegate) {
    return pattern != oldDelegate.pattern ||
        color != oldDelegate.color ||
        hookLength != oldDelegate.hookLength ||
        thickness != oldDelegate.thickness ||
        spacing != oldDelegate.spacing;
  }

  @override
  bool shouldRebuildSemantics(BeamPainter oldDelegate) => false;
}

/// Alignment options for positioning beam segments.
enum _Alignment {
  /// Align the beam segment to the start.
  start,

  /// Center the beam segment within the distance.
  middle,

  /// Align the beam segment to the end.
  end;
}

/// Represents a base class for managing beam segments with start and end points
/// of whole beam group.
///
/// Provides utility methods for calculating beam geometry, shifting vertically,
/// and deriving aligned beam segments.
class _BeamGroupBase {
  /// The starting point of the beam group.
  final Offset start;

  /// The ending point of the beam group.
  final Offset end;

  /// Calculates the angle of the line between [start] and [end] in radians.
  double get angle => atan2(end.dy - start.dy, end.dx - start.dx);

  /// Creates a new `_BeamGroupBase` with the given [start] and [end] points.
  _BeamGroupBase({
    required this.start,
    required this.end,
  });

  /// Returns a new `_BeamGroupBase` with the [start] and [end] points shifted vertically by [value].
  _BeamGroupBase shiftVertically(double value) {
    return _BeamGroupBase(
      start: start.translate(0, value),
      end: end.translate(0, value),
    );
  }

  /// Calculates the start and end points of a beam segment based on alignment and length.
  ///
  /// Parameters:
  /// - [from] - The starting x-coordinate of the beam.
  /// - [to] - The ending x-coordinate of the beam.
  /// - [length] - Optional length of the beam segment to draw. Defaults to the full distance between [from] and [to].
  /// - [alignment] - Determines how the beam segment is aligned (start, middle, or end).
  ///
  /// Returns:
  /// A tuple containing the calculated [start] and [end] offsets for the beam segment.
  ({Offset start, Offset end}) beamPoints({
    required double from,
    required double to,
    double? length,
    _Alignment alignment = _Alignment.start,
  }) {
    // Total horizontal distance between `from` and `to`.
    double distance = to - from;

    // Determine the length of the beam segment to draw.
    double lengthToDraw = length ?? distance;

    // If no changes are needed, return the original points.
    if (start.dx == from && end.dx == to && distance == lengthToDraw) {
      return (start: start, end: end);
    }

    // Initialize the start and end points for the beam segment.
    double startX = start.dx;
    double startY = start.dy;
    double endX = end.dx;
    double endY = end.dy;

    // Adjust the beam segment based on the specified alignment.
    switch (alignment) {
      case _Alignment.start:
        // Align the beam segment at the start of the distance.
        endX = from + lengthToDraw;
        endY = start.dy + lengthToDraw * tan(angle);
        break;
      case _Alignment.middle:
        // Center the beam segment within the distance.
        double halfDiff = (distance - lengthToDraw) / 2;
        double yOffset = halfDiff * tan(angle);

        startX = from + halfDiff;
        startY = start.dy + yOffset;
        endX = to - halfDiff;
        endY = end.dy - yOffset;
        break;
      case _Alignment.end:
        // Align the beam segment at the end of the distance.
        startX = to - lengthToDraw;
        startY = end.dy - lengthToDraw * tan(angle);
        break;
    }

    return (
      start: Offset(startX, startY),
      end: Offset(endX, endY),
    );
  }
}
