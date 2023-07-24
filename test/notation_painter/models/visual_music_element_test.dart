import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/visual_music_element.dart';
import 'package:test/test.dart';

void main() {
  group('Distance from the middle (B4)', () {
    var inputsOutputs = [
      (
        VisualMusicElement(
          symbol: "symbol",
          position: const ElementPosition(octave: 4, step: Step.C),
        ),
        -6
      ),
      (
        VisualMusicElement(
          symbol: "symbol",
          position: const ElementPosition(octave: 4, step: Step.E),
        ),
        -4
      ),
      (
        VisualMusicElement(
          symbol: "symbol",
          position: const ElementPosition(octave: 4, step: Step.A),
        ),
        -1
      ),
      (
        VisualMusicElement(
          symbol: "symbol",
          position: const ElementPosition(octave: 4, step: Step.B),
        ),
        0
      ),
      (
        VisualMusicElement(
          symbol: "symbol",
          position: const ElementPosition(octave: 5, step: Step.C),
        ),
        1
      ),
      (
        VisualMusicElement(
          symbol: "symbol",
          position: const ElementPosition(octave: 5, step: Step.G),
        ),
        5
      ),
      (
        VisualMusicElement(
          symbol: "symbol",
          position: const ElementPosition(octave: 6, step: Step.C),
        ),
        8
      ),
    ];

    for (var (input, output) in inputsOutputs) {
      test("${input.position} should be $output from the middle", () {
        expect(input.distanceFromMiddle, output);
      });
    }
  });
}
