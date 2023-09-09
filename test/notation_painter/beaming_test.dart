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
      (part: 0, measure: 1, staff: null, beamings: [-1, -1, -1]),
      (part: 0, measure: 2, staff: null, beamings: [-1, 0, 0, 0, 1, 1, 1]),
      (part: 0, measure: 3, staff: null, beamings: [-1, -1]),
      (part: 1, measure: 0, staff: 1, beamings: [0, 0, 0, 0, 0, 0]),
      (part: 1, measure: 1, staff: 1, beamings: [0, 0, 0, 0, 0, 0]),
      (part: 1, measure: 2, staff: 1, beamings: [0, 0, 0, 0, 0, 0]),
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
              .where((element) => element.staff == testCase.staff)
              .toList(),
          timeSignature: TimeSignature(beats: "3", beatType: "4"),
          divisions: 24,
        );
        final bool equal = const ListEquality().equals(
          groupings,
          testCase.beamings,
        );
        if (!equal) {
          // ignore: avoid_print
          print("expected ${testCase.beamings} \nresults  $groupings");
        }
        expect(equal, true);
      });
    }
  });
}
