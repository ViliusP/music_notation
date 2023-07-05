import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/elements/music_data/note/stem.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

void main() {
  group('Stem', () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/accent-element/
    test("should parse '<accent>' example", () {
      String input = """
        <stem default-y="10">up</stem>
      """;

      var stem = Stem.fromXml(XmlDocument.parse(input).rootElement);

      expect(stem.value, StemValue.up);
      expect(stem.color.value, null);
      expect(stem.position.defaultY, 10);
      expect(stem.position.defaultX, null);
      expect(stem.position.relativeX, null);
      expect(stem.position.relativeY, null);
    });
    test("should parse '<accidental-mark> (Notation)' example", () {
      String input = """
        <stem default-y="-45">down</stem>
      """;

      var stem = Stem.fromXml(XmlDocument.parse(input).rootElement);

      expect(stem.value, StemValue.down);
      expect(stem.color.value, null);
      expect(stem.position.defaultY, -45);
      expect(stem.position.defaultX, null);
      expect(stem.position.relativeX, null);
      expect(stem.position.relativeY, null);
    });
    test("parsing should throw on invalid content", () {
      String input = """
        <stem default-y="-45"><foo></foo></stem>
      """;

      expect(
        () => Stem.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("parsing should throw on invalid stem value", () {
      String input = """
        <stem default-y="-45">foo</stem>
      """;

      expect(
        () => Stem.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("parsing should throw on invalid default-x attribute", () {
      String input = """
          <stem default-x="foo">none</stem>
        """;

      expect(
        () => Stem.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on invalid default-y attribute", () {
      String input = """
          <stem default-y="foo">none</stem>
        """;

      expect(
        () => Stem.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on invalid relative-x attribute", () {
      String input = """
          <stem relative-x="foo">none</stem>
        """;

      expect(
        () => Stem.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on invalid relative-y attribute", () {
      String input = """
          <stem relative-y="foo">none</stem>
        """;

      expect(
        () => Stem.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
  });
}
