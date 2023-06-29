import 'package:music_notation/src/models/elements/music_data/attributes/time.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group("Time beat", () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/beats-element/
    test("should parse '<beats>' example", () {
      String input = """
        <time>
          <beats>3</beats>
          <beat-type>4</beat-type>
        </time>
      """;

      Time time = Time.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(time.id, isNull);
      expect(time.number, isNull);
      expect(time.printObject, true);
      expect(time.separator, TimeSeparator.none);
      expect(time.symbol, TimeSymbol.normal);
      expect(time, isA<TimeBeat>());

      TimeBeat timeBeat = time as TimeBeat;
      expect(timeBeat.timeSignatures.length, 1);
      expect(timeBeat.timeSignatures[0].beats, "3");
      expect(timeBeat.timeSignatures[0].beatType, "4");
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/barline-element/
    test("should parse '<barline>' example", () {
      String input = """
        <time>
          <beats>3 + 2 + 4</beats>
          <beat-type>8</beat-type>
        </time>
      """;

      Time time = Time.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(time.id, isNull);
      expect(time.number, isNull);
      expect(time.printObject, true);
      expect(time.separator, TimeSeparator.none);
      expect(time.symbol, TimeSymbol.normal);
      expect(time, isA<TimeBeat>());

      TimeBeat timeBeat = time as TimeBeat;
      expect(timeBeat.timeSignatures.length, 1);
      expect(timeBeat.timeSignatures[0].beats, "3 + 2 + 4");
      expect(timeBeat.timeSignatures[0].beatType, "8");
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/unpitched-element/
    test("should parse '<unpitched>' example", () {
      String input = """
        <time symbol="common">
          <beats>4</beats>
          <beat-type>4</beat-type>
        </time>
      """;

      Time time = Time.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(time.id, isNull);
      expect(time.number, isNull);
      expect(time.printObject, true);
      expect(time.separator, TimeSeparator.none);
      expect(time.symbol, TimeSymbol.common);
      expect(time, isA<TimeBeat>());

      TimeBeat timeBeat = time as TimeBeat;
      expect(timeBeat.timeSignatures.length, 1);
      expect(timeBeat.timeSignatures[0].beats, "4");
      expect(timeBeat.timeSignatures[0].beatType, "4");
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/tutorial-tablature/
    test("should parse 'Tutorial: Tablature' example", () {
      String input = """
        <time print-object="no">
          <beats>4</beats>
          <beat-type>4</beat-type>
        </time>
      """;

      Time time = Time.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(time.id, isNull);
      expect(time.number, isNull);
      expect(time.printObject, false);
      expect(time.separator, TimeSeparator.none);
      expect(time.symbol, TimeSymbol.normal);
      expect(time, isA<TimeBeat>());

      TimeBeat timeBeat = time as TimeBeat;
      expect(timeBeat.timeSignatures.length, 1);
      expect(timeBeat.timeSignatures[0].beats, "4");
      expect(timeBeat.timeSignatures[0].beatType, "4");
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/double-element/
    test("should parse '<double>' example", () {
      String input = """
        <time symbol="cut">
          <beats>2</beats>
          <beat-type>2</beat-type>
        </time>
      """;

      Time time = Time.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(time.id, isNull);
      expect(time.number, isNull);
      expect(time.printObject, true);
      expect(time.separator, TimeSeparator.none);
      expect(time.symbol, TimeSymbol.cut);
      expect(time, isA<TimeBeat>());

      TimeBeat timeBeat = time as TimeBeat;
      expect(timeBeat.timeSignatures.length, 1);
      expect(timeBeat.timeSignatures[0].beats, "2");
      expect(timeBeat.timeSignatures[0].beatType, "2");
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/interchangeable-element/
    test("should parse '<interchangeable>' example", () {
      String input = """
        <time>
          <beats>3</beats>
          <beat-type>4</beat-type>
          <interchangeable>
            <beats>6</beats>
            <beat-type>8</beat-type>
            <time-relation>equals</time-relation>
          </interchangeable>
        </time>
      """;

      Time time = Time.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(time.id, isNull);
      expect(time.number, isNull);
      expect(time.printObject, true);
      expect(time.separator, TimeSeparator.none);
      expect(time.symbol, TimeSymbol.normal);
      expect(time, isA<TimeBeat>());

      TimeBeat timeBeat = time as TimeBeat;
      expect(timeBeat.timeSignatures.length, 1);
      expect(timeBeat.timeSignatures[0].beats, "3");
      expect(timeBeat.timeSignatures[0].beatType, "4");
      expect(timeBeat.interchangeable, isNotNull);
    });
    test("parsing should throw on invalid sequence", () {
      String input = """
        <time symbol="cut">
          <beat-type>2</beat-type>
          <beats>2</beats>
        </time>
      """;

      expect(
        () => Time.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("parsing should throw on invalid beats content", () {
      String input = """
        <time>
          <beats><foo></foo></beats>
          <beat-type>8</beat-type>
        </time>
      """;

      expect(
        () => Time.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("parsing should throw on invalid beat-type content", () {
      String input = """
        <time>
          <beats>4</beats>
          <beat-type><foo></foo></beat-type>
        </time>
      """;

      expect(
        () => Time.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
  });
  group("Interchangeable", () {
    test("should parse '<interchangeable>' example", () {
      String input = """
        <interchangeable>
          <beats>6</beats>
          <beat-type>8</beat-type>
          <time-relation>equals</time-relation>
        </interchangeable>
      """;

      Interchangeable interchangeable = Interchangeable.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(interchangeable.timeSignatures.length, 1);
      expect(interchangeable.timeSignatures[0].beats, "6");
      expect(interchangeable.timeSignatures[0].beatType, "8");
      expect(interchangeable.timeRelation, TimeRelation.equals);
    });
    test("parsing should throw on wrong sequence", () {
      String input = """
        <interchangeable>
          <beat-type>8</beat-type>
          <beats>6</beats>
          <time-relation>equals</time-relation>
        </interchangeable>
      """;

      expect(
        () => Interchangeable.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlSequenceException>()),
      );
    });
    test("parsing should throw on invalid beats content", () {
      String input = """
        <interchangeable>
          <beats><foo></foo></beats>
          <beat-type>8</beat-type>
          <time-relation>equals</time-relation>
        </interchangeable>
      """;

      expect(
        () => Interchangeable.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("parsing should throw on invalid beat-type content", () {
      String input = """
        <interchangeable>
          <beats>4</beats>
          <beat-type><foo></foo></beat-type>
          <time-relation>equals</time-relation>
        </interchangeable>
      """;

      expect(
        () => Interchangeable.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("parsing should throw on invalid time-relation content", () {
      String input = """
        <interchangeable>
          <beats>4</beats>
          <beat-type>2</beat-type>
          <time-relation>foo</time-relation>
        </interchangeable>
      """;

      expect(
        () => Interchangeable.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
  });
  group("Senza Misura", () {
    test("should parse '<senza-misura>' example", () {
      String input = """
        <time>
          <senza-misura/>
        </time>
      """;

      Time time = Time.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(time.id, isNull);
      expect(time.number, isNull);
      expect(time.printObject, true);
      expect(time.separator, TimeSeparator.none);
      expect(time.symbol, TimeSymbol.normal);
      expect(time, isA<SenzaMisura>());

      SenzaMisura senzaMisura = time as SenzaMisura;
      expect(senzaMisura.content, isEmpty);
    });
    test("should parse with 'X' content", () {
      String input = """
        <time>
          <senza-misura>X</senza-misura>
        </time>
      """;

      Time time = Time.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(time.id, isNull);
      expect(time.number, isNull);
      expect(time.printObject, true);
      expect(time.separator, TimeSeparator.none);
      expect(time.symbol, TimeSymbol.normal);
      expect(time, isA<SenzaMisura>());

      SenzaMisura senzaMisura = time as SenzaMisura;
      expect(senzaMisura.content, "X");
    });
    test("parsing should throw on invalid print object value", () {
      String input = """
        <time print-object="foo">
          <senza-misura >X</senza-misura>
        </time>
      """;

      expect(
        () => Time.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("parsing should throw on invalid content", () {
      String input = """
        <time print-object="no">
          <senza-misura ><foo></foo></senza-misura>
        </time>
      """;

      expect(
        () => Time.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("parsing should throw on invalid number", () {
      String input = """
        <time number="foo" print-object="no">
          <senza-misura/>
        </time>
      """;

      expect(
        () => Time.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on invalid symbol", () {
      String input = """
        <time symbol="foo" print-object="no">
          <senza-misura/>
        </time>
      """;

      expect(
        () => Time.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("parsing should throw on invalid separator", () {
      String input = """
        <time separator="foo" print-object="no">
          <senza-misura/>
        </time>
      """;

      expect(
        () => Time.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
  });
}
