import 'package:music_notation/src/models/elements/score/part_group.dart';
import 'package:music_notation/src/models/elements/score/part_list.dart';
import 'package:music_notation/src/models/elements/score/score_part.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('Part list parsing', () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/concert-score-and-for-part-elements/
    test(
        'Should parse part list from <concert-score> and <for-part> example correctly',
        () {
      String input = '''
        <part-list>
            <part-group number="1" type="start">
              <group-symbol default-x="-5">bracket</group-symbol>
              <group-barline>yes</group-barline>
            </part-group>
            <score-part id="P1">
              <part-name>Piccolo</part-name>
              <group>score</group>
            </score-part>
            <score-part id="P2">
              <part-name>Oboe</part-name>
              <group>score</group>
            </score-part>
            <score-part id="P3">
              <part-name>Bass Clarinet</part-name>
              <group>score</group>
            </score-part>
            <part-group number="1" type="stop"/>
        </part-list>
      ''';

      var partList = PartList.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(partList.partGroups.length, 1);
      expect(partList.additionalParts.length, 3);
      expect(partList.additionalParts.whereType<ScorePart>().length, 2);
      expect(partList.additionalParts.whereType<PartGroup>().length, 1);
    });

    test('Should throw exception if "score-part" element is missing', () {
      String input = '''
        <part-list>
            <part-group number="1" type="start">
              <group-symbol default-x="-5">bracket</group-symbol>
              <group-barline>yes</group-barline>
            </part-group>
            <part-group number="1" type="stop"/>
        </part-list>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      expect(
        () => PartList.fromXml(rootElement),
        throwsA(isA<XmlSequenceException>()),
      );
    });
  });
}
