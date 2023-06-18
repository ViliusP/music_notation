import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/xml_format_validators.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group("Expected element", () {
    test('transform function should correctly convert old format to new format',
        () {
      Map<dynamic, XmlQuantifier> oldSequence = {
        "e1|e2": XmlQuantifier.required,
        "e3": XmlQuantifier.required,
        {
          "ne1": XmlQuantifier.required,
          "ne2": XmlQuantifier.required,
        }: XmlQuantifier.oneOrMore,
      };

      List<ExpectedElement> expectedNewSequence = [
        const ExpectedElement(
          nameOptions: {"e1", "e2"},
          quantifier: XmlQuantifier.required,
        ),
        const ExpectedElement(
          nameOptions: {"e3"},
          quantifier: XmlQuantifier.required,
        ),
        const NestedExpectedElement(
          nameOptions: {"ne1", "ne2"},
          quantifier: XmlQuantifier.oneOrMore,
          nestedElements: [
            ExpectedElement(
              nameOptions: {"ne1"},
              quantifier: XmlQuantifier.required,
            ),
            ExpectedElement(
              nameOptions: {"ne2"},
              quantifier: XmlQuantifier.required,
            ),
          ],
        ),
      ];

      List<ExpectedElement> actualNewSequence = oldSequence.entries
          .map((e) => ExpectedElement.transformFromMap({e.key: e.value}))
          .toList();

      expect(actualNewSequence, expectedNewSequence);
    });
  });
  group('Sequence validator', () {
    test('should validate all required', () {
      String rawXml = '''
        <root>
          <e1></e1>
          <e2></e2>
          <e3></e3>
          <e4></e4>
          <e5></e5>
          <e6></e6>
          <e7></e7>
        </root>
      ''';

      Map<dynamic, XmlQuantifier> expectedOrder = {
        "e1": XmlQuantifier.required,
        "e2": XmlQuantifier.required,
        "e3": XmlQuantifier.required,
        "e4": XmlQuantifier.required,
        "e5": XmlQuantifier.required,
        "e6": XmlQuantifier.required,
        "e7": XmlQuantifier.required,
      };

      var xmlElement = XmlDocument.parse(rawXml).rootElement;

      expect(
        () => validateSequence(xmlElement, expectedOrder),
        returnsNormally,
      );
    });
    test('should throw expcetion when required is missing', () {
      String rawXml = '''
        <root>
          <e1></e1>
          <e2></e2>
          <e4></e4>
        </root>
      ''';

      Map<dynamic, XmlQuantifier> expectedOrder = {
        "e1": XmlQuantifier.required,
        "e2": XmlQuantifier.required,
        "e3": XmlQuantifier.required,
        "e4": XmlQuantifier.required,
      };

      var xmlElement = XmlDocument.parse(rawXml).rootElement;

      expect(
        () => validateSequence(xmlElement, expectedOrder),
        throwsA(isA<InvalidXmlSequence>()),
      );
    });
    test('should validate empty with all optional expected', () {
      String rawXml = '''
        <root>
        </root>
      ''';

      Map<dynamic, XmlQuantifier> expectedOrder = {
        "e1": XmlQuantifier.optional,
        "e2": XmlQuantifier.optional,
        "e3": XmlQuantifier.optional,
        "e4": XmlQuantifier.optional,
      };

      var xmlElement = XmlDocument.parse(rawXml).rootElement;

      expect(
        () => validateSequence(xmlElement, expectedOrder),
        returnsNormally,
      );
    });
    test('should validate with all optional expected', () {
      String rawXml = '''
        <root>
          <e1></e1>
          <e3></e3>
        </root>
      ''';

      Map<dynamic, XmlQuantifier> expectedOrder = {
        "e1": XmlQuantifier.optional,
        "e2": XmlQuantifier.optional,
        "e3": XmlQuantifier.optional,
      };

      var xmlElement = XmlDocument.parse(rawXml).rootElement;

      expect(
        () => validateSequence(xmlElement, expectedOrder),
        returnsNormally,
      );
    });
    test('should validate with optional and required expected', () {
      String rawXml = '''
        <root>
          <e1></e1>
          <e3></e3>
        </root>
      ''';

      Map<dynamic, XmlQuantifier> expectedOrder = {
        "e1": XmlQuantifier.optional,
        "e2": XmlQuantifier.optional,
        "e3": XmlQuantifier.required,
      };

      var xmlElement = XmlDocument.parse(rawXml).rootElement;

      expect(
        () => validateSequence(xmlElement, expectedOrder),
        returnsNormally,
      );
    });

    test('should validate with oneOrMore expected', () {
      String rawXml = '''
        <root>
          <e1></e1>
          <e1></e1>
        </root>
      ''';

      Map<dynamic, XmlQuantifier> expectedOrder = {
        "e1": XmlQuantifier.oneOrMore,
      };

      var xmlElement = XmlDocument.parse(rawXml).rootElement;

      expect(
        () => validateSequence(xmlElement, expectedOrder),
        returnsNormally,
      );
    });

    test('should throw on validation when oneOrMore is missing', () {
      String rawXml = '''
        <root>
          <e1></e1>
          <e1></e1>
        </root>
      ''';

      Map<dynamic, XmlQuantifier> expectedOrder = {
        "e1": XmlQuantifier.oneOrMore,
        "e2": XmlQuantifier.oneOrMore,
      };

      var xmlElement = XmlDocument.parse(rawXml).rootElement;

      expect(
        () => validateSequence(xmlElement, expectedOrder),
        throwsA(isA<InvalidXmlSequence>()),
      );
    });
    test('should validate when oneOrMore, required and optional expected', () {
      String rawXml = '''
        <root>
          <e1></e1>
          <e1></e1>
          <e1></e1>
          <e2></e2>
          <e4></e4>
        </root>
      ''';

      Map<dynamic, XmlQuantifier> expectedOrder = {
        "e1": XmlQuantifier.oneOrMore,
        "e2": XmlQuantifier.optional,
        "e3": XmlQuantifier.optional,
        "e4": XmlQuantifier.required
      };

      var xmlElement = XmlDocument.parse(rawXml).rootElement;

      expect(
        () => validateSequence(xmlElement, expectedOrder),
        returnsNormally,
      );
    });
    test('should validate when zeroOrMore expected and no children exist', () {
      String rawXml = '''
        <root>
          <e1></e1>
          <e1></e1>
          <e1></e1>
          <e1></e1>
        </root>
      ''';

      Map<dynamic, XmlQuantifier> expectedOrder = {
        "e1": XmlQuantifier.zeroOrMore,
      };

      var xmlElement = XmlDocument.parse(rawXml).rootElement;

      expect(
        () => validateSequence(xmlElement, expectedOrder),
        returnsNormally,
      );
    });

    test('should validate when zeroOrMore expected and some children exist',
        () {
      String rawXml = '''
        <root>
        </root>
      ''';

      Map<dynamic, XmlQuantifier> expectedOrder = {
        "e1": XmlQuantifier.zeroOrMore,
      };

      var xmlElement = XmlDocument.parse(rawXml).rootElement;

      expect(
        () => validateSequence(xmlElement, expectedOrder),
        returnsNormally,
      );
    });

    test('should validate complex sequence where all 4 XmlQuantifiers expected',
        () {
      String rawXml = '''
        <root>
          <e1></e1>
          <e1></e1>
          <e3></e3>
          <e4></e4>
          <e5></e5>
          <e6></e6>
          <e6></e6>
          <e6></e6>
        </root>
      ''';

      Map<dynamic, XmlQuantifier> expectedOrder = {
        "e1": XmlQuantifier.zeroOrMore,
        "e2": XmlQuantifier.optional,
        "e3": XmlQuantifier.oneOrMore,
        "e4": XmlQuantifier.required,
        "e5": XmlQuantifier.optional,
        "e6": XmlQuantifier.oneOrMore,
        "e7": XmlQuantifier.zeroOrMore,
      };

      var xmlElement = XmlDocument.parse(rawXml).rootElement;

      expect(
        () => validateSequence(xmlElement, expectedOrder),
        returnsNormally,
      );
    });
    test('should throw exception when key aren\'t string or other Map', () {
      String rawXml = '''
        <root>
          <e1></e1>
        </root>
      ''';

      Map<dynamic, XmlQuantifier> expectedOrder = {
        "e1": XmlQuantifier.zeroOrMore,
        2: XmlQuantifier.optional,
        int: XmlQuantifier.oneOrMore,
        Object: XmlQuantifier.required,
      };

      var xmlElement = XmlDocument.parse(rawXml).rootElement;

      expect(
        () => validateSequence(xmlElement, expectedOrder),
        throwsA(isA<ArgumentError>()),
      );
    });
    test(
        'should validate when required multiple choice element (divided by "|")',
        () {
      String rawXml1 = '''
        <root>
          <e1></e1>
        </root>
      ''';

      String rawXml2 = '''
        <root>
          <e1></e1>
        </root>
      ''';

      Map<dynamic, XmlQuantifier> expectedOrder = {
        "e1|e2": XmlQuantifier.required,
      };

      var xmlElement1 = XmlDocument.parse(rawXml1).rootElement;
      expect(
        () => validateSequence(xmlElement1, expectedOrder),
        returnsNormally,
      );

      var xmlElement2 = XmlDocument.parse(rawXml2).rootElement;
      expect(
        () => validateSequence(xmlElement2, expectedOrder),
        returnsNormally,
      );
    });
    test(
        'should validate when zerOrMore multiple choice element (divided by "|") is expected',
        () {
      String rawXml = '''
        <root>
          <e1></e1>
          <e2></e2>
          <e2></e2>
          <e2></e2>
          <e1></e1>
          <e2></e2>
          <e1></e1>
          <e1></e1>
          <e3></e3>
        </root>
      ''';

      Map<dynamic, XmlQuantifier> expectedOrder = {
        "e1|e2": XmlQuantifier.oneOrMore,
        "e3": XmlQuantifier.required
      };

      var xmlElement = XmlDocument.parse(rawXml).rootElement;
      expect(
        () => validateSequence(xmlElement, expectedOrder),
        returnsNormally,
      );
    });
    test(
        'should validate when optional multiple choice element (divided by "|") is expected',
        () {
      String rawXml = '''
        <root>
          <e3></e3>
        </root>
      ''';

      Map<dynamic, XmlQuantifier> expectedOrder = {
        "e1|e2": XmlQuantifier.optional,
        "e3": XmlQuantifier.required
      };

      var xmlElement = XmlDocument.parse(rawXml).rootElement;
      expect(
        () => validateSequence(xmlElement, expectedOrder),
        returnsNormally,
      );
    });
    test('should validate optional nested structure', () {
      String rawXml = '''
        <root>
          <e1></e1>
          <e3></e3>
        </root>
      ''';

      Map<dynamic, XmlQuantifier> expectedOrder = {
        "e1|e2": XmlQuantifier.required,
        "e3": XmlQuantifier.required,
        {
          "ne1": XmlQuantifier.optional,
          "ne2": XmlQuantifier.optional,
        }: XmlQuantifier.zeroOrMore,
      };

      var xmlElement = XmlDocument.parse(rawXml).rootElement;
      expect(
        () => validateSequence(xmlElement, expectedOrder),
        returnsNormally,
      );
    });
    test('should validate required nested structure #1', () {
      String rawXml = '''
        <root>
          <e1></e1>
          <e3></e3>
          <ne1></ne1>
          <ne1></ne1>
          <ne2></ne2>
        </root>
      ''';

      Map<dynamic, XmlQuantifier> expectedOrder = {
        "e1|e2": XmlQuantifier.required,
        "e3": XmlQuantifier.required,
        {
          "ne1": XmlQuantifier.optional,
          "ne2": XmlQuantifier.optional,
        }: XmlQuantifier.oneOrMore,
      };

      var xmlElement = XmlDocument.parse(rawXml).rootElement;
      expect(
        () => validateSequence(xmlElement, expectedOrder),
        returnsNormally,
      );
    });
    test('should validate required nested structure #2', () {
      String rawXml = '''
        <root>
          <e1></e1>
          <e3></e3>
          <ne1></ne1>
          <ne2></ne2>
          <ne1></ne1>
          <ne2></ne2>
          <ne1></ne1>
          <ne2></ne2>
        </root>
      ''';

      Map<dynamic, XmlQuantifier> expectedOrder = {
        "e1|e2": XmlQuantifier.required,
        "e3": XmlQuantifier.required,
        {
          "ne1": XmlQuantifier.required,
          "ne2": XmlQuantifier.required,
        }: XmlQuantifier.oneOrMore,
      };

      var xmlElement = XmlDocument.parse(rawXml).rootElement;
      expect(
        () => validateSequence(xmlElement, expectedOrder),
        returnsNormally,
      );
    });

    test('should throw exception on invalid nested structure #1', () {
      String rawXml = '''
        <root>
          <e1></e1>
          <e3></e3>
          <ne1></ne1>
          <ne2></ne2>
          <ne2></ne2>
        </root>
      ''';

      Map<dynamic, XmlQuantifier> expectedOrder = {
        "e1|e2": XmlQuantifier.required,
        "e3": XmlQuantifier.required,
        {
          "ne1": XmlQuantifier.required,
          "ne2": XmlQuantifier.required,
        }: XmlQuantifier.oneOrMore,
      };

      var xmlElement = XmlDocument.parse(rawXml).rootElement;
      expect(
        () => validateSequence(xmlElement, expectedOrder),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw exception on invalid nested structure #2', () {
      String rawXml = '''
        <root>
          <e1></e1>
          <e3></e3>
          <ne2></ne2>
        </root>
      ''';

      Map<dynamic, XmlQuantifier> expectedOrder = {
        "e1|e2": XmlQuantifier.required,
        "e3": XmlQuantifier.required,
        {
          "ne1": XmlQuantifier.required,
          "ne2": XmlQuantifier.optional,
        }: XmlQuantifier.oneOrMore,
      };

      var xmlElement = XmlDocument.parse(rawXml).rootElement;
      expect(
        () => validateSequence(xmlElement, expectedOrder),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
