import 'package:music_notation/src/models/identification.dart';
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
    test('should parse all properties', () {
      String input = '''
        <encoding>
            <software>MuseScore 3.2.3</software>
            <encoding-date>2019-10-10</encoding-date>
            <supports element="accidental" type="yes" />
            <supports element="beam" type="yes" />
            <supports element="print" attribute="new-page" type="yes" value="yes" />
            <supports element="print" attribute="new-system" type="yes" value="yes" />
            <supports element="stem" type="yes" />
        </encoding>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      var encoding = Encoding.fromXml(rootElement);

      expect(encoding.software, equals("MuseScore 3.2.3"));
      expect(encoding.encodingDate, equals(DateTime(2019, 10, 10)));
      expect(encoding.supports.length, 5);
    });

    test('should throw error on bad datetime', () {
      String input = '''
        <encoding>
            <software>MuseScore 3.2.3</software>
            <encoding-date>2019546454</encoding-date>
        </encoding>
      ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      expect(() => Encoding.fromXml(rootElement), throwsException);
    });
  });

  group('Support', () {
    test('should parse element and type', () {
      String input = '<supports element="accidental" type="yes" />';
      var rootElement = XmlDocument.parse(input).rootElement;

      var support = Support.fromXml(rootElement);

      expect(support.element, equals("accidental"));
      expect(support.type, equals(true));
    });

    test('should parse element and type', () {
      String input = '<supports element="beam" type="no" />';
      var rootElement = XmlDocument.parse(input).rootElement;

      var support = Support.fromXml(rootElement);

      expect(support.element, equals("beam"));
      expect(support.type, equals(false));
    });

    test('should parse element and type', () {
      String input =
          '<supports element="print" attribute="new-page" type="yes" value="yes" />';
      var rootElement = XmlDocument.parse(input).rootElement;

      var support = Support.fromXml(rootElement);

      expect(support.element, equals("print"));
      expect(support.attribute, equals("new-page"));
      expect(support.value, equals("yes"));
      expect(support.type, equals(true));
    });

    test('should parse throw exception because of element format', () {
      String input =
          '<supports element="brought classical music to the Peanuts strip" type="yes" />';
      var rootElement = XmlDocument.parse(input).rootElement;

      expect(() => Support.fromXml(rootElement), throwsException);
    });

    test('should parse throw exception because of element format', () {
      String input =
          '<supports element="Snoopy" type="yes" attribute="bold,brash"/>';
      var rootElement = XmlDocument.parse(input).rootElement;

      expect(() => Support.fromXml(rootElement), throwsException);
    });
  });

  group('Support', () {
    test('should parse element and type', () {
      String input = '<supports element="accidental" type="yes" />';
      var rootElement = XmlDocument.parse(input).rootElement;

      var support = Support.fromXml(rootElement);

      expect(support.element, equals("accidental"));
      expect(support.type, equals(true));
    });

    test('should parse element and type', () {
      String input = '<supports element="beam" type="no" />';
      var rootElement = XmlDocument.parse(input).rootElement;

      var support = Support.fromXml(rootElement);

      expect(support.element, equals("beam"));
      expect(support.type, equals(false));
    });

    test('should parse element and type', () {
      String input =
          '<supports element="print" attribute="new-page" type="yes" value="yes" />';
      var rootElement = XmlDocument.parse(input).rootElement;

      var support = Support.fromXml(rootElement);

      expect(support.element, equals("print"));
      expect(support.attribute, equals("new-page"));
      expect(support.value, equals("yes"));
      expect(support.type, equals(true));
    });

    test('should parse throw exception because of element format', () {
      String input =
          '<supports element="brought classical music to the Peanuts strip" type="yes" />';
      var rootElement = XmlDocument.parse(input).rootElement;

      expect(() => Support.fromXml(rootElement), throwsException);
    });

    test('should parse throw exception because of element format', () {
      String input =
          '<supports element="Snoopy" type="yes" attribute="bold,brash"/>';
      var rootElement = XmlDocument.parse(input).rootElement;

      expect(() => Support.fromXml(rootElement), throwsException);
    });
  });
}
