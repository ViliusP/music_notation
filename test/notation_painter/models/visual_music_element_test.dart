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
          influencedByClef: false,
        ),
        -6
      ),
      (
        VisualMusicElement(
          symbol: "symbol",
          position: const ElementPosition(octave: 4, step: Step.E),
          influencedByClef: false,
        ),
        -4
      ),
      (
        VisualMusicElement(
          symbol: "symbol",
          position: const ElementPosition(octave: 4, step: Step.A),
          influencedByClef: false,
        ),
        -1
      ),
      (
        VisualMusicElement(
          symbol: "symbol",
          position: const ElementPosition(octave: 4, step: Step.B),
          influencedByClef: false,
        ),
        0
      ),
      (
        VisualMusicElement(
          symbol: "symbol",
          position: const ElementPosition(octave: 5, step: Step.C),
          influencedByClef: false,
        ),
        1
      ),
      (
        VisualMusicElement(
          symbol: "symbol",
          position: const ElementPosition(octave: 5, step: Step.G),
          influencedByClef: false,
        ),
        5
      ),
      (
        VisualMusicElement(
          symbol: "symbol",
          position: const ElementPosition(octave: 6, step: Step.C),
          influencedByClef: false,
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
