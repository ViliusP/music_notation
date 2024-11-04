import 'package:music_notation/src/models/data_types/accidental_value.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/key.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';

class OctavedKeyAccidental extends PitchedKeyAccidental {
  final int octave;

  const OctavedKeyAccidental({
    required super.step,
    required super.alter,
    required this.octave,
    super.accidental,
  });

  OctavedKeyAccidental.fromParent({
    required PitchedKeyAccidental keyAccidental,
    required int octave,
  }) : this(
          alter: keyAccidental.alter,
          step: keyAccidental.step,
          accidental: keyAccidental.accidental,
          octave: octave,
        );

  ElementPosition get position => ElementPosition(step: step, octave: octave);

  OctavedKeyAccidental toNatural() {
    return OctavedKeyAccidental(
      alter: alter,
      step: step,
      octave: octave,
      accidental: KeyAccidental(value: AccidentalValue.natural),
    );
  }
}
