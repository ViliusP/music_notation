// import 'dart:io';

// import 'package:collection/collection.dart';
import 'package:flutter/rendering.dart';
// import 'package:music_notation/src/models/elements/music_data/attributes/time.dart';
import 'package:music_notation/src/models/elements/music_data/note/beam.dart';
// import 'package:music_notation/src/models/elements/music_data/note/note.dart';
// import 'package:music_notation/src/models/elements/score/score.dart';
import 'package:music_notation/src/notation_painter/notes/beaming.dart';
import 'package:test/test.dart';
// import 'package:xml/xml.dart';

// import '../../test_path.dart';

void main() {
  // group("Après un rêve beamings", () {
  //   var testCases = [
  //     (part: 0, measure: 1, staff: null, beamings: [-1, -1, -1]),
  //     (part: 0, measure: 2, staff: null, beamings: [-1, 0, 0, 0, 1, 1, 1]),
  //     (part: 0, measure: 3, staff: null, beamings: [-1, -1]),
  //     (part: 1, measure: 0, staff: 1, beamings: [0, 0, 0, 0, 0, 0]),
  //     (part: 1, measure: 1, staff: 1, beamings: [0, 0, 0, 0, 0, 0]),
  //     (part: 1, measure: 2, staff: 1, beamings: [0, 0, 0, 0, 0, 0]),
  //   ];

  //   final inputFile = File(
  //     testPath('/test_resources/apres_un_reve.xml'),
  //   );

  //   var scorePartwise = ScorePartwise.fromXml(
  //     XmlDocument.parse(inputFile.readAsStringSync()),
  //   );

  //   for (var testCase in testCases) {
  //     test("Part ${testCase.part} - measure ${testCase.measure}", () {
  //       var groupings = Beaming.generate(
  //         notes: scorePartwise
  //             .parts[testCase.part].measures[testCase.measure].data
  //             .whereType<Note>()
  //             .where((element) => element.staff == testCase.staff)
  //             .toList(),
  //         timeSignature: TimeSignature(beats: "3", beatType: "4"),
  //         divisions: 24,
  //       );
  //       final bool equal = const ListEquality().equals(
  //         groupings,
  //         testCase.beamings,
  //       );
  //       if (!equal) {
  //         // ignore: avoid_print
  //         print("expected ${testCase.beamings} \nresults  $groupings");
  //       }
  //       expect(equal, true);
  //     });
  //   }
  // });

  group('BeamGroupData.fromNotesBeams', () {
    test('creates an empty map when input data is empty', () {
      final beamGroupData = BeamGroupData.fromNotesBeams([]);
      expect(beamGroupData.map, isEmpty);
    });

    test('handles a single beam with "full" type', () {
      final data = [
        (
          beams: [Beam(number: 1, value: BeamValue.begin)],
          offset: const Offset(0, 0),
        ),
        (
          beams: [Beam(number: 1, value: BeamValue.end)],
          offset: const Offset(10, 0),
        ),
      ];

      final beamGroupData = BeamGroupData.fromNotesBeams(data);

      expect(beamGroupData.map, isNotEmpty);
      expect(beamGroupData.map[1], isNotNull);
      expect(beamGroupData.map[1]!.length, 1);

      final beamData = beamGroupData.map[1]!.first;
      expect(beamData.type, BeamType.full);
      expect(beamData.start, const Offset(0, 0));
      expect(beamData.end, const Offset(10, 0));
    });

    test('handles a single beam with "full" type with improper list of beams',
        () {
      final data = [
        (
          beams: [
            Beam(number: 1, value: BeamValue.begin),
            Beam(number: 1, value: BeamValue.end),
          ],
          offset: const Offset(0, 0),
        ),
        (
          beams: [
            Beam(number: 1, value: BeamValue.end),
          ],
          offset: const Offset(10, 0),
        ),
      ];

      final beamGroupData = BeamGroupData.fromNotesBeams(data);

      expect(beamGroupData.map, isNotEmpty);
      expect(beamGroupData.map[1], isNotNull);
      expect(beamGroupData.map[1]!.length, 1);

      final beamData = beamGroupData.map[1]!.first;
      expect(beamData.type, BeamType.full);
      expect(beamData.start, const Offset(0, 0));
      expect(beamData.end, const Offset(10, 0));
    });

    test('handles one note with forward hook beam', () {
      final data = [
        (
          beams: [
            Beam(number: 2, value: BeamValue.forwardHook),
          ],
          offset: const Offset(0, 0),
        ),
      ];

      final beamGroupData = BeamGroupData.fromNotesBeams(data);

      expect(beamGroupData.map, isEmpty);
    });

    test('handles one note with multiple forward hook beam', () {
      final data = [
        (
          beams: [
            Beam(number: 1, value: BeamValue.forwardHook),
            Beam(number: 2, value: BeamValue.forwardHook),
          ],
          offset: const Offset(0, 0),
        ),
      ];

      final beamGroupData = BeamGroupData.fromNotesBeams(data);

      expect(beamGroupData.map, isEmpty);
    });

    test(
        'handles multiple notes with multiple forward hook beam at start and end',
        () {
      final data = [
        (
          beams: [
            Beam(number: 1, value: BeamValue.forwardHook),
            Beam(number: 2, value: BeamValue.forwardHook),
          ],
          offset: const Offset(0, 0),
        ),
        (
          beams: [
            Beam(number: 1, value: BeamValue.forwardHook),
            Beam(number: 2, value: BeamValue.forwardHook),
          ],
          offset: const Offset(10, 10),
        ),
      ];

      final beamGroupData = BeamGroupData.fromNotesBeams(data);

      expect(beamGroupData.map.length, 2);

      // Validate Beam 1
      expect(beamGroupData.map[1]!.length, 1);
      final beam1 = beamGroupData.map[1]!.first;
      expect(beam1.type, BeamType.forwardHook);
      expect(beam1.start, const Offset(0, 0));
      expect(beam1.end, const Offset(10, 10));

      // Validate Beam 2
      expect(beamGroupData.map[2]!.length, 1);
      final beam2 = beamGroupData.map[2]!.first;
      expect(beam2.type, BeamType.forwardHook);
      expect(beam2.start, const Offset(0, 0));
      expect(beam2.end, const Offset(10, 10));
    });

    test('handles multiple levels of beams', () {
      final data = [
        (
          beams: [
            Beam(number: 1, value: BeamValue.begin),
            Beam(number: 2, value: BeamValue.begin),
          ],
          offset: const Offset(0, 0),
        ),
        (
          beams: [
            Beam(number: 1, value: BeamValue.end),
          ],
          offset: const Offset(10, 0),
        ),
        (
          beams: [
            Beam(number: 2, value: BeamValue.end),
          ],
          offset: const Offset(20, 0),
        ),
      ];

      final beamGroupData = BeamGroupData.fromNotesBeams(data);

      expect(beamGroupData.map.keys, containsAll([1, 2]));

      // Validate Beam 1
      expect(beamGroupData.map[1]!.length, 1);
      final beam1 = beamGroupData.map[1]!.first;
      expect(beam1.type, BeamType.full);
      expect(beam1.start, const Offset(0, 0));
      expect(beam1.end, const Offset(10, 0));

      // Validate Beam 2
      expect(beamGroupData.map[2]!.length, 1);
      final beam2 = beamGroupData.map[2]!.first;
      expect(beam2.type, BeamType.full);
      expect(beam2.start, const Offset(0, 0));
      expect(beam2.end, const Offset(20, 0));
    });

    test('handles an empty beam list in NoteBeamData', () {
      final data = [
        (beams: <Beam>[], offset: const Offset(0, 0)),
      ];

      final beamGroupData = BeamGroupData.fromNotesBeams(data);

      expect(beamGroupData.map, isEmpty);
    });

    test('handles single note with backward hook beam', () {
      final data = [
        (
          beams: [
            Beam(number: 3, value: BeamValue.backwardHook),
          ],
          offset: const Offset(0, 0),
        ),
      ];

      final beamGroupData = BeamGroupData.fromNotesBeams(data);

      expect(beamGroupData.map, isEmpty);
    });

    test('handles multiple notes with backward hook beam (one at start)', () {
      final data = [
        (
          beams: [
            Beam(number: 3, value: BeamValue.backwardHook),
          ],
          offset: const Offset(0, 0),
        ),
        (
          beams: [
            Beam(number: 3, value: BeamValue.backwardHook),
          ],
          offset: const Offset(10, 0),
        ),
      ];

      final beamGroupData = BeamGroupData.fromNotesBeams(data);

      expect(beamGroupData.map, isNotEmpty);
      expect(beamGroupData.map[3], isNotNull);
      expect(beamGroupData.map[3]!.length, 1);

      final beamData = beamGroupData.map[3]!.first;
      expect(beamData.type, BeamType.backwardHook);
      expect(beamData.start, const Offset(0, 0));
      expect(beamData.end, const Offset(10, 0));
    });

    test('Handles complex case', () {
      final data = [
        (
          beams: <Beam>[
            Beam(number: 1, value: BeamValue.begin),
            Beam(number: 2, value: BeamValue.begin),
            Beam(number: 3, value: BeamValue.begin),
            Beam(number: 4, value: BeamValue.begin),
            Beam(number: 5, value: BeamValue.begin),
            // 6
            Beam(number: 7, value: BeamValue.backwardHook),
            Beam(number: 8, value: BeamValue.forwardHook),
          ],
          offset: const Offset(0, 0),
        ),
        (
          beams: <Beam>[
            // 1
            // 2
            // 3
            Beam(number: 4, value: BeamValue.end),
            // 5
            Beam(number: 6, value: BeamValue.begin),
            Beam(number: 7, value: BeamValue.backwardHook),
            // 8
          ],
          offset: const Offset(1, 1),
        ),
        (
          beams: <Beam>[
            // 1
            // 2
            // 3
            // 4
            Beam(number: 5, value: BeamValue.end),
            Beam(number: 6, value: BeamValue.end),
            // 7
            Beam(number: 8, value: BeamValue.forwardHook),
          ],
          offset: const Offset(2, 2),
        ),
        (
          beams: <Beam>[
            // 1
            // 2
            // 3
            Beam(number: 4, value: BeamValue.begin),
            // 5
            // 6
            Beam(number: 7, value: BeamValue.backwardHook),
            // 8
          ],
          offset: const Offset(3, 3),
        ),
        (
          beams: <Beam>[
            Beam(number: 1, value: BeamValue.end),
            // 2
            Beam(number: 3, value: BeamValue.begin),
            Beam(number: 4, value: BeamValue.end),
            Beam(number: 5, value: BeamValue.backwardHook),
            Beam(number: 6, value: BeamValue.forwardHook),
            Beam(number: 7, value: BeamValue.backwardHook),
            Beam(number: 8, value: BeamValue.forwardHook),
          ],
          offset: const Offset(4, 4),
        ),
      ];

      final beamGroupData = BeamGroupData.fromNotesBeams(data);

      expect(beamGroupData.map, isNotEmpty);

      // 1st Level
      expect(beamGroupData.map[1], isNotNull);
      expect(beamGroupData.map[1]!.length, 1);
      final firstBeamL1 = beamGroupData.map[1]!.first;
      expect(firstBeamL1.type, BeamType.full);
      expect(firstBeamL1.start, const Offset(0, 0));
      expect(firstBeamL1.end, const Offset(4, 4));

      // 2nd level
      expect(beamGroupData.map[2], isNull);

      // 3rd level
      expect(beamGroupData.map[3], isNull);

      // 4th level
      expect(beamGroupData.map[4], isNotNull);
      expect(beamGroupData.map[4]!.length, 2);
      final firstBeamL4 = beamGroupData.map[4]!.first;
      expect(firstBeamL4.type, BeamType.full);
      expect(firstBeamL4.start, const Offset(0, 0));
      expect(firstBeamL4.end, const Offset(1, 1));

      final secondBeamL4 = beamGroupData.map[4]![1];
      expect(secondBeamL4.type, BeamType.full);
      expect(secondBeamL4.start, const Offset(3, 3));
      expect(secondBeamL4.end, const Offset(4, 4));

      // 5th level
      expect(beamGroupData.map[5], isNotNull);
      expect(beamGroupData.map[5]!.length, 2);
      final firstBeamL5 = beamGroupData.map[5]!.first;
      expect(firstBeamL5.type, BeamType.full);
      expect(firstBeamL5.start, const Offset(0, 0));
      expect(firstBeamL5.end, const Offset(2, 2));

      final secondBeamL5 = beamGroupData.map[5]![1];
      expect(secondBeamL5.type, BeamType.backwardHook);
      expect(secondBeamL5.start, const Offset(3, 3));
      expect(secondBeamL5.end, const Offset(4, 4));

      // 6th level
      expect(beamGroupData.map[6], isNotNull);
      expect(beamGroupData.map[6]!.length, 1);
      final firstBeamL6 = beamGroupData.map[6]!.first;
      expect(firstBeamL6.type, BeamType.full);
      expect(firstBeamL6.start, const Offset(1, 1));
      expect(firstBeamL6.end, const Offset(2, 2));

      // 7th level
      expect(beamGroupData.map[7], isNotNull);
      expect(beamGroupData.map[7]!.length, 3);
      final firstBeamL7 = beamGroupData.map[7]!.first;
      expect(firstBeamL7.type, BeamType.backwardHook);
      expect(firstBeamL7.start, const Offset(0, 0));
      expect(firstBeamL7.end, const Offset(1, 1));

      final secondBeamL7 = beamGroupData.map[7]![1];
      expect(secondBeamL7.type, BeamType.backwardHook);
      expect(secondBeamL7.start, const Offset(2, 2));
      expect(secondBeamL7.end, const Offset(3, 3));

      final thirdBeamL7 = beamGroupData.map[7]![2];
      expect(thirdBeamL7.type, BeamType.backwardHook);
      expect(thirdBeamL7.start, const Offset(3, 3));
      expect(thirdBeamL7.end, const Offset(4, 4));

      // 8th level
      expect(beamGroupData.map[8], isNotNull);
      expect(beamGroupData.map[8]!.length, 2);
      final firstBeamL8 = beamGroupData.map[8]!.first;
      expect(firstBeamL8.type, BeamType.forwardHook);
      expect(firstBeamL8.start, const Offset(0, 0));
      expect(firstBeamL8.end, const Offset(1, 1));

      final secondBeamL8 = beamGroupData.map[8]![1];
      expect(secondBeamL8.type, BeamType.forwardHook);
      expect(secondBeamL8.start, const Offset(2, 2));
      expect(secondBeamL8.end, const Offset(3, 3));
    });
  });
}
