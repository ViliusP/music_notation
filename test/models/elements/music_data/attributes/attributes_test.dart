import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/attributes.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

void main() {
  group("Attribute ", () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/tutorial-hello-world/
    test("should parse 'Tutorial: Hello, World' example", () {
      String input = """
        <attributes>
          <divisions>1</divisions>
          <key>
            <fifths>0</fifths>
          </key>
          <time>
            <beats>4</beats>
            <beat-type>4</beat-type>
          </time>
          <clef>
            <sign>G</sign>
            <line>2</line>
          </clef>
        </attributes>
      """;

      Attributes attributes = Attributes.fromXml(
        XmlDocument.parse(input).rootElement,
      );
      expect(attributes.editorial.footnote, isNull);
      expect(attributes.editorial.level, isNull);
      expect(attributes.divisions, 1);
      expect(attributes.keys.length, 1);
      expect(attributes.times.length, 1);
      expect(attributes.staves, 1);
      expect(attributes.partSymbol, isNull);
      expect(attributes.instruments, 1);
      expect(attributes.clefs.length, 1);
      expect(attributes.staffDetails.length, 0);
      expect(attributes.tranpositions.length, 0);
      expect(attributes.directives.length, 0);
      expect(attributes.measureStyles.length, 0);
    });
  });

  group("Division ", () {
    test("should parse correctly simple case", () {
      String input = """
        <attributes>
          <divisions>2</divisions>
        </attributes>
      """;

      Attributes attributes = Attributes.fromXml(
        XmlDocument.parse(input).rootElement,
      );
      expect(attributes.divisions, 2);
    });
    test("parsing should throw on invalid content", () {
      String input = """
        <attributes>
          <divisions><foo></foo></divisions>
        </attributes>
      """;

      expect(
        () => Attributes.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("parsing should throw on invalid value", () {
      String input = """
        <attributes>
          <divisions>foo</divisions>
        </attributes>
      """;

      expect(
        () => Attributes.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on negative value", () {
      String input = """
        <attributes>
          <divisions>-1</divisions>
        </attributes>
      """;

      expect(
        () => Attributes.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on empty value", () {
      String input = """
        <attributes>
          <divisions></divisions>
        </attributes>
      """;

      expect(
        () => Attributes.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
  });
  group("Attribute staves", () {
    test("should be parsed from '<part-symbol>' example", () {
      String input = """
        <attributes>
          <divisions>2</divisions>
          <key>
            <fifths>0</fifths>
            <mode>major</mode>
          </key>
          <time>
            <beats>4</beats>
            <beat-type>4</beat-type>
          </time>
          <staves>3</staves>
          <part-symbol top-staff="1" bottom-staff="2">brace</part-symbol>
          <clef number="1">
            <sign>G</sign>
            <line>2</line>
          </clef>
          <clef number="2">
            <sign>F</sign>
            <line>4</line>
          </clef>
          <clef number="3">
            <sign>F</sign>
            <line>4</line>
          </clef>
        </attributes>
      """;

      Attributes attributes = Attributes.fromXml(
        XmlDocument.parse(input).rootElement,
      );
      expect(attributes.staves, 3);
    });
    test("parsing should throw on empty value", () {
      String input = """
        <attributes>
          <staves></staves>
        </attributes>
      """;

      expect(
        () => Attributes.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on negative value", () {
      String input = """
        <attributes>
          <staves>-1</staves>
        </attributes>
      """;

      expect(
        () => Attributes.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on xml children content", () {
      String input = """
        <attributes>
          <staves><foo/></staves>
        </attributes>
      """;

      expect(
        () => Attributes.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
  });
}
