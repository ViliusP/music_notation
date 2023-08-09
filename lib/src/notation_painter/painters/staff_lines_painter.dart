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
    var lineY = 0.0;
    for (var i = 0; i < NotationLayoutProperties.staffLines; i++) {
      canvas.drawLine(
        Offset(0, lineY),
        Offset(size.width, lineY),
        Paint()
          ..color = const Color.fromRGBO(0, 0, 0, 1.0)
          ..strokeWidth = NotationLayoutProperties.staffLineStrokeWidth,
      );
      lineY += NotationLayoutProperties.staveSpace;
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
      double halfStroke = NotationLayoutProperties.staffLineStrokeWidth / 2;

      if (position.dy > lineY - halfStroke &&
          position.dy < lineY + halfStroke) {
        return true;
      }
      lineY += NotationLayoutProperties.staveSpace;
    }
    return false;
  }
}
