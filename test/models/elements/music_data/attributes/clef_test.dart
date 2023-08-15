import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

void main() {
  group("Clef", () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/assess-and-player-elements/
    test("should parse from '<assess> and <player>' example", () {
      String input = """
      <clef>
        <sign>G</sign>
        <line>2</line>
      </clef>
    """;

      Clef clef = Clef.fromXml(
        XmlDocument.parse(input).rootElement,
      );
      expect(clef.sign, ClefSign.G);
      expect(clef.line, 2);
      expect(clef.octaveChange, isNull);
      expect(clef.additional, isNull);
      expect(clef.afterBarline, isNull);
      expect(clef.id, isNull);
      expect(clef.number, 1);
      expect(clef.printObject, isTrue);
      expect(clef.size, isNull);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/concert-score-and-for-part-elements/
    test("should parse from '<concert-score> and <for-part>' example", () {
      String input = """
      <clef>
        <sign>F</sign>
        <line>4</line>
      </clef>
      """;

      Clef clef = Clef.fromXml(
        XmlDocument.parse(input).rootElement,
      );
      expect(clef.sign, ClefSign.F);
      expect(clef.line, 4);
      expect(clef.octaveChange, isNull);
      expect(clef.additional, isNull);
      expect(clef.afterBarline, isNull);
      expect(clef.id, isNull);
      expect(clef.number, 1);
      expect(clef.printObject, isTrue);
      expect(clef.size, isNull);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/measure-distance-element/
    test("should parse from '<measure-distance>' example", () {
      String input = """
        <clef print-object="yes">
          <sign>G</sign>
          <line>2</line>
        </clef>
      """;

      Clef clef = Clef.fromXml(
        XmlDocument.parse(input).rootElement,
      );
      expect(clef.sign, ClefSign.G);
      expect(clef.line, 2);
      expect(clef.octaveChange, isNull);
      expect(clef.additional, isNull);
      expect(clef.afterBarline, isNull);
      expect(clef.id, isNull);
      expect(clef.number, 1);
      expect(clef.printObject, isTrue);
      expect(clef.size, isNull);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/pedal-element-lines/
    test("should parse from '<pedal> (Lines)' example", () {
      String input = """
        <clef number="2">
          <sign>F</sign>
          <line>4</line>
        </clef>
      """;

      Clef clef = Clef.fromXml(
        XmlDocument.parse(input).rootElement,
      );
      expect(clef.sign, ClefSign.F);
      expect(clef.line, 4);
      expect(clef.octaveChange, isNull);
      expect(clef.additional, isNull);
      expect(clef.afterBarline, isNull);
      expect(clef.id, isNull);
      expect(clef.number, 2);
      expect(clef.printObject, isTrue);
      expect(clef.size, isNull);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/staff-type-element/
    test("should parse from '<staff-type>' example", () {
      String input = """
        <clef number="2">
          <sign>TAB</sign>
          <line>5</line>
        </clef>
      """;

      Clef clef = Clef.fromXml(
        XmlDocument.parse(input).rootElement,
      );
      expect(clef.sign, ClefSign.tab);
      expect(clef.line, 5);
      expect(clef.octaveChange, isNull);
      expect(clef.additional, isNull);
      expect(clef.afterBarline, isNull);
      expect(clef.id, isNull);
      expect(clef.number, 2);
      expect(clef.printObject, isTrue);
      expect(clef.size, isNull);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/bass-clef-down-octave/
    test("should parse from 'Bass Clef (Down Octave)' example", () {
      String input = """
        <clef>
          <sign>F</sign>
          <line>4</line>
          <clef-octave-change>-1</clef-octave-change>
        </clef>
      """;

      Clef clef = Clef.fromXml(
        XmlDocument.parse(input).rootElement,
      );
      expect(clef.sign, ClefSign.F);
      expect(clef.line, 4);
      expect(clef.octaveChange, -1);
      expect(clef.additional, isNull);
      expect(clef.afterBarline, isNull);
      expect(clef.id, isNull);
      expect(clef.number, 1);
      expect(clef.printObject, isTrue);
      expect(clef.size, isNull);
    });
    test("parsing should throw on incorrect sequence", () {
      String input = """
        <clef>
          <line>2</line>
          <sign>G</sign>
          <clef-octave-change>-1</clef-octave-change>
        </clef>
      """;

      expect(
        () => Clef.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlSequenceException>()),
      );
    });
    test("parsing should throw on invalid sign element content", () {
      String input = """
        <clef>
          <sign><foo></foo></sign>
          <line>2</line>
          <clef-octave-change>-1</clef-octave-change>
        </clef>
      """;

      expect(
        () => Clef.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("parsing should throw on invalid sign", () {
      String input = """
        <clef>
          <sign>foo</sign>
          <line>2</line>
          <clef-octave-change>-1</clef-octave-change>
        </clef>
      """;

      expect(
        () => Clef.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("parsing should throw on invalid line element content", () {
      String input = """
        <clef>
          <sign>G</sign>
          <line><foo></foo></line>
          <clef-octave-change>-1</clef-octave-change>
        </clef>
      """;

      expect(
        () => Clef.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("parsing should throw on invalid sign", () {
      String input = """
        <clef>
          <sign>G</sign>
          <line>foo</line>
          <clef-octave-change>-1</clef-octave-change>
        </clef>
      """;

      expect(
        () => Clef.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on invalid clef-octave-change element content",
        () {
      String input = """
        <clef>
          <sign>G</sign>
          <line>1</line>
          <clef-octave-change><foo></foo></clef-octave-change>
        </clef>
      """;

      expect(
        () => Clef.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("parsing should throw on invalid clef-octave-change", () {
      String input = """
        <clef>
          <sign>G</sign>
          <line>1</line>
          <clef-octave-change>foo</clef-octave-change>
        </clef>
      """;

      expect(
        () => Clef.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on invalid number attribute", () {
      String input = """
        <clef number="foo">
          <sign>G</sign>
          <line>1</line>
        </clef>
      """;

      expect(
        () => Clef.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on invalid size attribute", () {
      String input = """
        <clef size="foo">
          <sign>G</sign>
          <line>1</line>
        </clef>
      """;

      expect(
        () => Clef.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("parsing should throw on invalid print-object attribute", () {
      String input = """
        <clef print-object="foo">
          <sign>G</sign>
          <line>1</line>
        </clef>
      """;

      expect(
        () => Clef.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("parsing should throw on invalid after-barline attribute", () {
      String input = """
        <clef after-barline="foo">
          <sign>G</sign>
          <line>1</line>
        </clef>
      """;

      expect(
        () => Clef.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("parsing should throw on invalid additional attribute", () {
      String input = """
        <clef additional="foo">
          <sign>G</sign>
          <line>1</line>
        </clef>
      """;

      expect(
        () => Clef.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
  });
}
