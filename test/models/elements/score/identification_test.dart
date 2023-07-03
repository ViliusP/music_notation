import 'package:music_notation/src/models/elements/score/identification.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('Identification parsing', () {
    test('should parse all properties', () {
      String input = '''
        <identification>
          <creator type="composer">Claude Debussy</creator>
          <creator type="lyricist">Paul Bourget</creator>
          <rights>Copyright © 2010 Recordare LLC</rights>
          <encoding>
              <encoder>Mark D. Lew</encoder>
              <encoding-date>2010-12-17</encoding-date>
              <software>Finale for Windows</software>
              <encoding-description>MusicXML example</encoding-description>
              <supports element="accidental" type="yes"/>
              <supports element="beam" type="yes"/>
              <supports element="stem" type="yes"/>
          </encoding>
          <source>Based on E. Girod edition of 1891, republished by Dover in 1981.</source>
          <relation>urn:ISBN:0-486-24131-9</relation>
          <miscellaneous>
              <miscellaneous-field name="difficulty-level">3</miscellaneous-field>
          </miscellaneous>
        </identification>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      var identification = Identification.fromXml(rootElement);

      expect(identification.creators?.length, 2);
      expect(identification.rights, isNotNull);
      expect(identification.encoding, isNotNull);
      expect(identification.source, isNotNull);
      expect(identification.miscellaneous?.length, 1);
    });
    test('should throw on wrong order', () {
      String input = '''
        <identification>
          <rights>Copyright © 2010 Recordare LLC</rights>
          <creator type="composer">Claude Debussy</creator>
          <creator type="lyricist">Paul Bourget</creator>
          <miscellaneous>
              <miscellaneous-field name="difficulty-level">3</miscellaneous-field>
          </miscellaneous>
        </identification>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      expect(
        () => Identification.fromXml(rootElement),
        throwsA(isA<XmlSequenceException>()),
      );
    });
  });

  group('Encoding parsing', () {
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

      expect(
        () => Encoding.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test('should throw error on bad datetime', () {
      String input = '''
        <encoding-date>2019546454</encoding-date>
      ''';

      expect(
        () => Encoding.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test('should throw exception on invalid encoding-date content', () {
      String input = '''
        <encoding-date><child>your child</child></encoding-date>
      ''';

      expect(
        () => Encoding.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test('should parse encoder', () {
      String input = '''
        <encoder>Mark D. Lew</encoder>
      ''';

      var encoder = Encoding.fromXml(XmlDocument.parse(input).rootElement);

      expect(encoder, isA<Encoder>());
      expect((encoder as Encoder).value, equals("Mark D. Lew"));
    });
    test('should parse empty encoder', () {
      String input = '''
        <encoder></encoder>
      ''';

      var encoder = Encoding.fromXml(XmlDocument.parse(input).rootElement);

      expect(encoder, isA<Encoder>());
      expect((encoder as Encoder).value, equals(""));
    });
    test('should parse software', () {
      String input = '''
        <software>MuseScore 3.2.3</software>
      ''';

      var software = Encoding.fromXml(XmlDocument.parse(input).rootElement);

      expect(software, isA<Software>());
      expect((software as Software).value, equals("MuseScore 3.2.3"));
    });
    test('should parse empty software', () {
      String input = '''
        <software></software>
      ''';

      Encoding encoding = Encoding.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(encoding, isA<Software>());
      expect((encoding as Software).value, equals(""));
    });
    test('should parse encoding description', () {
      String input = '''
        <encoding-description>MusicXML example</encoding-description>
      ''';

      var encodingDescription = Encoding.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(encodingDescription, isA<EncodingDescription>());
      expect(
        (encodingDescription as EncodingDescription).value,
        equals("MusicXML example"),
      );
    });
    test('should parse empty encoding-description', () {
      String input = '''
        <encoding-description></encoding-description>
      ''';

      var encodingDescription = Encoding.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(encodingDescription, isA<EncodingDescription>());
      expect(
        (encodingDescription as EncodingDescription).value,
        equals(""),
      );
    });
  });
  group('Support parsing', () {
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
          throwsA(isA<MusicXmlFormatException>()));
    });

    test(
        'should throw on parsing exception when attribute has commas (not NMTOKEN)',
        () {
      String input =
          '<supports element=" Snoopy" type="yes" attribute="bold,brash"/>';
      var rootElement = XmlDocument.parse(input).rootElement;

      expect(
        () => Supports.fromXml(rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });

    test('when parsing should throw error on missing element', () {
      String input = '<supports type="yes" />';
      var rootElement = XmlDocument.parse(input).rootElement;

      expect(() => Supports.fromXml(rootElement),
          throwsA(isA<MissingXmlAttribute>()));
    });

    test('should parse throw exception because on missing type', () {
      String input = '<supports element="Snoopy" />';
      var rootElement = XmlDocument.parse(input).rootElement;

      expect(() => Supports.fromXml(rootElement),
          throwsA(isA<MissingXmlAttribute>()));
    });
  });
}
