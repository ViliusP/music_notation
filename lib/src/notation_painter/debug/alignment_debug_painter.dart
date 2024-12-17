import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/debug/debug_settings.dart';

class AlignmentDebugPainter extends CustomPainter {
  final Alignment alignment;
  final Set<AlignmentDebugOption> lines;

  const AlignmentDebugPainter({
    required this.alignment,
    this.lines = const {},
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (lines.isEmpty) return;

    const double extrude = 2;

    const double start = -extrude;
    double end = size.width + extrude;

    if (lines.isNotEmpty) {
      final Paint paint = Paint()
        ..color = Color.fromRGBO(255, 0, 0, 1)
        ..strokeWidth = 3;
      double y = size.height + (size.height * alignment.x);
      canvas.drawLine(Offset(start, y), Offset(end, y), paint);
    }
  }

  @override
  bool shouldRepaint(AlignmentDebugPainter oldDelegate) {
    return oldDelegate.alignment != alignment;
  }

  @override
  bool shouldRebuildSemantics(AlignmentDebugPainter oldDelegate) => false;
}
