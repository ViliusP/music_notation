import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/data_types/accidental_value.dart';
import 'package:music_notation/src/models/elements/music_data/note/accidental.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

void main() {
  group('Accidental', () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/accidental-element/
    test("should parse '<accidental>' example", () {
      String input = """
          <accidental>sharp</accidental>
        """;

      var accidental = Accidental.fromXml(XmlDocument.parse(input).rootElement);

      expect(accidental.value, AccidentalValue.sharp);
      expect(accidental.cautionary, isFalse);
      expect(accidental.editorial, isFalse);
      expect(accidental.levelDisplay.bracket, isNull);
      expect(accidental.levelDisplay.parentheses, isNull);
      expect(accidental.levelDisplay.size, isNull);
      expect(accidental.smufl, isNull);
    });
    test("parsing should throw on missing content", () {
      String input = """
          <accidental></accidental>
        """;

      expect(
        () => Accidental.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("parsing should throw on invalid content", () {
      String input = """
          <accidental><foo></foo></accidental>
        """;

      expect(
        () => Accidental.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("parsing should throw on invalid accidental value", () {
      String input = """
          <accidental>foo</accidental>
        """;

      expect(
        () => Accidental.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("parsing should throw on invalid editorial attribute", () {
      String input = """
          <accidental editorial="foo">flat-flat</accidental>
        """;

      expect(
        () => Accidental.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("parsing should throw on invalid cautionary attribute", () {
      String input = """
          <accidental editorial="foo">flat-flat</accidental>
        """;

      expect(
        () => Accidental.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("parsing should throw on invalid parentheses attribute", () {
      String input = """
          <accidental parentheses="foo">flat-flat</accidental>
        """;

      expect(
        () => Accidental.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("parsing should throw on invalid bracket attribute", () {
      String input = """
          <accidental bracket="foo">flat-flat</accidental>
        """;

      expect(
        () => Accidental.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("parsing should throw on invalid size attribute", () {
      String input = """
          <accidental size="foo">flat-flat</accidental>
        """;

      expect(
        () => Accidental.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
  });
}
