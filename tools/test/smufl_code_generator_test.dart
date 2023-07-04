import 'package:cli/smufl_code_generator.dart';
import 'package:test/test.dart';

void main() {
  group('toUnderscoreCase', () {
    var testCases = [
      ("accidentals", "accidentals"),
      ("accidentals24EDOArrows", "accidentals_24edo_arrows"),
      ("accidentalsHelmholtzEllis", "accidentals_helmholtz_ellis"),
      ("accidentalsSagittalMixed", "accidentals_sagittal_mixed"),
      ("tf_ornaments", "tf_ornaments"),
      ("tf_metronomeMarks", "tf_metronome_marks"),
      ("tf_chordSymbolAccidentals", "tf_chord_symbol_accidentals")
    ];
    for (var (input, expected) in testCases) {
      test('should convert "$input" to "$expected"', () {
        expect(
          SmuflCodeGenerator.toUnderscoreCase(input),
          expected,
        );
      });
    }
  });
}
