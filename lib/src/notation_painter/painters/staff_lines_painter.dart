import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/debug/debug_settings.dart';

class StaffLinesPainter extends CustomPainter {
  final double spacing;
  final double thickness;
  final int extraStaveLineCount;
  final ExtraStaveLines extraStaveLines;

  StaffLinesPainter({
    required this.spacing,
    this.extraStaveLineCount = 0,
    required this.thickness,
    this.extraStaveLines = ExtraStaveLines.none,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint staffLinePainter = Paint()
      ..color = const Color.fromRGBO(0, 0, 0, 1.0)
      ..strokeWidth = thickness;

    double bottom = 0;
    for (; bottom <= size.height; bottom += spacing) {
      canvas.drawLine(
        Offset(0, bottom),
        Offset(size.width, bottom),
        staffLinePainter,
      );
    }

    // For ledger lines debugging
    if (extraStaveLines != ExtraStaveLines.none) {
      double top = 0;

      bottom -= spacing;

      for (int i = 0; i < extraStaveLineCount; i++) {
        top -= spacing;
        bottom += spacing;

        if (extraStaveLines == ExtraStaveLines.above ||
            extraStaveLines == ExtraStaveLines.double) {
          canvas.drawLine(
            Offset(0, top),
            Offset(size.width, top),
            staffLinePainter..color = const Color.fromRGBO(125, 0, 0, .5),
          );
        }

        if (extraStaveLines == ExtraStaveLines.below ||
            extraStaveLines == ExtraStaveLines.double) {
          canvas.drawLine(
            Offset(0, bottom),
            Offset(size.width, bottom),
            staffLinePainter..color = const Color.fromRGBO(0, 0, 125, .5),
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  @override
  bool hitTest(Offset position) {
    var lineY = 0.0;

    for (var i = 0; i < 5; i++) {
      double halfStroke = thickness;

      if (position.dy > lineY - halfStroke &&
          position.dy < lineY + halfStroke) {
        return true;
      }
      lineY += spacing;
    }
    return false;
  }
}
