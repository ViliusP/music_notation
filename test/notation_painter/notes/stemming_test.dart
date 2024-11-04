import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:test/test.dart';

void main() {
  group(
    "Chord stem direction | two notes without surrounding notes",
    () {
      var testCases = [
        (
          name:
              "First note (below middle line) is the furthest from the staff middle",
          notes: [
            RegularNote(form: Pitch(step: Step.G, octave: 4), duration: 0),
            RegularNote(form: Pitch(step: Step.C, octave: 5), duration: 0),
          ],
          direction: StemDirection.up,
        ),
        (
          name:
              "Second note (above middle line) is the furthest from the staff middle",
          notes: [
            RegularNote(form: Pitch(step: Step.A, octave: 4), duration: 0),
            RegularNote(form: Pitch(step: Step.D, octave: 5), duration: 0),
          ],
          direction: StemDirection.down,
        ),
        (
          name:
              "First note (below the middle line) is the furthest from the staff middle #2",
          notes: [
            RegularNote(form: Pitch(step: Step.E, octave: 4), duration: 0),
            RegularNote(form: Pitch(step: Step.E, octave: 5), duration: 0),
          ],
          direction: StemDirection.up,
        ),
        (
          name:
              "Second note (above the middle line) is the furthest from the staff middle #2",
          notes: [
            RegularNote(form: Pitch(step: Step.F, octave: 4), duration: 0),
            RegularNote(form: Pitch(step: Step.F, octave: 5), duration: 0),
          ],
          direction: StemDirection.down,
        ),
        (
          name: "Both notes are below the middle line",
          notes: [
            RegularNote(form: Pitch(step: Step.C, octave: 4), duration: 0),
            RegularNote(form: Pitch(step: Step.E, octave: 4), duration: 0),
          ],
          direction: StemDirection.up,
        ),
        (
          name: "Both notes are above the middle line",
          notes: [
            RegularNote(form: Pitch(step: Step.F, octave: 5), duration: 0),
            RegularNote(form: Pitch(step: Step.B, octave: 5), duration: 0),
          ],
          direction: StemDirection.up,
        ),
        (
          name:
              "Both notes are equidistant from the middle, stem goes to the default direction (down)",
          notes: [
            RegularNote(form: Pitch(step: Step.A, octave: 4), duration: 0),
            RegularNote(form: Pitch(step: Step.C, octave: 5), duration: 0),
          ],
          direction: StemDirection.down,
        ),
        (
          name:
              "Both notes are equidistant from the middle, stem goes to the default direction (down)",
          notes: [
            RegularNote(form: Pitch(step: Step.A, octave: 3), duration: 0),
            RegularNote(form: Pitch(step: Step.C, octave: 6), duration: 0),
          ],
          direction: StemDirection.down,
        ),
      ];

      // Iterate through each test case and execute the test
      for (var testCase in testCases) {
        String notesDescription = testCase.notes
            .map((note) => "${note.form.step}${note.form.octave}")
            .join(", ");
        notesDescription = "($notesDescription)";

        test("${testCase.name} $notesDescription", () {
          var result = Stemming.determineChordStem(testCase.notes);
          expect(result, testCase.direction);
        });
      }
    },
  );

  group(
    "Chord stem direction | multiple notes without surrounding notes",
    () {
      var testCases = [
        (
          name:
              "Last (above middle line) is the furthest from the staff middle",
          notes: [
            RegularNote(form: Pitch(step: Step.D, octave: 4), duration: 0),
            RegularNote(form: Pitch(step: Step.F, octave: 4), duration: 0),
            RegularNote(form: Pitch(step: Step.A, octave: 4), duration: 0),
            RegularNote(form: Pitch(step: Step.A, octave: 5), duration: 0),
          ],
          direction: StemDirection.up,
        ),
        (
          name:
              "first (below middle line) is the furthest from the staff middle",
          notes: [
            RegularNote(form: Pitch(step: Step.D, octave: 4), duration: 0),
            RegularNote(form: Pitch(step: Step.C, octave: 5), duration: 0),
            RegularNote(form: Pitch(step: Step.E, octave: 5), duration: 0),
          ],
          direction: StemDirection.down,
        ),
        (
          name:
              "Outer notes equidistant from the middle, majority is above middle line",
          notes: [
            RegularNote(form: Pitch(step: Step.D, octave: 4), duration: 0),
            RegularNote(form: Pitch(step: Step.B, octave: 4), duration: 0),
            RegularNote(form: Pitch(step: Step.D, octave: 5), duration: 0),
            RegularNote(form: Pitch(step: Step.G, octave: 5), duration: 0),
          ],
          direction: StemDirection.down,
        ),
        (
          name:
              "Outer notes equidistant from the middle, majority is below middle line",
          notes: [
            RegularNote(form: Pitch(step: Step.C, octave: 4), duration: 0),
            RegularNote(form: Pitch(step: Step.E, octave: 4), duration: 0),
            RegularNote(form: Pitch(step: Step.A, octave: 4), duration: 0),
          ],
          direction: StemDirection.up,
        ),
        (
          name:
              "All notes equidistant from the middle, stem goes to default direction (down)",
          notes: [
            RegularNote(form: Pitch(step: Step.F, octave: 4), duration: 0),
            RegularNote(form: Pitch(step: Step.A, octave: 4), duration: 0),
            RegularNote(form: Pitch(step: Step.C, octave: 5), duration: 0),
            RegularNote(form: Pitch(step: Step.E, octave: 5), duration: 0),
          ],
          direction: StemDirection.down,
        ),
        (
          name:
              "All notes equidistant from the middle, stem goes to default direction (down)",
          notes: [
            RegularNote(form: Pitch(step: Step.C, octave: 4), duration: 0),
            RegularNote(form: Pitch(step: Step.G, octave: 4), duration: 0),
            RegularNote(form: Pitch(step: Step.D, octave: 5), duration: 0),
            RegularNote(form: Pitch(step: Step.A, octave: 5), duration: 0),
          ],
          direction: StemDirection.down,
        ),
      ];

      // Iterate through each test case and execute the test
      for (var testCase in testCases) {
        String notesDescription = testCase.notes
            .map((note) => "${note.form.step}${note.form.octave}")
            .join(", ");
        notesDescription = "($notesDescription)";

        test("${testCase.name} $notesDescription", () {
          var result = Stemming.determineChordStem(testCase.notes);
          expect(result, testCase.direction);
        });
      }
    },
  );
}
