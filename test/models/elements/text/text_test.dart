import 'package:music_notation/src/models/data_types/accidental_value.dart';
import 'package:music_notation/src/models/elements/text/text.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/generic.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('FormattedText', () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/part-abbreviation-display-element/
    test(
        'Should parse display-text from <part-abbreviation-display> example correctly',
        () {
      String input = '''
        <display-text>Trp. in B</display-text>
      ''';

      var displayText = FormattedText.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(displayText.value, "Trp. in B");
      expect(displayText.formatting.enclosure, null);
      expect(displayText.formatting.justify, null);
      expect(displayText.formatting.lang, null);
      expect(displayText.formatting.letterSpacing, null);
      expect(displayText.formatting.space, null);
      expect(displayText.formatting.textDirection, null);
      expect(displayText.formatting.textRotation, null);
    });

    test('Shoud correctly parse all attributes of display text', () {
      String input = '''
        <display-text 
          enclosure="oval" 
          justify="center" 
          xml:lang="lt" 
          letter-spacing="1.1"
          xml:space="preserve"
          rotation="150"
          dir="rtl"
          >text text</display-text>
      ''';

      var displayText = FormattedText.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(displayText.value, "text text");
      expect(displayText.formatting.enclosure, EnclosureShape.oval);
      expect(displayText.formatting.justify, HorizontalAlignment.center);
      expect(displayText.formatting.lang, "lt");
      expect(displayText.formatting.letterSpacing, 1.1);
      expect(displayText.formatting.space, XmlSpace.preserve);
      expect(displayText.formatting.textDirection, TextDirection.rtl);
      expect(displayText.formatting.textRotation, 150);
    });

    test('Should throw expcetion when content is empty', () {
      String input = '''
        <display-text></display-text>
      ''';

      expect(
        () => FormattedText.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<InvalidXmlElementException>()),
      );
    });
  });
  group('AccidentalText', () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/part-abbreviation-display-element/
    test(
        'Should parse accidental-text from <part-abbreviation-display> example correctly',
        () {
      String input = '''
        <accidental-text>flat</accidental-text>
      ''';

      var displayText = AccidentalText.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(displayText.value, AccidentalValue.flat);
      expect(displayText.formatting.enclosure, null);
      expect(displayText.formatting.justify, null);
      expect(displayText.formatting.lang, null);
      expect(displayText.formatting.letterSpacing, null);
      expect(displayText.formatting.space, null);
      expect(displayText.formatting.textDirection, null);
      expect(displayText.formatting.textRotation, null);
    });

    test('Shoud correctly parse all attributes of display text', () {
      String input = '''
        <accidental-text 
          enclosure="oval" 
          justify="center" 
          xml:lang="lt" 
          letter-spacing="1.1"
          xml:space="preserve"
          rotation="150"
          dir="rtl"
          >arrow-up</accidental-text>
      ''';

      var displayText = AccidentalText.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(displayText.value, AccidentalValue.arrowUp);
      expect(displayText.formatting.enclosure, EnclosureShape.oval);
      expect(displayText.formatting.justify, HorizontalAlignment.center);
      expect(displayText.formatting.lang, "lt");
      expect(displayText.formatting.letterSpacing, 1.1);
      expect(displayText.formatting.space, XmlSpace.preserve);
      expect(displayText.formatting.textDirection, TextDirection.rtl);
      expect(displayText.formatting.textRotation, 150);
    });

    test('Should throw expcetion when content is empty', () {
      String input = '''
        <accidental-text></accidental-text>
      ''';

      expect(
        () => AccidentalText.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<InvalidXmlElementException>()),
      );
    });

    test('Should throw expcetion when content is invalid', () {
      String input = '''
        <accidental-text>foo-bar</accidental-text>
      ''';

      expect(
        () => AccidentalText.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<InvalidMusicXmlType>()),
      );
    });
  });
}
