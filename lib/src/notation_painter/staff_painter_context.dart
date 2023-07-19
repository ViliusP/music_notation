import 'dart:ui';

class StaffPainterContext {
  Offset offset = const Offset(0, 0);
  // bool lastNoteChord = false;

  final Canvas canvas;
  final Size size;

  StaffPainterContext({required this.canvas, required this.size});
}
