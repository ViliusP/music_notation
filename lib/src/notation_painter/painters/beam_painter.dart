import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:music_notation/src/models/elements/music_data/note/beam.dart';
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

    drawAngledBeam(
      angle: angle,
      canvas: canvas,
      start: Offset(start.dx, start.dy),
      length: end.dx - start.dx,
      lengthType: LengthType.horizontalSpan,
      beamThickness: NotationLayoutProperties.beamThickness,
      color: color ?? const Color.fromRGBO(0, 0, 0, 1),
    );
  }

  void drawAngledBeam({
    required Canvas canvas,
    required Offset start,
    required double angle,
    required double length, // Length parameter, interpreted based on LengthType
    required LengthType lengthType,
    required double beamThickness,
    Color color = const Color.fromRGBO(0, 0, 0, 1),
  }) {
    Offset end;
    Offset adjustedStart = start;

    if (lengthType == LengthType.horizontalSpan) {
      // Treat length as the horizontal distance (xLength)
      end = Offset(
        start.dx + length, // Horizontal span
        start.dy + tan(angle) * length, // Y offset based on angle
      );
    } else {
      // Treat length as angled length, calculate end based on angle
      double xLength = cos(angle) * length; // Projected x length of the beam
      double xDiff =
          xLength - length; // Difference between angled and horizontal length

      if (lengthType == LengthType.angledStart) {
        // Position start directly, place extra space at the end
        end = Offset(
          start.dx + cos(angle) * length, // Angled span to match length
          start.dy + sin(angle) * length,
        );
      } else {
        // Place extra space at the start by shifting start point backward
        adjustedStart = Offset(
          start.dx - cos(angle) * xDiff, // Shift start backward along angle
          start.dy - sin(angle) * xDiff,
        );

        // Calculate end point from the adjusted start point
        end = Offset(
          adjustedStart.dx + cos(angle) * length,
          adjustedStart.dy + sin(angle) * length,
        );
      }
    }

    // Create the main beam path
    final Path beamPath = Path();
    beamPath.moveTo(adjustedStart.dx, adjustedStart.dy);
    beamPath.lineTo(adjustedStart.dx, adjustedStart.dy + beamThickness);
    beamPath.lineTo(end.dx, end.dy + beamThickness);
    beamPath.lineTo(end.dx, end.dy);
    beamPath.close();

    // Paint for the beam
    final Paint beamPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw the beam path on canvas
    canvas.drawPath(beamPath, beamPaint);
  }

  @override
  bool shouldRepaint(BeamPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BeamPainter oldDelegate) => false;
}

enum LengthType {
  horizontalSpan, // Horizontal span, connects start to end along the angle
  angledStart, // Angled length with spacing at the end
  angledEnd, // Angled length with spacing at the start
}
