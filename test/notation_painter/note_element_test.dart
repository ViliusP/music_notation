import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/notation_painter/models/ledger_lines.dart';
import 'package:music_notation/src/notation_painter/models/notation_context.dart';
import 'package:music_notation/src/notation_painter/notes/note_element.dart';
import 'package:music_notation/src/notation_painter/notes/simple_note_element.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

import '../test_path.dart';

late FontMetadata fontMetadata;

void main() {
  final List<(RegularNote note, LedgerLines? gClef, LedgerLines? fClef)>
      testCases = [
    (
      const RegularNote(form: Pitch(step: Step.G, octave: 3), duration: 1),
      LedgerLines(
          count: 2,
          start: LedgerPlacement.above,
          direction: LedgerDrawingDirection.up),
      null
    ),
    (
      const RegularNote(form: Pitch(step: Step.C, octave: 4), duration: 1),
      LedgerLines(
          count: 1,
          start: LedgerPlacement.center,
          direction: LedgerDrawingDirection.up),
      LedgerLines(
          count: 1,
          start: LedgerPlacement.center,
          direction: LedgerDrawingDirection.down)
    ),
    (
      const RegularNote(
        form: Pitch(step: Step.E, octave: 4, alter: -1),
        duration: 1,
      ),
      null,
      LedgerLines(
          count: 2,
          start: LedgerPlacement.center,
          direction: LedgerDrawingDirection.down)
    ),
    (
      const RegularNote(form: Pitch(step: Step.G, octave: 4), duration: 1),
      null,
      LedgerLines(
          count: 3,
          start: LedgerPlacement.center,
          direction: LedgerDrawingDirection.down)
    ),
    (
      const RegularNote(
        form: Pitch(step: Step.A, octave: 3, alter: -1),
        duration: 1,
      ),
      LedgerLines(
          count: 2,
          start: LedgerPlacement.center,
          direction: LedgerDrawingDirection.up),
      null
    ),
    (
      const RegularNote(form: Pitch(step: Step.F, octave: 1), duration: 1),
      LedgerLines(
          count: 10,
          start: LedgerPlacement.center,
          direction: LedgerDrawingDirection.up),
      LedgerLines(
          count: 4,
          start: LedgerPlacement.center,
          direction: LedgerDrawingDirection.up)
    ),
    (
      const RegularNote(form: Pitch(step: Step.G, octave: 1), duration: 1),
      LedgerLines(
          count: 9,
          start: LedgerPlacement.above,
          direction: LedgerDrawingDirection.up),
      LedgerLines(
          count: 3,
          start: LedgerPlacement.above,
          direction: LedgerDrawingDirection.up)
    ),
    (
      const RegularNote(form: Pitch(step: Step.G, octave: 5), duration: 1),
      null,
      LedgerLines(
          count: 6,
          start: LedgerPlacement.below,
          direction: LedgerDrawingDirection.down)
    ),
    (
      const RegularNote(form: Pitch(step: Step.B, octave: 5), duration: 1),
      LedgerLines(
          count: 1,
          start: LedgerPlacement.below,
          direction: LedgerDrawingDirection.down),
      LedgerLines(
          count: 7,
          start: LedgerPlacement.below,
          direction: LedgerDrawingDirection.down)
    ),
    (
      const RegularNote(form: Pitch(step: Step.C, octave: 6), duration: 1),
      LedgerLines(
          count: 2,
          start: LedgerPlacement.center,
          direction: LedgerDrawingDirection.down),
      LedgerLines(
          count: 8,
          start: LedgerPlacement.center,
          direction: LedgerDrawingDirection.down)
    ),
    (
      const RegularNote(form: Pitch(step: Step.D, octave: 4), duration: 1),
      null,
      LedgerLines(
          count: 1,
          start: LedgerPlacement.below,
          direction: LedgerDrawingDirection.down)
    ),
  ];

  setUpAll(() async {
    final file = File(testPath('/test_resources/font/leland_metadata.json'));
    final json = jsonDecode(await file.readAsString());
    fontMetadata = FontMetadata.fromJson(json);
  });

  group("Ledger lines in clef G", () {
    for (final (note, ledgerLines, _) in testCases) {
      var clef = Clef(sign: ClefSign.G);

      testWidgets(
        "Note ${note.form.step}${note.form.octave} in clef ${clef.sign.name} ledger lines",
        (WidgetTester tester) async {
          Widget widget = NoteElement.fromNote(
            note: note,
            notationContext: NotationContext(
              divisions: 1,
              clef: clef,
              time: null,
              lastKey: null,
            ),
            font: fontMetadata,
          );

          widget = Directionality(
            textDirection: TextDirection.ltr,
            child: widget,
          );

          await tester.pumpWidget(widget);

          final childFinder = find.byType(NoteheadElement);
          expect(childFinder, findsOneWidget);

          final notehead = tester.firstWidget(childFinder) as NoteheadElement;
          expect(notehead.ledgerLines, ledgerLines);
        },
      );
    }
  });

  group("Ledger lines in clef F", () {
    for (final (note, _, ledgerLines) in testCases) {
      var clef = Clef(sign: ClefSign.F);

      testWidgets(
        "Note ${note.form.step}${note.form.octave} in clef ${clef.sign.name} has correct ledger lines",
        (WidgetTester tester) async {
          Widget widget = NoteElement.fromNote(
            note: note,
            notationContext: NotationContext(
              divisions: 1,
              clef: clef,
              time: null,
              lastKey: null,
            ),
            font: fontMetadata,
          );

          widget = Directionality(
            textDirection: TextDirection.ltr,
            child: widget,
          );

          await tester.pumpWidget(widget);

          final childFinder = find.byType(NoteheadElement);
          expect(childFinder, findsOneWidget);

          final notehead = tester.firstWidget(childFinder) as NoteheadElement;
          expect(notehead.ledgerLines, ledgerLines);
        },
      );
    }
  });
}
