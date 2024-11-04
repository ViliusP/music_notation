import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/notation_painter/notes/adjacency.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:test/test.dart';

void main() {
  group(
    "Notehead position determination in chord",
    () {
      test("Two notes #1 (F4, G4)", () {
        final testCase = (
          notes: [
            RegularNote(form: Pitch(step: Step.F, octave: 4), duration: 0),
            RegularNote(form: Pitch(step: Step.G, octave: 4), duration: 0),
          ],
          stemDirection: StemDirection.down,
          expected: [NoteheadPosition.left, NoteheadPosition.right],
        );

        String notesDescription = testCase.notes
            .map((note) => "${note.form.step}${note.form.octave}")
            .join(", ");
        notesDescription = "($notesDescription)";

        var result = Adjacency.determineNoteheadPositions(
          testCase.notes,
          testCase.stemDirection,
        );
        expect(result, orderedEquals(testCase.expected));
      });
      test("Two notes #1 (E5, F5)", () {
        final testCase = (
          notes: [
            RegularNote(form: Pitch(step: Step.E, octave: 5), duration: 0),
            RegularNote(form: Pitch(step: Step.F, octave: 5), duration: 0),
          ],
          stemDirection: StemDirection.down,
          expected: [NoteheadPosition.left, NoteheadPosition.right],
        );

        String notesDescription = testCase.notes
            .map((note) => "${note.form.step}${note.form.octave}")
            .join(", ");
        notesDescription = "($notesDescription)";

        var result = Adjacency.determineNoteheadPositions(
          testCase.notes,
          testCase.stemDirection,
        );
        expect(result, orderedEquals(testCase.expected));
      });
      test("Odd number (3) of notes, below middle (F4, G4, A4)", () {
        final testCase = (
          notes: [
            RegularNote(form: Pitch(step: Step.F, octave: 4), duration: 0),
            RegularNote(form: Pitch(step: Step.G, octave: 4), duration: 0),
            RegularNote(form: Pitch(step: Step.A, octave: 4), duration: 0),
          ],
          stemDirection: StemDirection.up,
          expected: [
            NoteheadPosition.left,
            NoteheadPosition.right,
            NoteheadPosition.left,
          ],
        );

        String notesDescription = testCase.notes
            .map((note) => "${note.form.step}${note.form.octave}")
            .join(", ");
        notesDescription = "($notesDescription)";

        var result = Adjacency.determineNoteheadPositions(
          testCase.notes,
          testCase.stemDirection,
        );
        expect(result, orderedEquals(testCase.expected));
      });
      test(
        "Odd number (7) of notes, below the middle (E4, F4, G4, A4, B4, C5, D5)",
        () {
          final testCase = (
            notes: [
              RegularNote(form: Pitch(step: Step.E, octave: 4), duration: 0),
              RegularNote(form: Pitch(step: Step.F, octave: 4), duration: 0),
              RegularNote(form: Pitch(step: Step.G, octave: 4), duration: 0),
              RegularNote(form: Pitch(step: Step.A, octave: 4), duration: 0),
              RegularNote(form: Pitch(step: Step.B, octave: 4), duration: 0),
              RegularNote(form: Pitch(step: Step.C, octave: 5), duration: 0),
              RegularNote(form: Pitch(step: Step.D, octave: 5), duration: 0),
            ],
            stemDirection: StemDirection.up,
            expected: [
              NoteheadPosition.left,
              NoteheadPosition.right,
              NoteheadPosition.left,
              NoteheadPosition.right,
              NoteheadPosition.left,
              NoteheadPosition.right,
              NoteheadPosition.left,
            ],
          );

          String notesDescription = testCase.notes
              .map((note) => "${note.form.step}${note.form.octave}")
              .join(", ");
          notesDescription = "($notesDescription)";

          var result = Adjacency.determineNoteheadPositions(
            testCase.notes,
            testCase.stemDirection,
          );
          expect(result, orderedEquals(testCase.expected));
        },
      );
      test(
        "Odd number (3) of notes, above the middle (C5, D5, E5)",
        () {
          final testCase = (
            notes: [
              RegularNote(form: Pitch(step: Step.C, octave: 5), duration: 0),
              RegularNote(form: Pitch(step: Step.D, octave: 5), duration: 0),
              RegularNote(form: Pitch(step: Step.E, octave: 5), duration: 0),
            ],
            stemDirection: StemDirection.down,
            expected: [
              NoteheadPosition.right,
              NoteheadPosition.left,
              NoteheadPosition.right,
            ],
          );

          String notesDescription = testCase.notes
              .map((note) => "${note.form.step}${note.form.octave}")
              .join(", ");
          notesDescription = "($notesDescription)";

          var result = Adjacency.determineNoteheadPositions(
            testCase.notes,
            testCase.stemDirection,
          );
          expect(result, orderedEquals(testCase.expected));
        },
      );
      test(
        "Odd number (5) of notes, above the middle (D5, E5, F5, G5, A5)",
        () {
          final testCase = (
            notes: [
              RegularNote(form: Pitch(step: Step.D, octave: 5), duration: 0),
              RegularNote(form: Pitch(step: Step.E, octave: 5), duration: 0),
              RegularNote(form: Pitch(step: Step.F, octave: 5), duration: 0),
              RegularNote(form: Pitch(step: Step.G, octave: 5), duration: 0),
              RegularNote(form: Pitch(step: Step.A, octave: 5), duration: 0),
            ],
            stemDirection: StemDirection.down,
            expected: [
              NoteheadPosition.right,
              NoteheadPosition.left,
              NoteheadPosition.right,
              NoteheadPosition.left,
              NoteheadPosition.right,
            ],
          );

          String notesDescription = testCase.notes
              .map((note) => "${note.form.step}${note.form.octave}")
              .join(", ");
          notesDescription = "($notesDescription)";

          var result = Adjacency.determineNoteheadPositions(
            testCase.notes,
            testCase.stemDirection,
          );
          expect(result, orderedEquals(testCase.expected));
        },
      );
      test(
        "Even number (4) of notes, below the middle (F5, G5, A5, B5)",
        () {
          final testCase = (
            notes: [
              RegularNote(form: Pitch(step: Step.F, octave: 4), duration: 0),
              RegularNote(form: Pitch(step: Step.G, octave: 4), duration: 0),
              RegularNote(form: Pitch(step: Step.A, octave: 4), duration: 0),
              RegularNote(form: Pitch(step: Step.B, octave: 4), duration: 0),
            ],
            stemDirection: StemDirection.up,
            expected: [
              NoteheadPosition.left,
              NoteheadPosition.right,
              NoteheadPosition.left,
              NoteheadPosition.right,
            ],
          );

          String notesDescription = testCase.notes
              .map((note) => "${note.form.step}${note.form.octave}")
              .join(", ");
          notesDescription = "($notesDescription)";

          var result = Adjacency.determineNoteheadPositions(
            testCase.notes,
            testCase.stemDirection,
          );
          expect(result, orderedEquals(testCase.expected));
        },
      );

      test(
        "Even number (6) of notes, above the middle (D5, E5, F5, G5, A5, B5)",
        () {
          final testCase = (
            notes: [
              RegularNote(form: Pitch(step: Step.D, octave: 5), duration: 0),
              RegularNote(form: Pitch(step: Step.E, octave: 5), duration: 0),
              RegularNote(form: Pitch(step: Step.F, octave: 5), duration: 0),
              RegularNote(form: Pitch(step: Step.G, octave: 5), duration: 0),
              RegularNote(form: Pitch(step: Step.A, octave: 5), duration: 0),
              RegularNote(form: Pitch(step: Step.B, octave: 5), duration: 0),
            ],
            stemDirection: StemDirection.down,
            expected: [
              NoteheadPosition.left,
              NoteheadPosition.right,
              NoteheadPosition.left,
              NoteheadPosition.right,
              NoteheadPosition.left,
              NoteheadPosition.right,
            ],
          );

          String notesDescription = testCase.notes
              .map((note) => "${note.form.step}${note.form.octave}")
              .join(", ");
          notesDescription = "($notesDescription)";

          var result = Adjacency.determineNoteheadPositions(
            testCase.notes,
            testCase.stemDirection,
          );
          expect(result, orderedEquals(testCase.expected));
        },
      );

      test(
        "Adjacent notes in multiple groups #1 (A4, B4, F5, G5)",
        () {
          final testCase = (
            notes: [
              RegularNote(form: Pitch(step: Step.A, octave: 4), duration: 0),
              RegularNote(form: Pitch(step: Step.B, octave: 4), duration: 0),
              RegularNote(form: Pitch(step: Step.F, octave: 5), duration: 0),
              RegularNote(form: Pitch(step: Step.G, octave: 5), duration: 0),
            ],
            stemDirection: StemDirection.down,
            expected: [
              NoteheadPosition.left,
              NoteheadPosition.right,
              NoteheadPosition.left,
              NoteheadPosition.right,
            ],
          );

          String notesDescription = testCase.notes
              .map((note) => "${note.form.step}${note.form.octave}")
              .join(", ");
          notesDescription = "($notesDescription)";

          var result = Adjacency.determineNoteheadPositions(
            testCase.notes,
            testCase.stemDirection,
          );
          expect(result, orderedEquals(testCase.expected));
        },
      );
      test(
        "Adjacent notes in multiple groups #1 (G4, A4, C5, D5)",
        () {
          final testCase = (
            notes: [
              RegularNote(form: Pitch(step: Step.G, octave: 4), duration: 0),
              RegularNote(form: Pitch(step: Step.A, octave: 4), duration: 0),
              RegularNote(form: Pitch(step: Step.C, octave: 5), duration: 0),
              RegularNote(form: Pitch(step: Step.D, octave: 5), duration: 0),
            ],
            stemDirection: StemDirection.up,
            expected: [
              NoteheadPosition.left,
              NoteheadPosition.right,
              NoteheadPosition.left,
              NoteheadPosition.right,
            ],
          );

          String notesDescription = testCase.notes
              .map((note) => "${note.form.step}${note.form.octave}")
              .join(", ");
          notesDescription = "($notesDescription)";

          var result = Adjacency.determineNoteheadPositions(
            testCase.notes,
            testCase.stemDirection,
          );
          expect(result, orderedEquals(testCase.expected));
        },
      );
      test(
        "Adjacent notes in multiple groups #3 (E4, G4, A5)",
        () {
          final testCase = (
            notes: [
              RegularNote(form: Pitch(step: Step.E, octave: 4), duration: 0),
              RegularNote(form: Pitch(step: Step.G, octave: 4), duration: 0),
              RegularNote(form: Pitch(step: Step.A, octave: 4), duration: 0),
            ],
            stemDirection: StemDirection.up,
            expected: [
              NoteheadPosition.left,
              NoteheadPosition.left,
              NoteheadPosition.right,
            ],
          );

          String notesDescription = testCase.notes
              .map((note) => "${note.form.step}${note.form.octave}")
              .join(", ");
          notesDescription = "($notesDescription)";

          var result = Adjacency.determineNoteheadPositions(
            testCase.notes,
            testCase.stemDirection,
          );
          expect(result, orderedEquals(testCase.expected));
        },
      );
    },
  );
}
