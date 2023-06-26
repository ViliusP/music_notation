import 'package:music_notation/src/models/elements/music_data/layout.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group("Layout", () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/defaults-element/
    test("should parse <defaults> example correctly", () {
      String input = """
      <foo>
        <page-layout>
          <page-height>1553</page-height>
          <page-width>1200</page-width>
          <page-margins type="both">
            <left-margin>70</left-margin>
            <right-margin>70</right-margin>
            <top-margin>88</top-margin>
            <bottom-margin>88</bottom-margin>
          </page-margins>
        </page-layout>
        <system-layout>
          <system-margins>
            <left-margin>0</left-margin>
            <right-margin>0</right-margin>
          </system-margins>
          <system-distance>121</system-distance>
          <top-system-distance>70</top-system-distance>
        </system-layout>
      </foo>
      """;

      var layout = Layout.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(layout.page, isNotNull);
      expect(layout.system, isNotNull);
      expect(layout.staffs.length, 0);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/tutorial-chopin-prelude/
    test("should parse 'Tutorial: Chopin Prelude' example correctly", () {
      String input = """
      <foo>
        <page-layout>
          <page-height>1760</page-height>
          <page-width>1360</page-width>
          <page-margins type="both">
              <left-margin>80</left-margin>
              <right-margin>80</right-margin>
              <top-margin>80</top-margin>
              <bottom-margin>80</bottom-margin>
          </page-margins>
        </page-layout>
        <system-layout>
          <system-margins>
              <left-margin>0</left-margin>
              <right-margin>0</right-margin>
          </system-margins>
          <system-distance>130</system-distance>
          <top-system-distance>70</top-system-distance>
        </system-layout>
        <staff-layout>
          <staff-distance>60</staff-distance>
        </staff-layout>
      </foo>
      """;

      var layout = Layout.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(layout.page, isNotNull);
      expect(layout.system, isNotNull);
      expect(layout.staffs.length, 1);
    });

    group("page", () {
      // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/tutorial-chopin-prelude/
      test("should parse 'Tutorial: Chopin Prelude' example correctly", () {
        String input = """
          <page-layout>
            <page-height>1760</page-height>
            <page-width>1360</page-width>
            <page-margins type="both">
              <left-margin>80</left-margin>
              <right-margin>80</right-margin>
              <top-margin>80</top-margin>
              <bottom-margin>80</bottom-margin>
            </page-margins>
          </page-layout>
        """;

        var pageLayout = PageLayout.fromXml(
          XmlDocument.parse(input).rootElement,
        );

        expect(pageLayout.size?.height, 1760);
        expect(pageLayout.size?.width, 1360);
        expect(pageLayout.margins.length, 1);
        expect(pageLayout.margins[0].type, MarginType.both);
      });

      test("should throw on missing height and existing width", () {
        String input = """
          <page-layout>
            <page-width>1360</page-width>
            <page-margins type="both">
              <left-margin>80</left-margin>
              <right-margin>80</right-margin>
              <top-margin>80</top-margin>
              <bottom-margin>80</bottom-margin>
            </page-margins>
          </page-layout>
        """;

        expect(
          () => PageLayout.fromXml(
            XmlDocument.parse(input).rootElement,
          ),
          throwsA(isA<XmlSequenceException>()),
        );
      });
      test("should throw on missing width and existing height", () {
        String input = """
          <page-layout>
            <page-height>1760</page-height>
            <page-margins type="both">
              <left-margin>80</left-margin>
              <right-margin>80</right-margin>
              <top-margin>80</top-margin>
              <bottom-margin>80</bottom-margin>
            </page-margins>
          </page-layout>
        """;

        expect(
          () => PageLayout.fromXml(
            XmlDocument.parse(input).rootElement,
          ),
          throwsA(isA<XmlSequenceException>()),
        );
      });
      test("should throw on invalid height", () {
        String input = """
          <page-layout>
            <page-height>foo</page-height>
            <page-width>1360</page-width>
            <page-margins type="both">
              <left-margin>80</left-margin>
              <right-margin>80</right-margin>
              <top-margin>80</top-margin>
              <bottom-margin>80</bottom-margin>
            </page-margins>
          </page-layout>
        """;

        expect(
          () => PageLayout.fromXml(
            XmlDocument.parse(input).rootElement,
          ),
          throwsA(isA<MusicXmlFormatException>()),
        );
      });
      test("should throw on invalid width", () {
        String input = """
          <page-layout>
            <page-height>1</page-height>
            <page-width>foo</page-width>
            <page-margins type="both">
              <left-margin>80</left-margin>
              <right-margin>80</right-margin>
              <top-margin>80</top-margin>
              <bottom-margin>80</bottom-margin>
            </page-margins>
          </page-layout>
        """;

        expect(
          () => PageLayout.fromXml(
            XmlDocument.parse(input).rootElement,
          ),
          throwsA(isA<MusicXmlFormatException>()),
        );
      });
      test("should throw on three page margins", () {
        String input = """
          <page-layout>
            <page-margins type="both">
              <left-margin>80</left-margin>
              <right-margin>80</right-margin>
              <top-margin>80</top-margin>
              <bottom-margin>80</bottom-margin>
            </page-margins>
            <page-margins type="both">
              <left-margin>80</left-margin>
              <right-margin>80</right-margin>
              <top-margin>80</top-margin>
              <bottom-margin>80</bottom-margin>
            </page-margins>
            <page-margins type="both">
              <left-margin>80</left-margin>
              <right-margin>80</right-margin>
              <top-margin>80</top-margin>
              <bottom-margin>80</bottom-margin>
            </page-margins>            
          </page-layout>
        """;

        expect(
          () => PageLayout.fromXml(
            XmlDocument.parse(input).rootElement,
          ),
          throwsA(isA<InvalidXmlSequence>()),
        );
      });
    });
    group("system", () {});
    group("staff", () {});
  });

  group("page-margins", () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/defaults-element/
    test("should parse '<defaults>' example correctly", () {
      String input = """
          <page-margins type="both">
            <left-margin>70</left-margin>
            <right-margin>70</right-margin>
            <top-margin>88</top-margin>
            <bottom-margin>88</bottom-margin>
          </page-margins>
        """;

      var pageLayout = PageMargins.fromXml(
        XmlDocument.parse(input).rootElement,
        false,
      );

      expect(pageLayout.margins.left, 70);
      expect(pageLayout.margins.right, 70);
      expect(pageLayout.margins.top, 88);
      expect(pageLayout.margins.bottom, 88);
      expect(pageLayout.type, MarginType.both);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/tutorial-apres-un-reve/
    test("should parse 'Tutorial: Après un rêve' example correctly", () {
      String input = """
          <page-margins type="both">
            <left-margin>80</left-margin>
            <right-margin>80</right-margin>
            <top-margin>80</top-margin>
            <bottom-margin>80</bottom-margin>
          </page-margins>
        """;

      var pageLayout = PageMargins.fromXml(
        XmlDocument.parse(input).rootElement,
        false,
      );

      expect(pageLayout.margins.left, 80);
      expect(pageLayout.margins.right, 80);
      expect(pageLayout.margins.top, 80);
      expect(pageLayout.margins.bottom, 80);
      expect(pageLayout.type, MarginType.both);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/tutorial-chopin-prelude/
    test(
        "should parse print margins from 'Tutorial: Chopin Prelude' example correctly",
        () {
      String input = """
        <page-margins>
          <left-margin>80</left-margin>
          <right-margin>703</right-margin>
          <top-margin>80</top-margin>
          <bottom-margin>80</bottom-margin>
        </page-margins>
        """;

      var pageLayout = PageMargins.fromXml(
        XmlDocument.parse(input).rootElement,
        true,
      );

      expect(pageLayout.margins.left, 80);
      expect(pageLayout.margins.right, 703);
      expect(pageLayout.margins.top, 80);
      expect(pageLayout.margins.bottom, 80);
      expect(pageLayout.type, null);
    });
    test("should parse custom page-margins example correctly", () {
      String input = """
        <page-margins type="even">
          <left-margin>1</left-margin>
          <right-margin>2</right-margin>
          <top-margin>3</top-margin>
          <bottom-margin>4</bottom-margin>
        </page-margins>
        """;

      var pageLayout = PageMargins.fromXml(
        XmlDocument.parse(input).rootElement,
        false,
      );

      expect(pageLayout.margins.left, 1);
      expect(pageLayout.margins.right, 2);
      expect(pageLayout.margins.top, 3);
      expect(pageLayout.margins.bottom, 4);
      expect(pageLayout.type, MarginType.even);
    });
    test("if not specified, margin type should be both", () {
      String input = """
        <page-margins>
          <left-margin>1</left-margin>
          <right-margin>2</right-margin>
          <top-margin>3</top-margin>
          <bottom-margin>4</bottom-margin>
        </page-margins>
        """;

      var pageLayout = PageMargins.fromXml(
        XmlDocument.parse(input).rootElement,
        false,
      );

      expect(pageLayout.margins.left, 1);
      expect(pageLayout.margins.right, 2);
      expect(pageLayout.margins.top, 3);
      expect(pageLayout.margins.bottom, 4);
      expect(pageLayout.type, MarginType.both);
    });
    test("should throw if left margin is missing", () {
      String input = """
        <page-margins>
          <right-margin>2</right-margin>
          <top-margin>3</top-margin>
          <bottom-margin>4</bottom-margin>
        </page-margins>
        """;

      expect(
        () => PageMargins.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlSequenceException>()),
      );
    });
    test("should throw if left margin is invalid", () {
      String input = """
        <page-margins>
          <left-margin>foo</left-margin>
          <right-margin>2</right-margin>
          <top-margin>3</top-margin>
          <bottom-margin>4</bottom-margin>
        </page-margins>
        """;

      expect(
        () => PageMargins.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("should throw if left margin is empty", () {
      String input = """
        <page-margins>
          <left-margin></left-margin>
          <right-margin>2</right-margin>
          <top-margin>3</top-margin>
          <bottom-margin>4</bottom-margin>
        </page-margins>
        """;

      expect(
        () => PageMargins.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("should throw if right margin is missing", () {
      String input = """
        <page-margins>
          <left-margin>1</left-margin>
          <top-margin>3</top-margin>
          <bottom-margin>4</bottom-margin>
        </page-margins>
        """;

      expect(
        () => PageMargins.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlSequenceException>()),
      );
    });
    test("should throw if right margin is invalid", () {
      String input = """
        <page-margins>
          <left-margin>1</left-margin>
          <right-margin>foo</right-margin>
          <top-margin>3</top-margin>
          <bottom-margin>4</bottom-margin>
        </page-margins>
        """;

      expect(
        () => PageMargins.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("should throw if right margin is empty", () {
      String input = """
        <page-margins>
          <left-margin>1</left-margin>
          <right-margin></right-margin>
          <top-margin>3</top-margin>
          <bottom-margin>4</bottom-margin>
        </page-margins>
        """;

      expect(
        () => PageMargins.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("should throw if 'top margin' element is missing", () {
      String input = """
        <page-margins>
          <left-margin>1</left-margin>
          <right-margin>2</right-margin>
          <bottom-margin>4</bottom-margin>
        </page-margins>
        """;

      expect(
        () => PageMargins.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlSequenceException>()),
      );
    });
    test("should throw if top margin is invalid", () {
      String input = """
        <page-margins>
          <left-margin>1</left-margin>
          <right-margin>2</right-margin>
          <top-margin>foo</top-margin>
          <bottom-margin>4</bottom-margin>
        </page-margins>
        """;

      expect(
        () => PageMargins.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("should throw if top margin is empty", () {
      String input = """
        <page-margins>
          <left-margin>1</left-margin>
          <right-margin>2</right-margin>
          <top-margin></top-margin>
          <bottom-margin>4</bottom-margin>
        </page-margins>
        """;

      expect(
        () => PageMargins.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("should throw if bottom margin is missing", () {
      String input = """
        <page-margins>
          <left-margin>1</left-margin>
          <right-margin>2</right-margin>
          <top-margin>3</top-margin>
        </page-margins>
        """;

      expect(
        () => PageMargins.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlSequenceException>()),
      );
    });
    test("should throw if bottom margin is invalid", () {
      String input = """
        <page-margins>
          <left-margin>1</left-margin>
          <right-margin>2</right-margin>
          <top-margin>3</top-margin>
          <bottom-margin>foo</bottom-margin>
        </page-margins>
        """;

      expect(
        () => PageMargins.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("should throw if bottom margin is empty", () {
      String input = """
        <page-margins>
          <left-margin>1</left-margin>
          <right-margin>2</right-margin>
          <top-margin>3</top-margin>
          <bottom-margin></bottom-margin>
        </page-margins>
        """;

      expect(
        () => PageMargins.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
  });
}
