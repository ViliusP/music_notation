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
        ),
        -2
      ),
      (
        VisualNoteElement.noStem(
          symbol: "symbol",
          position: const ElementPosition(octave: 3, step: Step.B),
          influencedByClef: false,
        ),
        -1
      ),
      (
        VisualNoteElement.noStem(
          symbol: "symbol",
          position: const ElementPosition(octave: 4, step: Step.C),
          influencedByClef: false,
        ),
        -1
      ),
      (
        VisualNoteElement.noStem(
          symbol: "symbol",
          position: const ElementPosition(octave: 5, step: Step.C),
          influencedByClef: false,
        ),
        0
      ),
      (
        VisualNoteElement.noStem(
          symbol: "symbol",
          position: const ElementPosition(octave: 6, step: Step.C),
          influencedByClef: false,
        ),
        2
      ),
      (
        VisualNoteElement.noStem(
          symbol: "symbol",
          position: const ElementPosition(octave: 5, step: Step.B),
          influencedByClef: false,
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
