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
          double beamLength =
              beamsPattern[index + 1].leftOffset - noteBeams.leftOffset;

          Color? color;

          drawAngledBeam(
            angle: angle,
            canvas: canvas,
            start: Offset(start.dx, start.dy + yOffset),
            beamLength: beamLength,
            imaginaryLineLength: 0,
            imaginaryLineOffset: offsetX,
            alignment: Alignment.start,
            imaginaryLineByHorizontalSpan: true,
            // lineOffset: startingX,
            beamByHorizontalSpan: true,

            beamThickness: NotationLayoutProperties.beamThickness,
            color: color ?? const Color.fromRGBO(0, 0, 0, 1),
          );
        }

        if (beams.value == BeamValue.backwardHook) {
          drawAngledBeam(
            angle: angle,
            canvas: canvas,
            start: Offset(start.dx, start.dy + yOffset),
            beamLength: NotationLayoutProperties.defaultNoteheadHeight,
            // lineOffset: startingX,
            imaginaryLineLength: offsetX - beamsPattern[index - 1].leftOffset,
            alignment: Alignment.end,
            imaginaryLineByHorizontalSpan: true,
            beamByHorizontalSpan: false,
            beamThickness: NotationLayoutProperties.beamThickness,
            color: color ?? const Color.fromRGBO(0, 0, 0, 1),
          );
        }
      }
    }
  }

  void drawAngledBeam({
    required Canvas canvas,
    required Offset start,
    required double angle,
    required double
        imaginaryLineLength, // Length of the imaginary alignment line
    required double beamLength, // Actual length of the beam
    required Alignment alignment, // Alignment of beam along the imaginary line
    required double beamThickness,
    bool imaginaryLineByHorizontalSpan =
        false, // Flag to calculate imaginary line by horizontal span
    bool beamByHorizontalSpan =
        false, // Flag to calculate beam length by horizontal span
    double imaginaryLineOffset =
        0, // Offset for the imaginary line along its angle
    Color color = const Color.fromRGBO(0, 0, 0, 1),
  }) {
    // Calculate actual imaginary line length based on the flag
    double adjustedImaginaryLineLength = imaginaryLineByHorizontalSpan
        ? imaginaryLineLength / cos(angle) // Convert to angled length
        : imaginaryLineLength;

    // Apply imaginary line offset
    Offset adjustedImaginaryLineStart = Offset(
      start.dx + cos(angle) * imaginaryLineOffset,
      start.dy + sin(angle) * imaginaryLineOffset,
    );

    // Calculate the imaginary line’s end point
    Offset imaginaryLineEnd = Offset(
      adjustedImaginaryLineStart.dx + cos(angle) * adjustedImaginaryLineLength,
      adjustedImaginaryLineStart.dy + sin(angle) * adjustedImaginaryLineLength,
    );

    // Calculate actual beam length based on the flag
    double adjustedBeamLength = beamByHorizontalSpan
        ? beamLength / cos(angle) // Convert to angled length
        : beamLength;

    // Determine the beam's starting position based on alignment
    Offset adjustedStart;
    switch (alignment) {
      case Alignment.start:
        adjustedStart = adjustedImaginaryLineStart;
        break;
      case Alignment.middle:
        double midOffset =
            (adjustedImaginaryLineLength - adjustedBeamLength) / 2;
        adjustedStart = Offset(
          adjustedImaginaryLineStart.dx + cos(angle) * midOffset,
          adjustedImaginaryLineStart.dy + sin(angle) * midOffset,
        );
        break;
      case Alignment.end:
        double endOffset = adjustedImaginaryLineLength - adjustedBeamLength;
        adjustedStart = Offset(
          adjustedImaginaryLineStart.dx + cos(angle) * endOffset,
          adjustedImaginaryLineStart.dy + sin(angle) * endOffset,
        );
        break;
    }

    // Calculate the end point for the beam based on `adjustedBeamLength`
    Offset end = Offset(
      adjustedStart.dx + cos(angle) * adjustedBeamLength,
      adjustedStart.dy + sin(angle) * adjustedBeamLength,
    );

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

    // // Draw the imaginary line (for visualization purposes)
    // final Paint imaginaryLinePaint = Paint()
    //   ..color = Color.fromRGBO(255, 10, 100, 0.35)
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 1.0;
    // canvas.drawLine(
    //   adjustedImaginaryLineStart,
    //   imaginaryLineEnd,
    //   imaginaryLinePaint,
    // );

    // Draw the beam path on canvas
    canvas.drawPath(beamPath, beamPaint);
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
