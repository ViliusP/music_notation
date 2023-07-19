import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/elements/music_data/offset.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

void main() {
  group("Offset should parse", () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/bracket-element/
    test("'<bracket>' example", () {
      String input = """
        <offset>-1</offset>
      """;

      var offset = Offset.fromXml(XmlDocument.parse(input).rootElement);

      expect(offset.value, -1);
      expect(offset.sound, isFalse);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/instrument-change-element/
    test("'<pedal> (Symbols)' example", () {
      String input = """
        <offset sound="yes">-22</offset>
      """;

      var offset = Offset.fromXml(XmlDocument.parse(input).rootElement);

      expect(offset.value, -22);
      expect(offset.sound, isTrue);
    });
  });
  group("Offset parsing should throw", () {
    test("on wrong content", () {
      String input = """
        <offset sound="yes">foo</offset>
      """;

      expect(
        () => Offset.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("on other xml element content", () {
      String input = """
        <offset sound="yes"><foo/></offset>
      """;

      expect(
        () => Offset.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("on empty content", () {
      String input = """
        <offset sound="yes"></offset>
      """;

      expect(
        () => Offset.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("on wrong sound attribute", () {
      String input = """
        <offset sound="foo">10</offset>
      """;

      expect(
        () => Offset.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
  });
}
