import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:test/test.dart';

void main() {
  group('Operators', () {
    // ==
    test("true: G4 == G4  ", () {
      var a = ElementPosition(step: Step.G, octave: 4);
      var b = ElementPosition(step: Step.G, octave: 4);

      expect(a == b, isTrue);
    });
    test("false: G4 == C9  ", () {
      var a = ElementPosition(step: Step.G, octave: 4);
      var b = ElementPosition(step: Step.C, octave: 9);

      expect(a == b, isFalse);
    });
    // <
    test("false: G4 < G4  ", () {
      var a = ElementPosition(step: Step.G, octave: 4);
      var b = ElementPosition(step: Step.G, octave: 4);

      expect(a < b, isFalse);
    });
    test("true: G5 < D6  ", () {
      var a = ElementPosition(step: Step.G, octave: 5);
      var b = ElementPosition(step: Step.D, octave: 6);

      expect(a < b, isTrue);
    });
    test("false: G4 < C3  ", () {
      var a = ElementPosition(step: Step.G, octave: 4);
      var b = ElementPosition(step: Step.C, octave: 3);

      expect(a < b, isFalse);
    });
    // >
    test("false: G4 > G4  ", () {
      var a = ElementPosition(step: Step.G, octave: 4);
      var b = ElementPosition(step: Step.G, octave: 4);

      expect(a > b, isFalse);
    });
    test("true: G5 > D6  ", () {
      var a = ElementPosition(step: Step.G, octave: 5);
      var b = ElementPosition(step: Step.D, octave: 6);

      expect(a > b, isFalse);
    });
    test("false: G4 > C3  ", () {
      var a = ElementPosition(step: Step.G, octave: 4);
      var b = ElementPosition(step: Step.C, octave: 3);

      expect(a > b, isTrue);
    });
    // >=
    test("true: G4 >= G4  ", () {
      var a = ElementPosition(step: Step.G, octave: 4);
      var b = ElementPosition(step: Step.G, octave: 4);

      expect(a >= b, true);
    });
    test("true: G5 >= D6  ", () {
      var a = ElementPosition(step: Step.G, octave: 5);
      var b = ElementPosition(step: Step.D, octave: 6);

      expect(a >= b, isFalse);
    });
    test("false: G4 > C3  ", () {
      var a = ElementPosition(step: Step.G, octave: 4);
      var b = ElementPosition(step: Step.C, octave: 3);

      expect(a >= b, isTrue);
    });
    // <=
    test("true: G4 <= G4  ", () {
      var a = ElementPosition(step: Step.G, octave: 4);
      var b = ElementPosition(step: Step.G, octave: 4);

      expect(a <= b, true);
    });
    test("true: G5 >= D6  ", () {
      var a = ElementPosition(step: Step.G, octave: 5);
      var b = ElementPosition(step: Step.D, octave: 6);

      expect(a <= b, isTrue);
    });
    test("false: G4 > C3  ", () {
      var a = ElementPosition(step: Step.G, octave: 4);
      var b = ElementPosition(step: Step.C, octave: 3);

      expect(a <= b, isFalse);
    });
  });
}
