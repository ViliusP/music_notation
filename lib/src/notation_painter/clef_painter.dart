import 'package:flutter/rendering.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/notation_painter/staff_painter.dart';

class ClefPainter extends CustomPainter {
  final Offset offset;
  final Clef clef;
  String? get clefSymbol => clefSignToSymbol(clef);

  ClefPainter({
    required this.clef,
    this.offset = const Offset(0, 0),
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (clefSymbol != null) {
      drawSmuflSymbol(
        canvas,
        Offset(offset.dx, offset.dy - 5),
        clefSymbol!,
      );
    }
  }

  static String? clefSignToSymbol(Clef clef) {
    switch (clef.sign) {
      case ClefSign.G:
        return '\uE050';
      case ClefSign.F:
        return '\uE062';
      case ClefSign.C:
        return '\uE05C';
      case ClefSign.percussion:
        return '\uE069';
      case ClefSign.tab:
        return '\uE06D';
      default:
        return null;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
