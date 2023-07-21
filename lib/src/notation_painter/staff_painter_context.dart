import 'dart:ui';

import 'package:music_notation/src/models/elements/score/part.dart';

class StaffPainterContext {
  Offset offset = const Offset(0, 0);
  Part? currentPart;
  Measure? currentMeasure;

  // bool lastNoteChord = false;

  final Canvas canvas;
  final Size size;

  StaffPainterContext({required this.canvas, required this.size});
}
