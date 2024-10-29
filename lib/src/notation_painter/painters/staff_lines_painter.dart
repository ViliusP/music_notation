import 'package:flutter/rendering.dart';

import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';

class PainterSettings {
  bool debugFrame = false;

  static final PainterSettings _instance = PainterSettings._();

  factory PainterSettings() {
    return _instance;
  }

  PainterSettings._();
}

class StaffLinesPainter extends CustomPainter {
  // final double length;

  StaffLinesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    for (var y = 0.0;
        y <= NotationLayoutProperties.staveHeight;
        y += NotationLayoutProperties.staveSpace) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        Paint()
          ..color = const Color.fromRGBO(0, 0, 0, 1.0)
          ..strokeWidth = NotationLayoutProperties.staffLineStrokeWidth,
      );
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
      lineY += NotationLayoutProperties.staveSpace;
    }
    return false;
  }
}
