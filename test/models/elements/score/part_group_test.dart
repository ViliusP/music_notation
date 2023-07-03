import 'package:music_notation/src/models/data_types/group_symbol_value.dart';
import 'package:music_notation/src/models/data_types/start_stop.dart';
import 'package:music_notation/src/models/elements/score/part_group.dart';
import 'package:music_notation/src/models/elements/score/part_list.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('Part group parsing', () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/assess-and-player-elements/
    test('Should parse part group from <assess> and <player> example correctly',
        () {
      String input = '''
        <part-group number="1" type="start">
          <group-symbol default-x="-5">bracket</group-symbol>
          <group-barline>yes</group-barline>
        </part-group>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      var partGroup = PartGroup.fromXml(rootElement);

      expect(partGroup.name, isNull);
      expect(partGroup.nameAbbrevation, isNull);
      expect(partGroup.nameDisplay, isNull);
      expect(partGroup.nameDisplayAbbrevation, isNull);
      expect(partGroup.groupSymbol, isNotNull);
      expect(partGroup.groupBarline, isNotNull);
      expect(partGroup.groupTime, isNull);
      expect(partGroup.number, "1");
      expect(partGroup.type, StartStop.start);
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

      expect(
        () => PartList.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlSequenceException>()),
      );
    });
  });

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
        throwsA(isA<MusicXmlFormatException>()),
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

      expect(
        // ignore: deprecated_member_use_from_same_package
        () => GroupName.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
  });

  group('GroupSymbol parsing', () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/group-abbreviation-display-element/
    test(
        'Should parse GroupSymbol from <group-abbreviation-display> example correctly',
        () {
      String input = '''
        <group-symbol default-x="-10">square</group-symbol>
      ''';

      var groupSymbol = GroupSymbol.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(groupSymbol.value, GroupSymbolValue.square);
      expect(groupSymbol.position.defaultX, -10);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/group-barline-element/
    test('Should parse GroupSymbol from <group-barline>example correctly', () {
      String input = '''
        <group-symbol default-x="-5">bracket</group-symbol>
      ''';

      var groupSymbol = GroupSymbol.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(groupSymbol.value, GroupSymbolValue.bracket);
      expect(groupSymbol.position.defaultX, -5);
    });
    test('Should throw error when group-symbol-value is invalid', () {
      String input = '''
        <group-symbol default-x="-5">circle</group-symbol>
      ''';

      expect(
        () => GroupSymbol.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
  });

  group('GroupBarline parsing', () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/group-abbreviation-display-element/
    test(
        'Should parse GroupBarline from <group-abbreviation-display> example correctly',
        () {
      String input = '''
        <group-barline>yes</group-barline>
      ''';

      var groupSymbol = GroupBarline.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(groupSymbol.value, GroupBarlineValue.yes);
      expect(groupSymbol.color.value, null);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/group-barline-element/
    test('Should throw error when group-barline-value is invalid', () {
      String input = '''
        <group-barline>maybe</group-barline>
      ''';

      expect(
        () => GroupBarline.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
  });
}
