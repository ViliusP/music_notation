import 'dart:math';

import 'package:flutter/material.dart';
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
    final Paint paint = Paint()
      ..color = color ?? const Color.fromRGBO(0, 0, 0, 1)
      ..strokeWidth = 0;

    // Define the main beam path and calculate the end point based on direction
    final Path path = Path();

    // Calculate start and end based on the beam direction
    Offset start;
    Offset end;
    if (!downward) {
      start = Offset(0, size.height - beamThickness);
      end = Offset(size.width, 0); // End point corrected to top-right
      paint.color = const Color.fromRGBO(0, 0, 0, 1); // Color for upward beam
    } else {
      start = Offset(0, 0);
      end = Offset(size.width, size.height - beamThickness);
      paint.color =
          const Color.fromRGBO(255, 100, 0, 0.5); // Color for downward beam
    }

    // Draw main beam
    path.moveTo(start.dx, start.dy);
    path.lineTo(start.dx, start.dy + beamThickness);
    path.lineTo(end.dx, end.dy + beamThickness);
    path.lineTo(end.dx, end.dy);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BeamPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BeamPainter oldDelegate) => false;
}
