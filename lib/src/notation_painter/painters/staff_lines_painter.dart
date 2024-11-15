import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/debug/debug_settings.dart';

import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';

class StaffLinesPainter extends CustomPainter {
  final int extraStaveLineCount;
  final ExtraStaveLines extraStaveLines;

  StaffLinesPainter({
    this.extraStaveLineCount = 0,
    this.extraStaveLines = ExtraStaveLines.none,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint staffLinePainter = Paint()
      ..color = const Color.fromRGBO(0, 0, 0, 1.0)
      ..strokeWidth = NotationLayoutProperties.staffLineStrokeWidth;

    double top = 0;
    double bottom = 0;
    for (bottom = top;
        bottom <= NotationLayoutProperties.defaultStaveHeight;
        bottom += NotationLayoutProperties.defaultStaveSpace) {
      canvas.drawLine(
        Offset(0, bottom),
        Offset(size.width, bottom),
        staffLinePainter,
      );
    }

    // For ledger lines debugging
    if (extraStaveLines != ExtraStaveLines.none) {
      bottom -= NotationLayoutProperties.defaultStaveSpace;

      for (int i = 0; i < extraStaveLineCount; i++) {
        top -= NotationLayoutProperties.defaultStaveSpace;
        bottom += NotationLayoutProperties.defaultStaveSpace;

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

    for (var i = 0; i < NotationLayoutProperties.staffLines; i++) {
      double halfStroke = NotationLayoutProperties.staffLineStrokeWidth;

      if (position.dy > lineY - halfStroke &&
          position.dy < lineY + halfStroke) {
        return true;
      }
      lineY += NotationLayoutProperties.defaultStaveSpace;
    }
    return false;
  }
}
