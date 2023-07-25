import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/visual_note_element.dart';
import 'package:test/test.dart';

void main() {
  group('Ledger lines', () {
    var inputsOutputs = [
      (
        VisualNoteElement.noStem(
            symbol: "symbol",
            position: const ElementPosition(octave: 3, step: Step.A),
            influencedByClef: false,
            noteheadWidth: 0),
        -2
      ),
      (
        VisualNoteElement.noStem(
          symbol: "symbol",
          position: const ElementPosition(octave: 3, step: Step.B),
          influencedByClef: false,
          noteheadWidth: 0,
        ),
        -1
      ),
      (
        VisualNoteElement.noStem(
          symbol: "symbol",
          position: const ElementPosition(octave: 4, step: Step.C),
          influencedByClef: false,
          noteheadWidth: 0,
        ),
        -1
      ),
      (
        VisualNoteElement.noStem(
          symbol: "symbol",
          position: const ElementPosition(octave: 5, step: Step.C),
          influencedByClef: false,
          noteheadWidth: 0,
        ),
        0
      ),
      (
        VisualNoteElement.noStem(
          symbol: "symbol",
          position: const ElementPosition(octave: 6, step: Step.C),
          influencedByClef: false,
          noteheadWidth: 0,
        ),
        2
      ),
      (
        VisualNoteElement.noStem(
          symbol: "symbol",
          position: const ElementPosition(octave: 5, step: Step.B),
          influencedByClef: false,
          noteheadWidth: 0,
        ),
        1
      ),
    ];

    for (var (input, output) in inputsOutputs) {
      test("${input.position} should have $output ledger lines", () {
        expect(input.ledgerLines, output);
      });
    }
  });
}
