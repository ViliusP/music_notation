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
        'should parse display-text from <part-abbreviation-display> example correctly',
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

    test('should correctly parse all attributes of display text', () {
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

    test('should throw expcetion when content is empty', () {
      String input = '''
        <display-text></display-text>
      ''';

      expect(
        () => FormattedText.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
  });
  group('AccidentalText', () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/part-abbreviation-display-element/
    test(
        'should parse accidental-text from <part-abbreviation-display> example correctly',
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

    test('shoud correctly parse all attributes of display text', () {
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

    test('should throw exception when content is empty', () {
      String input = '''
        <accidental-text></accidental-text>
      ''';

      expect(
        () => AccidentalText.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });

    test('should throw exception when content is not accidental value', () {
      String input = '''
        <accidental-text>foo-bar</accidental-text>
      ''';

      expect(
        () => AccidentalText.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test('should throw exception when content is invalid', () {
      String input = '''
        <accidental-text><foo></foo></accidental-text>
      ''';

      expect(
        () => AccidentalText.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
  });
  group('FormattedTextId', () {
    test('should parse correctly', () {
      String input = '''
        <credit-words id="fooID" default-x="105" default-y="1353" font-size="12" valign="top">Score in C</credit-words>
      ''';

      var formattedTextId = FormattedTextId.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(formattedTextId.id, "fooID");
      expect(formattedTextId.value, "Score in C");
      expect(formattedTextId.formatting.font.size?.getValue, 12);
      expect(formattedTextId.formatting.position.defaultX, 105);
      expect(formattedTextId.formatting.position.defaultY, 1353);
      expect(
        formattedTextId.formatting.verticalAlignment,
        VerticalAlignment.top,
      );
    });
  });
  group('Font', () {
    // Size
    test('should parse font attributes with css size correctly', () {
      String input = '''
        <foo font-size="xx-small"/>
      ''';

      var font = Font.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(font.size?.getValue, CssFontSize.xxSmall);
    });
    test('should parse font attributes with decimal size correctly', () {
      String input = '''
        <foo font-size="12"/>
      ''';

      var font = Font.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(font.size?.getValue, 12);
    });
    test('should throw on parsing empty font size', () {
      String input = '''
        <foo font-size=""/>
      ''';

      expect(
        () => Font.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test('should throw on parsing invalid font size', () {
      String input = '''
        <foo font-size="bar"/>
      ''';

      expect(
        () => Font.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    // Style
    test('should parse font attributes with style correctly', () {
      String input = '''
        <foo font-style="italic"/>
      ''';

      var font = Font.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(font.style, FontStyle.italic);
    });
    test('should throw on parsing empty font style', () {
      String input = '''
        <foo font-style=""/>
      ''';

      expect(
        () => Font.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test('should throw on parsing invalid font style', () {
      String input = '''
        <foo font-style="bar"/>
      ''';

      expect(
        () => Font.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
  });
  // Weight
  test('should parse font attributes with style correctly', () {
    String input = '''
        <foo font-weight="bold"/>
      ''';

    var font = Font.fromXml(
      XmlDocument.parse(input).rootElement,
    );

    expect(font.weight, FontWeight.bold);
  });
  test('should throw on parsing empty font style', () {
    String input = '''
        <foo font-weight=""/>
      ''';

    expect(
      () => Font.fromXml(
        XmlDocument.parse(input).rootElement,
      ),
      throwsA(isA<MusicXmlFormatException>()),
    );
  });
  test('should throw on parsing invalid font style', () {
    String input = '''
        <foo font-weight="bar"/>
      ''';

    expect(
      () => Font.fromXml(
        XmlDocument.parse(input).rootElement,
      ),
      throwsA(isA<MusicXmlFormatException>()),
    );
  });
}
