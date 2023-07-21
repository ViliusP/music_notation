import 'dart:ui';

import 'package:music_notation/src/models/elements/score/part.dart';

class StaffPainterContext {
  Offset _offset = const Offset(0, 0);
  Offset get offset => _offset;

  void moveX(double x) {
    _offset += Offset(x, 0);
  }

  void moveY(double y) {
    _offset += Offset(0, y);
  }

  Part? currentPart;
  Measure? currentMeasure;

  // bool lastNoteChord = false;

  final Canvas canvas;
  final Size size;

  StaffPainterContext({required this.canvas, required this.size});
}
