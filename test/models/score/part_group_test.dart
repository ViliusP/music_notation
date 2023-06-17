import 'package:music_notation/src/models/data_types/start_stop.dart';
import 'package:music_notation/src/models/elements/score/part_group.dart';
import 'package:music_notation/src/models/elements/score/part_list.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('GroupName parsing', () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/group-abbreviation-display-element/
    test(
        'Should parse GroupName from <group-abbreviation-display> example correctly',
        () {
      String input = '''
        <group-name>Trumpet in B flat</group-name>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      // ignore: deprecated_member_use_from_same_package
      var partGroup = GroupName.fromXml(rootElement);

      expect(partGroup.value, "Trumpet in B flat");
      expect(partGroup.justify, isNull);
    });
    test('Should throw error when justify is wrong type', () {
      String input = '''
        <group-name justify="wrong_type">Trumpet in B flat</group-name>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      expect(
        // ignore: deprecated_member_use_from_same_package
        () => GroupName.fromXml(rootElement),
        throwsA(isA<InvalidMusicXmlType>()),
      );
    });
    test('Should throw error when content is something other than text', () {
      String input = '''
        <group-name>
          <something>
            text
          </something>
        </group-name>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      expect(
        // ignore: deprecated_member_use_from_same_package
        () => GroupName.fromXml(rootElement),
        throwsA(isA<InvalidXmlElementException>()),
      );
    });
  });
}
