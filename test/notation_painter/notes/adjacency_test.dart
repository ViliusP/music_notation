import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/notes/adjacency.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:test/test.dart';

void main() {
  group(
    "Notehead position determination in chord",
    () {
      test("Two notes #1 (F4, G4)", () {
        final testCase = (
          positions: [
            ElementPosition(step: Step.F, octave: 4),
            ElementPosition(step: Step.G, octave: 4),
          ],
          stemDirection: StemDirection.down,
          expected: [NoteheadSide.left, NoteheadSide.right],
        );

        String notesDescription = testCase.positions
            .map((note) => "${note.step}${note.octave}")
            .join(", ");
        notesDescription = "($notesDescription)";

        var result = Adjacency.determineNoteSides(
          testCase.positions,
          testCase.stemDirection,
        );
        expect(result, orderedEquals(testCase.expected));
      });
      test("Two notes #1 (E5, F5)", () {
        final testCase = (
          positions: [
            ElementPosition(step: Step.E, octave: 5),
            ElementPosition(step: Step.F, octave: 5),
          ],
          stemDirection: StemDirection.down,
          expected: [NoteheadSide.left, NoteheadSide.right],
        );

        String notesDescription = testCase.positions
            .map((note) => "${note.step}${note.octave}")
            .join(", ");
        notesDescription = "($notesDescription)";

        var result = Adjacency.determineNoteSides(
          testCase.positions,
          testCase.stemDirection,
        );
        expect(result, orderedEquals(testCase.expected));
      });
      test("Odd number (3) of notes, below middle (F4, G4, A4)", () {
        final testCase = (
          positions: [
            ElementPosition(step: Step.F, octave: 4),
            ElementPosition(step: Step.G, octave: 4),
            ElementPosition(step: Step.A, octave: 4),
          ],
          stemDirection: StemDirection.up,
          expected: [
            NoteheadSide.left,
            NoteheadSide.right,
            NoteheadSide.left,
          ],
        );

        String notesDescription = testCase.positions
            .map((note) => "${note.step}${note.octave}")
            .join(", ");
        notesDescription = "($notesDescription)";

        var result = Adjacency.determineNoteSides(
          testCase.positions,
          testCase.stemDirection,
        );
        expect(result, orderedEquals(testCase.expected));
      });
      test(
        "Odd number (7) of notes, below the middle (E4, F4, G4, A4, B4, C5, D5)",
        () {
          final testCase = (
            positions: [
              ElementPosition(step: Step.E, octave: 4),
              ElementPosition(step: Step.F, octave: 4),
              ElementPosition(step: Step.G, octave: 4),
              ElementPosition(step: Step.A, octave: 4),
              ElementPosition(step: Step.B, octave: 4),
              ElementPosition(step: Step.C, octave: 5),
              ElementPosition(step: Step.D, octave: 5),
            ],
            stemDirection: StemDirection.up,
            expected: [
              NoteheadSide.left,
              NoteheadSide.right,
              NoteheadSide.left,
              NoteheadSide.right,
              NoteheadSide.left,
              NoteheadSide.right,
              NoteheadSide.left,
            ],
          );

          String notesDescription = testCase.positions
              .map((note) => "${note.step}${note.octave}")
              .join(", ");
          notesDescription = "($notesDescription)";

          var result = Adjacency.determineNoteSides(
            testCase.positions,
            testCase.stemDirection,
          );
          expect(result, orderedEquals(testCase.expected));
        },
      );
      test(
        "Odd number (3) of notes, above the middle (C5, D5, E5)",
        () {
          final testCase = (
            positions: [
              ElementPosition(step: Step.C, octave: 5),
              ElementPosition(step: Step.D, octave: 5),
              ElementPosition(step: Step.E, octave: 5),
            ],
            stemDirection: StemDirection.down,
            expected: [
              NoteheadSide.right,
              NoteheadSide.left,
              NoteheadSide.right,
            ],
          );

          String notesDescription = testCase.positions
              .map((note) => "${note.step}${note.octave}")
              .join(", ");
          notesDescription = "($notesDescription)";

          var result = Adjacency.determineNoteSides(
            testCase.positions,
            testCase.stemDirection,
          );
          expect(result, orderedEquals(testCase.expected));
        },
      );
      test(
        "Odd number (5) of notes, above the middle (D5, E5, F5, G5, A5)",
        () {
          final testCase = (
            positions: [
              ElementPosition(step: Step.D, octave: 5),
              ElementPosition(step: Step.E, octave: 5),
              ElementPosition(step: Step.F, octave: 5),
              ElementPosition(step: Step.G, octave: 5),
              ElementPosition(step: Step.A, octave: 5),
            ],
            stemDirection: StemDirection.down,
            expected: [
              NoteheadSide.right,
              NoteheadSide.left,
              NoteheadSide.right,
              NoteheadSide.left,
              NoteheadSide.right,
            ],
          );

          String notesDescription = testCase.positions
              .map((note) => "${note.step}${note.octave}")
              .join(", ");
          notesDescription = "($notesDescription)";

          var result = Adjacency.determineNoteSides(
            testCase.positions,
            testCase.stemDirection,
          );
          expect(result, orderedEquals(testCase.expected));
        },
      );
      test(
        "Even number (4) of notes, below the middle (F5, G5, A5, B5)",
        () {
          final testCase = (
            positions: [
              ElementPosition(step: Step.F, octave: 4),
              ElementPosition(step: Step.G, octave: 4),
              ElementPosition(step: Step.A, octave: 4),
              ElementPosition(step: Step.B, octave: 4),
            ],
            stemDirection: StemDirection.up,
            expected: [
              NoteheadSide.left,
              NoteheadSide.right,
              NoteheadSide.left,
              NoteheadSide.right,
            ],
          );

          String notesDescription = testCase.positions
              .map((note) => "${note.step}${note.octave}")
              .join(", ");
          notesDescription = "($notesDescription)";

          var result = Adjacency.determineNoteSides(
            testCase.positions,
            testCase.stemDirection,
          );
          expect(result, orderedEquals(testCase.expected));
        },
      );

      test(
        "Even number (6) of notes, above the middle (D5, E5, F5, G5, A5, B5)",
        () {
          final testCase = (
            positions: [
              ElementPosition(step: Step.D, octave: 5),
              ElementPosition(step: Step.E, octave: 5),
              ElementPosition(step: Step.F, octave: 5),
              ElementPosition(step: Step.G, octave: 5),
              ElementPosition(step: Step.A, octave: 5),
              ElementPosition(step: Step.B, octave: 5),
            ],
            stemDirection: StemDirection.down,
            expected: [
              NoteheadSide.left,
              NoteheadSide.right,
              NoteheadSide.left,
              NoteheadSide.right,
              NoteheadSide.left,
              NoteheadSide.right,
            ],
          );

          String notesDescription = testCase.positions
              .map((note) => "${note.step}${note.octave}")
              .join(", ");
          notesDescription = "($notesDescription)";

          var result = Adjacency.determineNoteSides(
            testCase.positions,
            testCase.stemDirection,
          );
          expect(result, orderedEquals(testCase.expected));
        },
      );

      test(
        "Adjacent notes in multiple groups #1 (A4, B4, F5, G5)",
        () {
          final testCase = (
            positions: [
              ElementPosition(step: Step.A, octave: 4),
              ElementPosition(step: Step.B, octave: 4),
              ElementPosition(step: Step.F, octave: 5),
              ElementPosition(step: Step.G, octave: 5),
            ],
            stemDirection: StemDirection.down,
            expected: [
              NoteheadSide.left,
              NoteheadSide.right,
              NoteheadSide.left,
              NoteheadSide.right,
            ],
          );

          String notesDescription = testCase.positions
              .map((note) => "${note.step}${note.octave}")
              .join(", ");
          notesDescription = "($notesDescription)";

          var result = Adjacency.determineNoteSides(
            testCase.positions,
            testCase.stemDirection,
          );
          expect(result, orderedEquals(testCase.expected));
        },
      );
      test(
        "Adjacent notes in multiple groups #1 (G4, A4, C5, D5)",
        () {
          final testCase = (
            positions: [
              ElementPosition(step: Step.G, octave: 4),
              ElementPosition(step: Step.A, octave: 4),
              ElementPosition(step: Step.C, octave: 5),
              ElementPosition(step: Step.D, octave: 5),
            ],
            stemDirection: StemDirection.up,
            expected: [
              NoteheadSide.left,
              NoteheadSide.right,
              NoteheadSide.left,
              NoteheadSide.right,
            ],
          );

          String notesDescription = testCase.positions
              .map((note) => "${note.step}${note.octave}")
              .join(", ");
          notesDescription = "($notesDescription)";

          var result = Adjacency.determineNoteSides(
            testCase.positions,
            testCase.stemDirection,
          );
          expect(result, orderedEquals(testCase.expected));
        },
      );
      test(
        "Adjacent notes in multiple groups #3 (E4, G4, A5)",
        () {
          final testCase = (
            positions: [
              ElementPosition(step: Step.E, octave: 4),
              ElementPosition(step: Step.G, octave: 4),
              ElementPosition(step: Step.A, octave: 4),
            ],
            stemDirection: StemDirection.up,
            expected: [
              NoteheadSide.left,
              NoteheadSide.left,
              NoteheadSide.right,
            ],
          );

          String notesDescription = testCase.positions
              .map((note) => "${note.step}${note.octave}")
              .join(", ");
          notesDescription = "($notesDescription)";

          var result = Adjacency.determineNoteSides(
            testCase.positions,
            testCase.stemDirection,
          );
          expect(result, orderedEquals(testCase.expected));
        },
      );
    },
  );
}
