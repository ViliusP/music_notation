import 'package:music_notation/src/models/elements/music_data/attributes/time.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group("Time beat", () {});
  group("Interchangeable", () {});

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
