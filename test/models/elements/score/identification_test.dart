import 'package:music_notation/src/models/elements/score/identification.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('Identification', () {
    // TODO: do more tests
    test('should parse all properties', () {
      String input = '''
        <identification>
          <encoding>
              <software>MuseScore 3.2.3</software>
              <encoding-date>2019-10-10</encoding-date>
              <supports element="accidental" type="yes" />
              <supports element="beam" type="yes" />
              <supports element="print" attribute="new-page" type="yes" value="yes" />
              <supports element="print" attribute="new-system" type="yes" value="yes" />
              <supports element="stem" type="yes" />
          </encoding>
        </identification>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      var identification = Identification.fromXml(rootElement);

      expect(identification.encoding, isNotNull);
    });
  });

  group('Encoding', () {
    test('should parse encoding-date', () {
      String input = '''
        <encoding-date>2019-10-10</encoding-date>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      var software = Encoding.fromXml(rootElement);

      expect(software, isA<EncodingDate>());
      expect((software as EncodingDate).value, DateTime(2019, 10, 10));
    });
    test('should throw on empty encoding-date', () {
      String input = '''
        <encoding-date></encoding-date>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      expect(
        () => Encoding.fromXml(rootElement),
        throwsA(isA<InvalidXmlElementException>()),
      );
    });
    test('should throw error on bad datetime', () {
      String input = '''
        <encoding-date>2019546454</encoding-date>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      expect(
        () => Encoding.fromXml(rootElement),
        throwsA(isA<FormatException>()),
      );
    });
    test('should throw error on bad datetime', () {
      String input = '''
        <encoding-date><child>your child</child></encoding-date>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      expect(
        () => Encoding.fromXml(rootElement),
        throwsA(isA<InvalidXmlElementException>()),
      );
    });
    test('should parse encoder', () {
      String input = '''
        <encoder>Mark D. Lew</encoder>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;
      var encoder = Encoding.fromXml(rootElement);

      expect(encoder, isA<Encoder>());
      expect((encoder as Encoder).value, equals("Mark D. Lew"));
    });
    test('should throw on empty encoder', () {
      String input = '''
        <encoder></encoder>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      expect(
        () => Encoding.fromXml(rootElement),
        throwsA(isA<InvalidXmlElementException>()),
      );
    });
    test('should parse software', () {
      String input = '''
        <software>MuseScore 3.2.3</software>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      var software = Encoding.fromXml(rootElement);

      expect(software, isA<Software>());
      expect((software as Software).value, equals("MuseScore 3.2.3"));
    });
    test('should throw on empty software', () {
      String input = '''
        <software></software>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      expect(
        () => Encoding.fromXml(rootElement),
        throwsA(isA<InvalidXmlElementException>()),
      );
    });
    test('should parse encoding description', () {
      String input = '''
        <encoding-description>MusicXML example</encoding-description>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      var software = Encoding.fromXml(rootElement);

      expect(software, isA<EncodingDescription>());
      expect(
        (software as EncodingDescription).value,
        equals("MusicXML example"),
      );
    });
    test('should throw on empty encoding-description', () {
      String input = '''
        <encoding-description></encoding-description>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      expect(
        () => Encoding.fromXml(rootElement),
        throwsA(isA<InvalidXmlElementException>()),
      );
    });
  });

  group('Support', () {
    test('should parse element and type', () {
      String input = '<supports element="accidental" type="yes" />';
      var rootElement = XmlDocument.parse(input).rootElement;

      var support = Supports.fromXml(rootElement);

      expect(support.element, equals("accidental"));
      expect(support.type, equals(true));
    });

    test('should parse element and type', () {
      String input = '<supports element="beam" type="no" />';
      var rootElement = XmlDocument.parse(input).rootElement;

      var support = Supports.fromXml(rootElement);

      expect(support.element, equals("beam"));
      expect(support.type, equals(false));
    });

    test('should parse element, type, attribute, value', () {
      String input =
          '<supports element="print" attribute="new-page" type="yes" value="yes" />';
      var rootElement = XmlDocument.parse(input).rootElement;

      var support = Supports.fromXml(rootElement);

      expect(support.element, equals("print"));
      expect(support.attribute, equals("new-page"));
      expect(support.value, equals("yes"));
      expect(support.type, equals(true));
    });

    test(
        'should throw on parsing exception when element has spaces (not NMTOKEN)',
        () {
      String input =
          '<supports element="brought classical music to the Peanuts strip" type="yes" />';
      var rootElement = XmlDocument.parse(input).rootElement;

      expect(() => Supports.fromXml(rootElement),
          throwsA(isA<InvalidMusicXmlType>()));
    });

    test(
        'should throw on parsing exception when attribute has commas (not NMTOKEN)',
        () {
      String input =
          '<supports element=" Snoopy" type="yes" attribute="bold,brash"/>';
      var rootElement = XmlDocument.parse(input).rootElement;

      expect(
        () => Supports.fromXml(rootElement),
        throwsA(isA<InvalidMusicXmlType>()),
      );
    });

    test('when parsing should throw error on missing element', () {
      String input = '<supports type="yes" />';
      var rootElement = XmlDocument.parse(input).rootElement;

      expect(() => Supports.fromXml(rootElement),
          throwsA(isA<XmlAttributeRequired>()));
    });

    test('should parse throw exception because on missing type', () {
      String input = '<supports element="Snoopy" />';
      var rootElement = XmlDocument.parse(input).rootElement;

      expect(() => Supports.fromXml(rootElement),
          throwsA(isA<XmlAttributeRequired>()));
    });
  });
}
