import 'package:flutter/rendering.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';

///
abstract class RhythmicElement extends MeasureWidget {
  final double baseStemLength;

  final double duration;

  final Offset offsetForBeam;

  final StemDirection? stemDirection;

  final NotationContext notationContext;

  const RhythmicElement({
    super.key,
    required this.baseStemLength,
    required this.duration,
    required this.offsetForBeam,
    required this.notationContext,
    this.stemDirection,
  });
}
