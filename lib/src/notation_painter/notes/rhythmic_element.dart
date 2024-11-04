import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/notation_layout_properties.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';

///
abstract class RhythmicElement extends MeasureWidget {
  final double stemLength;

  final double divisions;
  final double duration;

  final Offset offsetForBeam;

  final StemDirection? stemDirection;

  const RhythmicElement({
    super.key,
    this.stemLength = NotationLayoutProperties.standardStemLength,
    required this.divisions,
    required this.duration,
    required this.offsetForBeam,
    this.stemDirection,
  });
}
