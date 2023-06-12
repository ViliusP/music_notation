import 'package:music_notation/models/elements/music_data/direction/direction_type.dart';
import 'package:music_notation/models/elements/music_data/note/note.dart';
import 'package:music_notation/models/printing.dart';

/// The harp-pedals type is used to create harp pedal diagrams.
///
/// The pedal-step and pedal-alter elements use the same values as the step and alter elements.
///
/// For easiest reading, the pedal-tuning elements should follow standard harp pedal order,
/// with pedal-step values of D, C, B, E, F, G, and A.
class HarpPedals implements DirectionType {
  List<PedalTuning> pedalTunings;

  PrintStyleAlign printStyleAlign;

  /// Specifies an ID that is unique to the entire document.
  String id;

  HarpPedals({
    required this.pedalTunings,
    required this.printStyleAlign,
    required this.id,
  });
}

/// The pedal-tuning type specifies the tuning of a single harp pedal.
class PedalTuning {
  /// The pedal-step element defines the pitch step for a single harp pedal.
  Step step;

  /// The semitones is a number representing semitones, used for chromatic alteration.
  ///
  /// A value of -1 corresponds to a flat and a value of 1 to a sharp. Decimal values like 0.5 (quarter tone sharp) are used for microtones.
  ///
  /// The pedal-alter element defines the chromatic alteration for a single harp pedal.
  double semitones;

  PedalTuning({
    required this.step,
    required this.semitones,
  });
}
