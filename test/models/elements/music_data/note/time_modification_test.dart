import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/models/elements/music_data/note/time_modification.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

void main() {
  group('Time modification', () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/beam-element/
    test("should parse '<beam>' example", () {
      String input = """
        <time-modification>
          <actual-notes>3</actual-notes>
          <normal-notes>2</normal-notes>
        </time-modification>
        """;

      var timeModification = TimeModification.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(timeModification.actualNotes, 3);
      expect(timeModification.normalNotes, 2);
      expect(timeModification.normalType, isNull);
      expect(timeModification.normalDots, 0);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/normal-dot-element/
    test("should parse '<normal-dot>' example", () {
      String input = """
        <time-modification>
          <actual-notes>3</actual-notes>
          <normal-notes>2</normal-notes>
          <normal-type>quarter</normal-type>
          <normal-dot/>
        </time-modification>
        """;

      var timeModification = TimeModification.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(timeModification.actualNotes, 3);
      expect(timeModification.normalNotes, 2);
      expect(timeModification.normalType, NoteTypeValue.quarter);
      expect(timeModification.normalDots, 1);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/tuplet-dot-element/
    test("should parse '<tuplet-dot>' example", () {
      String input = """
        <time-modification>
          <actual-notes>10</actual-notes>
          <normal-notes>6</normal-notes>
          <normal-type>eighth</normal-type>
        </time-modification>
        """;

      var timeModification = TimeModification.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(timeModification.actualNotes, 10);
      expect(timeModification.normalNotes, 6);
      expect(timeModification.normalType, NoteTypeValue.eighth);
    });
    test("parsing should throw on wrong order", () {
      String input = """
        <time-modification>
          <normal-type>eighth</normal-type>
          <actual-notes>10</actual-notes>
          <normal-notes>6</normal-notes>
        </time-modification>
        """;

      expect(
        () => TimeModification.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlSequenceException>()),
      );
    });
    test("parsing should throw on normal-dot without normal-type", () {
      String input = """
        <time-modification>
          <actual-notes>10</actual-notes>
          <normal-notes>6</normal-notes>
          <normal-dot/>
        </time-modification>
        """;

      expect(
        () => TimeModification.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlSequenceException>()),
      );
    });
    test("parsing should throw on invalid actual-notes content", () {
      String input = """
        <time-modification>
          <actual-notes><foo></foo></actual-notes>
          <normal-notes>6</normal-notes>
          <normal-type>eighth</normal-type>
        </time-modification>
        """;

      expect(
        () => TimeModification.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("parsing should throw on non number actual-notes value", () {
      String input = """
        <time-modification>
          <actual-notes>foo</actual-notes>
          <normal-notes>6</normal-notes>
          <normal-type>eighth</normal-type>
        </time-modification>
        """;

      expect(
        () => TimeModification.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on negative number actual-notes value", () {
      String input = """
        <time-modification>
          <actual-notes>-1</actual-notes>
          <normal-notes>6</normal-notes>
          <normal-type>eighth</normal-type>
        </time-modification>
        """;

      expect(
        () => TimeModification.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on invalid normal-notes content", () {
      String input = """
        <time-modification>
          <actual-notes>6</actual-notes>
          <normal-notes><foo></foo></normal-notes>
          <normal-type>eighth</normal-type>
        </time-modification>
        """;

      expect(
        () => TimeModification.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("parsing should throw on non number normal-notes value", () {
      String input = """
        <time-modification>
          <actual-notes>8</actual-notes>
          <normal-notes>foo</normal-notes>
          <normal-type>eighth</normal-type>
        </time-modification>
        """;

      expect(
        () => TimeModification.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on negative number normal-notes value", () {
      String input = """
        <time-modification>
          <actual-notes>8</actual-notes>
          <normal-notes>-1</normal-notes>
          <normal-type>eighth</normal-type>
        </time-modification>
        """;

      expect(
        () => TimeModification.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on invalid normal-type content", () {
      String input = """
        <time-modification>
          <actual-notes>6</actual-notes>
          <normal-notes>4</normal-notes>
          <normal-type><foo></foo></normal-type>
        </time-modification>
        """;

      expect(
        () => TimeModification.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("parsing should throw on invalid normal-type value", () {
      String input = """
        <time-modification>
          <actual-notes>8</actual-notes>
          <normal-notes>6</normal-notes>
          <normal-type>foo</normal-type>
        </time-modification>
        """;

      expect(
        () => TimeModification.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
  });
}
