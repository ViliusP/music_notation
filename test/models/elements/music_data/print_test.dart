import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/elements/music_data/print.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

void main() {
  group("Print", () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/attributes-element/
    test("should parse '<attributes>' example", () {
      String input = """
        <print>
          <system-layout>
            <system-margins>
              <left-margin>70</left-margin>
              <right-margin>0</right-margin>
            </system-margins>
            <top-system-distance>211</top-system-distance>
          </system-layout>
          <measure-numbering>system</measure-numbering>
        </print>
      """;

      var print = Print.fromXml(XmlDocument.parse(input).rootElement);

      expect(print.attributes.blankPage, isNull);
      expect(print.attributes.newPage, isNull);
      expect(print.attributes.newSystem, isNull);
      expect(print.attributes.pageNumber, isNull);

      expect(print.layout.system, isNotNull);
      expect(print.layout.page, isNull);
      expect(print.layout.staffs, isEmpty);

      expect(print.measureNumbering, isNotNull);
      expect(print.id, isNull);
      expect(print.measureDistance, isNull);
      expect(print.partAbbreviationDisplay, isNull);
      expect(print.partNameDisplay, isNull);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/measure-distance-element/
    test("should parse '<measure-distance>' example", () {
      String input = """
        <print>
          <measure-layout>
            <measure-distance>118</measure-distance>
          </measure-layout>
        </print>
      """;

      var print = Print.fromXml(XmlDocument.parse(input).rootElement);

      expect(print.attributes.blankPage, isNull);
      expect(print.attributes.newPage, isNull);
      expect(print.attributes.newSystem, isNull);
      expect(print.attributes.pageNumber, isNull);

      expect(print.layout.system, isNull);
      expect(print.layout.page, isNull);
      expect(print.layout.staffs, isEmpty);

      expect(print.measureNumbering, isNull);
      expect(print.id, isNull);
      expect(print.measureDistance, 118);
      expect(print.partAbbreviationDisplay, isNull);
      expect(print.partNameDisplay, isNull);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/instrument-change-element/
    test("should parse '<instrument-change>' example", () {
      String input = """
         <print new-system="yes">
            <part-name-display>
              <display-text>Alto Sax</display-text>
            </part-name-display>
            <part-abbreviation-display>
              <display-text>A. Sx.</display-text>
            </part-abbreviation-display>
         </print>
      """;

      var print = Print.fromXml(XmlDocument.parse(input).rootElement);

      expect(print.attributes.blankPage, isNull);
      expect(print.attributes.newPage, isNull);
      expect(print.attributes.newSystem, true);
      expect(print.attributes.pageNumber, isNull);

      expect(print.layout.system, isNull);
      expect(print.layout.page, isNull);
      expect(print.layout.staffs, isEmpty);

      expect(print.measureNumbering, isNull);
      expect(print.id, isNull);
      expect(print.measureDistance, isNull);
      expect(print.partAbbreviationDisplay, isNotNull);
      expect(print.partNameDisplay, isNotNull);
    });
    test("should parse 'Tutorial: Percussion' example", () {
      String input = """
        <print>
          <page-layout>
            <page-height>1545</page-height>
            <page-width>1194</page-width>
            <page-margins>
              <left-margin>70</left-margin>
              <right-margin>461</right-margin>
              <top-margin>88</top-margin>
              <bottom-margin>88</bottom-margin>
            </page-margins>
          </page-layout>
          <system-layout>
            <system-margins>
              <left-margin>60</left-margin>
              <right-margin>0</right-margin>
            </system-margins>
            <top-system-distance>211</top-system-distance>
          </system-layout>
          <measure-numbering>system</measure-numbering>
        </print>
      """;

      var print = Print.fromXml(XmlDocument.parse(input).rootElement);

      expect(print.attributes.blankPage, isNull);
      expect(print.attributes.newPage, isNull);
      expect(print.attributes.newSystem, isNull);
      expect(print.attributes.pageNumber, isNull);

      expect(print.layout.system, isNotNull);
      expect(print.layout.page, isNotNull);
      expect(print.layout.staffs, isEmpty);

      expect(print.measureNumbering?.value, MeasureNumberingValue.system);
      expect(print.id, isNull);
      expect(print.measureDistance, isNull);
      expect(print.partAbbreviationDisplay, isNull);
      expect(print.partNameDisplay, isNull);
    });
    test("parsing should throw on wrong order", () {
      String input = """
        <print>
          <measure-numbering>system</measure-numbering>
          <measure-layout>
            <measure-distance>118</measure-distance>
          </measure-layout>
        </print>
      """;

      expect(
        () => Print.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlSequenceException>()),
      );
    });
    test("parsing should throw on invalid measure-distance content", () {
      String input = """
        <print>
          <measure-layout>
            <measure-distance><foo></foo></measure-distance>
          </measure-layout>
        </print>
      """;

      expect(
        () => Print.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("parsing should throw on invalid measure-distance value", () {
      String input = """
        <print>
          <measure-layout>
            <measure-distance>foo</measure-distance>
          </measure-layout>
        </print>
      """;

      expect(
        () => Print.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
  });
  group("Print attribute", () {
    test("parsing should throw on invalid blank page", () {
      String input = """
          <print blank-page="foo"/>
        """;

      expect(
        () => Print.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on negative blank page", () {
      String input = """
          <print blank-page="-1"/>
        """;

      expect(
        () => Print.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on invalid staff-spacing value", () {
      String input = """
          <print staff-spacing="foo"/>
        """;

      expect(
        () => Print.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on page-number value", () {
      String input = """
          <print page-number="foo"/>
        """;

      expect(
        () => Print.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on new-system value", () {
      String input = """
          <print new-system="foo"/>
        """;

      expect(
        () => Print.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("parsing should throw on new-page value", () {
      String input = """
          <print new-page="foo"/>
        """;

      expect(
        () => Print.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
  });

  group("measure-content", () {
    test("parsing should throw on invalid content", () {
      String input = """
          <measure-numbering><foo></foo></measure-numbering>
        """;

      expect(
        () => MeasureNumbering.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("parsing should throw on empty content", () {
      String input = """
          <measure-numbering></measure-numbering>
        """;

      expect(
        () => MeasureNumbering.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("parsing should throw on invalid value", () {
      String input = """
          <measure-numbering>foofoo</measure-numbering>
        """;

      expect(
        () => MeasureNumbering.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("parsing should throw on invalid staff attribute", () {
      String input = """
          <measure-numbering staff="foo">none</measure-numbering>
        """;

      expect(
        () => MeasureNumbering.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on invalid multiple rest range attribute", () {
      String input = """
          <measure-numbering multiple-rest-range="foo">none</measure-numbering>
        """;

      expect(
        () => MeasureNumbering.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("parsing should throw on invalid multiple rest always attribute", () {
      String input = """
          <measure-numbering multiple-rest-always="foo">none</measure-numbering>
        """;

      expect(
        () => MeasureNumbering.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("parsing should throw on system attribute", () {
      String input = """
          <measure-numbering system="foo">none</measure-numbering>
        """;

      expect(
        () => MeasureNumbering.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
  });
}
