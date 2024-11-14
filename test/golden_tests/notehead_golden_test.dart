import 'dart:convert';
import 'dart:io';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/notation_painter/notes/simple_note_element.dart';
import 'package:music_notation/src/smufl/font_metadata.dart';

import '../test_path.dart';

void main() {
  final file = File(testPath('/test_resources/font/leland_metadata.json'));
  final json = jsonDecode(file.readAsStringSync());
  FontMetadata font = FontMetadata.fromJson(json);
  group('Notehead elements test', () {
    goldenTest(
      'renders correctly',
      fileName: 'notehead_elements',
      builder: () => GoldenTestGroup(
          columnWidthBuilder: (columns) => null,
          columns: 3,
          children: [
            ...[
              NoteTypeValue.whole,
              NoteTypeValue.half,
              NoteTypeValue.quarter,
              NoteTypeValue.eighth,
              NoteTypeValue.n16th,
              NoteTypeValue.n32nd
            ].map((v) => Padding(
                  padding: EdgeInsets.all(5),
                  child: ColoredBox(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    child: NoteheadElement(
                      type: v,
                      font: font,
                    ),
                  ),
                ))
          ]),
    );
  });
}
