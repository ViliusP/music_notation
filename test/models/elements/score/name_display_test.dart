import 'package:music_notation/src/models/elements/score/name_display.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/elements/text/text.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('Name display parsing', () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/group-abbreviation-display-element/
    test(
        'Should parse part group from <group-abbreviation-display> example correctly',
        () {
      String input = '''
        <group-abbreviation-display>
            <display-text>Trp. in B</display-text>
            <accidental-text>flat</accidental-text>
        </group-abbreviation-display>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      var partGroup = NameDisplay.fromXml(rootElement);

      expect(partGroup.texts.length, 2);
      expect(partGroup.printObject, true);
      expect(partGroup.texts[0], isA<FormattedText>());
      expect(partGroup.texts[1], isA<AccidentalText>());
    });

    test('Should throw exception if "print-object" attribute is incorrect', () {
      String input = '''
        <group-abbreviation-display print-object="yes-no">
            <display-text>Trp. in B</display-text>
            <accidental-text>flat</accidental-text>
        </group-abbreviation-display>
      ''';

      expect(
        () => NameDisplay.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
  });
}
