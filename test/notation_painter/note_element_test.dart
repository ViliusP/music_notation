import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/note_element.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

void main() {
  final notes = [
    const RegularNote(
      form: Pitch(step: Step.G, octave: 3),
      duration: 1,
    ),
    const RegularNote(
      form: Pitch(step: Step.C, octave: 4),
      duration: 1,
    ),
    const RegularNote(
      form: Pitch(step: Step.E, octave: 4, alter: -1),
      duration: 1,
    ),
    const RegularNote(
      form: Pitch(step: Step.G, octave: 4),
      duration: 1,
    ),
    const RegularNote(
      form: Pitch(step: Step.A, octave: 3, alter: -1),
      duration: 1,
    ),
    const RegularNote(
      form: Pitch(step: Step.F, octave: 1),
      duration: 1,
    ),
    const RegularNote(
      form: Pitch(step: Step.G, octave: 1),
      duration: 1,
    ),
    const RegularNote(
      form: Pitch(step: Step.G, octave: 5),
      duration: 1,
    ),
    const RegularNote(
      form: Pitch(step: Step.B, octave: 5),
      duration: 1,
    ),
    const RegularNote(
      form: Pitch(step: Step.C, octave: 6),
      duration: 1,
    ),
    const RegularNote(
      form: Pitch(step: Step.D, octave: 4),
      duration: 1,
    ),
  ];

  group("Ledger lines passed to notehead in clef G", () {
    final expected = [
      LedgerLines(
        count: 2,
        placement: LedgerPlacement.below,
        extendsThroughNote: false,
      ), // G3
      LedgerLines(
        count: 1,
        placement: LedgerPlacement.below,
        extendsThroughNote: true,
      ), // C4
      null, // E4
      null, // G4
      LedgerLines(
        count: 2,
        placement: LedgerPlacement.below,
        extendsThroughNote: true,
      ), // A3
      LedgerLines(
        count: 10,
        placement: LedgerPlacement.below,
        extendsThroughNote: true,
      ), // F1
      LedgerLines(
        count: 9,
        placement: LedgerPlacement.below,
        extendsThroughNote: false,
      ), // G1
      null, // G5
      LedgerLines(
        count: 1,
        placement: LedgerPlacement.above,
        extendsThroughNote: false,
      ), // B5
      LedgerLines(
        count: 2,
        placement: LedgerPlacement.above,
        extendsThroughNote: true,
      ), // C6
      null
    ];

    for (var (index, note) in notes.indexed) {
      final noteName = "${note.form.step}${note.form.octave}";
      final lines = expected[index]?.count ?? 0;

      final belowAbove = switch (expected[index]?.placement) {
        null => "",
        LedgerPlacement.above => "above staff",
        LedgerPlacement.below => "below staff",
      };
      testWidgets("$noteName should have $lines ledger lines $belowAbove",
          (WidgetTester tester) async {
        Widget widget = NoteElement.fromNote(
          note: note,
          notationContext: NotationContext(
            divisions: 1,
            clef: Clef(sign: ClefSign.G),
            time: null,
            lastKey: null,
          ),
          font: FontMetadata.empty(),
        );

        widget = Directionality(
          textDirection: TextDirection.ltr,
          child: widget,
        );

        await tester.pumpWidget(widget);

        final childFinder = find.byType(NoteheadElement);

        expect(childFinder, findsOneWidget);

        final notehead = tester.firstWidget(childFinder) as NoteheadElement;
        expect(notehead.ledgerLines, expected[index]);
      });
    }
  });
  group("Ledger lines passed to notehead in clef F", () {
    final expected = [
      null, // G3
      LedgerLines(
        count: 1,
        placement: LedgerPlacement.above,
        extendsThroughNote: true,
      ), // C4
      LedgerLines(
        count: 2,
        placement: LedgerPlacement.above,
        extendsThroughNote: true,
      ), // E4
      LedgerLines(
        count: 3,
        placement: LedgerPlacement.above,
        extendsThroughNote: true,
      ), // G4
      null, // A3
      LedgerLines(
        count: 4,
        placement: LedgerPlacement.below,
        extendsThroughNote: true,
      ), // F1
      LedgerLines(
        count: 3,
        placement: LedgerPlacement.below,
        extendsThroughNote: false,
      ), // G1
      LedgerLines(
        count: 6,
        placement: LedgerPlacement.above,
        extendsThroughNote: false,
      ), // G5
      LedgerLines(
        count: 7,
        placement: LedgerPlacement.above,
        extendsThroughNote: false,
      ), // B5
      LedgerLines(
        count: 8,
        placement: LedgerPlacement.above,
        extendsThroughNote: true,
      ), // C6
      LedgerLines(
        count: 1,
        placement: LedgerPlacement.above,
        extendsThroughNote: false,
      ), // D4
    ];

    for (var (index, note) in notes.indexed) {
      final noteName = "${note.form.step}${note.form.octave}";
      final lines = expected[index]?.count ?? 0;

      final belowAbove = switch (expected[index]?.placement) {
        null => "",
        LedgerPlacement.above => "above staff",
        LedgerPlacement.below => "below staff",
      };
      testWidgets("$noteName should have $lines ledger lines $belowAbove",
          (WidgetTester tester) async {
        Widget widget = NoteElement.fromNote(
          note: note,
          notationContext: NotationContext(
            divisions: 1,
            clef: Clef(sign: ClefSign.F),
            time: null,
            lastKey: null,
          ),
          font: FontMetadata.empty(),
        );

        widget = Directionality(
          textDirection: TextDirection.ltr,
          child: widget,
        );

        await tester.pumpWidget(widget);

        final childFinder = find.byType(NoteheadElement);

        expect(childFinder, findsOneWidget);

        final notehead = tester.firstWidget(childFinder) as NoteheadElement;
        expect(notehead.ledgerLines, expected[index]);
      });
    }
  });
}
