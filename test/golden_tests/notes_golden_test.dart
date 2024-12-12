import 'dart:convert';
import 'dart:io';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';
import 'package:music_notation/src/notation_painter/models/ledger_lines.dart';
import 'package:music_notation/src/notation_painter/notes/note_element.dart';
import 'package:music_notation/src/notation_painter/notes/note_parts.dart';
import 'package:music_notation/src/notation_painter/notes/stemming.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

import '../combinations_generation.dart';
import '../test_path.dart';

void main() {
  late FontMetadata font;

  setUpAll(() async {
    final file = File(testPath('/test_resources/font/leland_metadata.json'));
    final json = jsonDecode(await file.readAsString());
    font = FontMetadata.fromJson(json);
  });

  group('Notehead elements test', () {
    goldenTest(
      'only noteheads renders correctly',
      fileName: 'notehead_elements',
      builder: () => GoldenTestGroup(
          columnWidthBuilder: (columns) => null,
          columns: 3,
          children: [
            ...[
              NoteTypeValue.breve,
              NoteTypeValue.whole,
              NoteTypeValue.half,
              NoteTypeValue.quarter,
              NoteTypeValue.eighth,
              NoteTypeValue.n16th,
            ].map((v) => Center(
                  child: Padding(
                    padding: EdgeInsets.all(3),
                    child: ColoredBox(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      child: NoteheadElement(type: v, font: font),
                    ),
                  ),
                ))
          ]),
    );
    goldenTest(
      'noteheads with ledger lines renders correctly',
      fileName: 'notehead_elements_with_ledgers',
      builder: () {
        Widget testNotehead({
          required NoteTypeValue type,
          required LedgerLines ledgerLines,
        }) {
          double topPadding = 0;
          double bottomPadding = 0;

          double padding = (ledgerLines.count - 1).clamp(0, 20) * 12;

          padding = padding.ceilToDouble() + 1;

          if (ledgerLines.direction == LedgerDrawingDirection.down) {
            bottomPadding = padding;
          }

          if (ledgerLines.direction == LedgerDrawingDirection.up) {
            topPadding = padding;
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: ColoredBox(
                color: Color.fromRGBO(255, 255, 255, 1),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: topPadding,
                    left: 5,
                    right: 5,
                    bottom: bottomPadding,
                  ),
                  child: NoteheadElement(
                    type: type,
                    font: font,
                    ledgerLines: ledgerLines,
                  ),
                ),
              ),
            ),
          );
        }

        var cases = [
          LedgerLines(
            count: 1,
            start: LedgerPlacement.center,
            direction: LedgerDrawingDirection.up,
          ),
          LedgerLines(
            count: 1,
            start: LedgerPlacement.above,
            direction: LedgerDrawingDirection.up,
          ),
          LedgerLines(
            count: 1,
            start: LedgerPlacement.center,
            direction: LedgerDrawingDirection.down,
          ),
          LedgerLines(
            count: 2,
            start: LedgerPlacement.center,
            direction: LedgerDrawingDirection.up,
          ),
          LedgerLines(
            count: 2,
            start: LedgerPlacement.above,
            direction: LedgerDrawingDirection.up,
          ),
          LedgerLines(
            count: 2,
            start: LedgerPlacement.center,
            direction: LedgerDrawingDirection.down,
          ),
          LedgerLines(
            count: 3,
            start: LedgerPlacement.center,
            direction: LedgerDrawingDirection.up,
          ),
          LedgerLines(
            count: 3,
            start: LedgerPlacement.above,
            direction: LedgerDrawingDirection.up,
          ),
          LedgerLines(
            count: 3,
            start: LedgerPlacement.center,
            direction: LedgerDrawingDirection.down,
          ),
        ];

        const noteheads = [
          NoteTypeValue.half,
          NoteTypeValue.whole,
          NoteTypeValue.half,
        ];

        var children = cases.expand((e) sync* {
          for (var notehead in noteheads) {
            yield testNotehead(
              type: notehead,
              ledgerLines: e,
            );
          }
        });

        return GoldenTestGroup(
          columnWidthBuilder: (columns) => null,
          columns: 9,
          children: children.toList(),
        );
      },
    );
  });

  group('Simple note rendering test', () {
    goldenTest(
      'only noteheads renders correctly',
      fileName: 'notehead_elements',
      builder: () => GoldenTestGroup(
          columnWidthBuilder: (columns) => null,
          columns: 3,
          children: [
            ...[
              NoteTypeValue.breve,
              NoteTypeValue.whole,
              NoteTypeValue.half,
              NoteTypeValue.quarter,
              NoteTypeValue.eighth,
              NoteTypeValue.n16th,
            ].map((v) => Center(
                  child: Padding(
                    padding: EdgeInsets.all(3),
                    child: ColoredBox(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      child: NoteheadElement(type: v, font: font),
                    ),
                  ),
                ))
          ]),
    );
    goldenTest(
      'Simple notes',
      fileName: 'simple_notes',
      builder: () {
        Widget goldenNote({
          required NoteTypeValue type,
          required StemDirection stemDirection,
          required double stemLength,
          required LedgerLines? ledgerLines,
        }) {
          NoteheadElement notehead = NoteheadElement(
            type: type,
            font: font,
            ledgerLines: ledgerLines,
          );
          StemElement stem = StemElement(
            type: type,
            font: font,
            length: stemLength,
            direction: stemDirection,
          );

          NoteElement note = NoteElement(
            base: StemlessNoteElement(
              head: notehead,
              position: ElementPosition.staffMiddle,
            ),
            stem: stem,
          );

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2),
              child: ColoredBox(
                color: Color.fromRGBO(255, 255, 255, 1),
                child: note,
              ),
            ),
          );
        }

        var types = [
          NoteTypeValue.half,
          NoteTypeValue.quarter,
          NoteTypeValue.eighth,
          NoteTypeValue.n16th,
        ];

        var directions = [StemDirection.down, StemDirection.up];

        var lengths = [0.0, 3.5, 5];

        var ledgerLines = [
          null,
          LedgerLines(
            count: 1,
            start: LedgerPlacement.center,
            direction: LedgerDrawingDirection.up,
          ),
        ];

        // Generate combinations of all parameters
        var combinations = generateCombinations([
          ledgerLines,
          lengths,
          types,
          directions,
        ]);

        // Map combinations to widgets
        var widgets = combinations.map((combination) {
          return goldenNote(
            type: combination[2] as NoteTypeValue,
            stemDirection: combination[3] as StemDirection,
            stemLength: combination[1] as double,
            ledgerLines: combination[0] as LedgerLines?,
          );
        }).toList();

        return GoldenTestGroup(
          columns: 8,
          children: widgets,
        );
      },
    );
  });
}
