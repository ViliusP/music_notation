import 'package:flutter/widgets.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';

abstract class MeasureWidget extends Widget {
  ElementPosition get position;
  Size get size;
  double get positionalOffset;

  const MeasureWidget({super.key});
}
