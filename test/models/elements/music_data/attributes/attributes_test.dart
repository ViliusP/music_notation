import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/attributes.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

void main() {
  group("Attribute ", () {
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
      expect(attributes.partSymbol, null);
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
}
