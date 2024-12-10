import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/debug/debug_settings.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';

class AlignmentDebugPainter extends CustomPainter {
  final AlignmentPosition offset;
  final Set<AlignmentDebugOption> lines;

  const AlignmentDebugPainter({
    required this.offset,
    this.lines = const {},
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (lines.isEmpty) return;

    const double extrude = 2;
    const double effectiveExtrude = extrude / 2;

    const double start = -extrude;
    double end = size.width + extrude;

    const double startEffective = -effectiveExtrude;
    double endEffective = size.width + effectiveExtrude;

    if (offset.bottom != null && lines.contains(AlignmentDebugOption.bottom)) {
      final Paint paint = Paint()
        ..color = Color.fromRGBO(255, 0, 0, 1)
        ..strokeWidth = 3;
      double y = size.height + offset.bottom!;
      canvas.drawLine(Offset(start, y), Offset(end, y), paint);
    }

    if (lines.contains(AlignmentDebugOption.bottomEffective)) {
      final Paint paint = Paint()
        ..color = Color.fromRGBO(255, 0, 200, 0.75)
        ..strokeWidth = 2;
      double y = size.height + offset.effectiveBottom(size);
      canvas.drawLine(Offset(start, y), Offset(end, y), paint);
    }

    if (offset.top != null && lines.contains(AlignmentDebugOption.top)) {
      final Paint paint = Paint()
        ..color = Color.fromRGBO(62, 63, 0, 1)
        ..strokeWidth = 3;
      double y = -offset.top!;
      canvas.drawLine(
        Offset(startEffective, y),
        Offset(endEffective, y),
        paint,
      );
    }

    if (lines.contains(AlignmentDebugOption.topEffective)) {
      final Paint paint = Paint()
        ..color = Color.fromRGBO(88, 165, 0, 0.75)
        ..strokeWidth = 2;
      double y = -offset.effectiveTop(size);
      canvas.drawLine(
        Offset(startEffective, y),
        Offset(endEffective, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(AlignmentDebugPainter oldDelegate) {
    return oldDelegate.offset != offset;
  }

  @override
  bool shouldRebuildSemantics(AlignmentDebugPainter oldDelegate) => false;
}
