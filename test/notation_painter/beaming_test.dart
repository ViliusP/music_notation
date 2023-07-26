import 'dart:io';

import 'package:collection/collection.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/time.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/score/score.dart';
import 'package:music_notation/src/notation_painter/beaming.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

import '../test_path.dart';

void main() {
  group("Après un rêve beamings", () {
    var testCases = [
      (measure: 1, part: 0, beamings: [-1, -1, -1]),
      (measure: 2, part: 0, beamings: [-1, 0, 0, 0, 1, 1, 1]),
      (measure: 3, part: 0, beamings: [-1, -1]),
    ];

    final inputFile = File(
      testPath('/test_resources/apres_un_reve.xml'),
    );

    var scorePartwise = ScorePartwise.fromXml(
      XmlDocument.parse(inputFile.readAsStringSync()),
    );

    for (var testCase in testCases) {
      test("Part ${testCase.part} - measure ${testCase.measure}", () {
        var groupings = Beaming.generate(
          notes: scorePartwise
              .parts[testCase.part].measures[testCase.measure].data
              .whereType<Note>()
              .toList(),
          timeSignature: TimeSignature(beats: "3", beatType: "4"),
          divisions: 24,
        );
        final bool equal = const ListEquality().equals(
          groupings,
          testCase.beamings,
        );
        expect(equal, true);
      });
    }
  });
}
