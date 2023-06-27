import 'package:music_notation/src/models/elements/layout.dart';
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
          throwsA(isA<XmlSequenceException>()),
        );
      });
    });
    group("system", () {
      // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/attributes-element/
      test("should parse '<attributes>' example", () {
        String input = """
          <system-layout>
            <system-margins>
              <left-margin>70</left-margin>
              <right-margin>0</right-margin>
            </system-margins>
            <top-system-distance>211</top-system-distance>
          </system-layout>
        """;

        var systemLayout = SystemLayout.fromXml(
          XmlDocument.parse(input).rootElement,
        );

        expect(systemLayout.margins?.left, 70);
        expect(systemLayout.margins?.right, 0);
        expect(systemLayout.distance, null);
        expect(systemLayout.topDistance, 211);
        expect(systemLayout.dividers, null);
      });
      // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/defaults-element/
      test("should parse '<defaults>' example", () {
        String input = """
          <system-layout>
            <system-margins>
              <left-margin>0</left-margin>
              <right-margin>0</right-margin>
            </system-margins>
            <system-distance>121</system-distance>
            <top-system-distance>70</top-system-distance>
          </system-layout>
        """;

        var systemLayout = SystemLayout.fromXml(
          XmlDocument.parse(input).rootElement,
        );

        expect(systemLayout.margins?.left, 0);
        expect(systemLayout.margins?.right, 0);
        expect(systemLayout.distance, 121);
        expect(systemLayout.topDistance, 70);
        expect(systemLayout.dividers, null);
      });
      // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/system-dividers-element/
      test("should parse '<system-dividers>' example", () {
        String input = """
          <system-layout>
            <system-margins>
              <left-margin>0</left-margin>
              <right-margin>0</right-margin>
            </system-margins>
            <system-distance>96</system-distance>
            <top-system-distance>45</top-system-distance>
            <system-dividers>
              <left-divider print-object="yes"/>
              <right-divider print-object="yes"/>
            </system-dividers>
          </system-layout>
        """;

        var systemLayout = SystemLayout.fromXml(
          XmlDocument.parse(input).rootElement,
        );

        expect(systemLayout.margins?.left, 0);
        expect(systemLayout.margins?.right, 0);
        expect(systemLayout.distance, 96);
        expect(systemLayout.topDistance, 45);
        expect(systemLayout.dividers?.left.printObject, true);
        expect(systemLayout.dividers?.right.printObject, true);
      });
      test("should throw on invalid order of elements", () {
        String input = """
          <system-layout>
            <system-distance>96</system-distance>
            <system-margins>
              <left-margin>0</left-margin>
              <right-margin>0</right-margin>
            </system-margins>
            <system-dividers>
              <left-divider print-object="yes"/>
              <right-divider print-object="yes"/>
            </system-dividers>
            <top-system-distance>45</top-system-distance>
          </system-layout>
        """;

        expect(
          () => SystemLayout.fromXml(
            XmlDocument.parse(input).rootElement,
          ),
          throwsA(isA<XmlSequenceException>()),
        );
      });
      test("should throw on empty distance", () {
        String input = """
          <system-layout>
            <system-distance></system-distance>
          </system-layout>
        """;

        expect(
          () => SystemLayout.fromXml(
            XmlDocument.parse(input).rootElement,
          ),
          throwsA(isA<MusicXmlFormatException>()),
        );
      });
      test("should throw on invalid distance", () {
        String input = """
          <system-layout>
            <system-distance>foo</system-distance>
          </system-layout>
        """;

        expect(
          () => SystemLayout.fromXml(
            XmlDocument.parse(input).rootElement,
          ),
          throwsA(isA<MusicXmlFormatException>()),
        );
      });
      test("should throw on invalid distance content", () {
        String input = """
          <system-layout>
            <system-distance><foo></foo></system-distance>
          </system-layout>
        """;

        expect(
          () => SystemLayout.fromXml(
            XmlDocument.parse(input).rootElement,
          ),
          throwsA(isA<XmlElementContentException>()),
        );
      });
      test("should throw on empty top distance", () {
        String input = """
          <system-layout>
            <top-system-distance></top-system-distance>
          </system-layout>
        """;

        expect(
          () => SystemLayout.fromXml(
            XmlDocument.parse(input).rootElement,
          ),
          throwsA(isA<MusicXmlFormatException>()),
        );
      });
      test("should throw on invalid top distance", () {
        String input = """
          <system-layout>
            <top-system-distance>foo</top-system-distance>
          </system-layout>
        """;

        expect(
          () => SystemLayout.fromXml(
            XmlDocument.parse(input).rootElement,
          ),
          throwsA(isA<MusicXmlFormatException>()),
        );
      });
      test("should throw on invalid top distance content", () {
        String input = """
          <system-layout>
            <top-system-distance><foo></foo></top-system-distance>
          </system-layout>
        """;

        expect(
          () => SystemLayout.fromXml(
            XmlDocument.parse(input).rootElement,
          ),
          throwsA(isA<XmlElementContentException>()),
        );
      });
      // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/system-dividers-element/
      test("should parse '<system-dividers>' example correctly  ", () {
        String input = """
          <system-dividers>
              <left-divider print-object="yes"/>
              <right-divider print-object="yes"/>
          </system-dividers>
        """;

        SystemDividers systemDividers = SystemDividers.fromXml(
          XmlDocument.parse(input).rootElement,
        );

        expect(systemDividers.left.printObject, true);
        expect(systemDividers.right.printObject, true);
      });
      test("should throw on invalid dividers print object", () {
        String input = """
          <system-dividers>
              <left-divider print-object="foo"/>
              <right-divider print-object="bar"/>
          </system-dividers>
        """;

        expect(
          () => SystemDividers.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MusicXmlTypeException>()),
        );
      });
      test("should throw missing left-divider", () {
        String input = """
          <system-dividers>
              <right-divider print-object="yes"/>
          </system-dividers>
        """;

        expect(
          () => SystemDividers.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<XmlSequenceException>()),
        );
      });
      test("should throw missing right-divider", () {
        String input = """
          <system-dividers>
              <left-divider print-object="yes"/>
          </system-dividers>
        """;

        expect(
          () => SystemDividers.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<XmlSequenceException>()),
        );
      });
    });
    group("staff", () {
      // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/pedal-element-lines/
      test("should parse '<pedal> (Lines)' example", () {
        String input = """
          <staff-layout number="2">
            <staff-distance>60</staff-distance>
          </staff-layout>
        """;

        var staffLayout = StaffLayout.fromXml(
          XmlDocument.parse(input).rootElement,
        );

        expect(staffLayout.number, 2);
        expect(staffLayout.distance, 60);
      });
      // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/tutorial-apres-un-reve/
      test("should parse 'Tutorial: Après un rêve' example", () {
        String input = """
          <staff-layout>
            <staff-distance>80</staff-distance>
          </staff-layout>
        """;

        var staffLayout = StaffLayout.fromXml(
          XmlDocument.parse(input).rootElement,
        );

        expect(staffLayout.number, 1);
        expect(staffLayout.distance, 80);
      });
      test("should throw on invalid staff-distance content", () {
        String input = """
          <staff-layout>
            <staff-distance><foo></foo></staff-distance>
          </staff-layout>
        """;

        expect(
          () => StaffLayout.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<XmlElementContentException>()),
        );
      });
      test("should throw on invalid staff-distance", () {
        String input = """
          <staff-layout>
            <staff-distance>foo</staff-distance>
          </staff-layout>
        """;

        expect(
          () => StaffLayout.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MusicXmlFormatException>()),
        );
      });
      test("should throw on empty staff-distance", () {
        String input = """
          <staff-layout>
            <staff-distance></staff-distance>
          </staff-layout>
        """;

        expect(
          () => StaffLayout.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MusicXmlFormatException>()),
        );
      });
      test("should throw on invalid staff number", () {
        String input = """
          <staff-layout number="foo">
            <staff-distance>1</staff-distance>
          </staff-layout>
        """;

        expect(
          () => StaffLayout.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MusicXmlFormatException>()),
        );
      });
      test("should throw on empty staff number", () {
        String input = """
          <staff-layout number="">
            <staff-distance>1</staff-distance>
          </staff-layout>
        """;

        expect(
          () => StaffLayout.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MusicXmlFormatException>()),
        );
      });
    });
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
        throwsA(isA<MusicXmlFormatException>()),
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
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("should throw if left margin content is invalid", () {
      String input = """
        <page-margins>
          <left-margin><foo></foo></left-margin>
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
        throwsA(isA<MusicXmlFormatException>()),
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
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("should throw if right margin content is invalid", () {
      String input = """
        <page-margins>
          <left-margin>1</left-margin>
          <right-margin><foo></foo></right-margin>
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
        throwsA(isA<MusicXmlFormatException>()),
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
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("should throw if top margin content is invalid", () {
      String input = """
        <page-margins>
          <left-margin>1</left-margin>
          <right-margin>2</right-margin>
          <top-margin><foo></foo></top-margin>
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
        throwsA(isA<MusicXmlFormatException>()),
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
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("should throw if bottom margin content is invalid", () {
      String input = """
        <page-margins>
          <left-margin>1</left-margin>
          <right-margin>2</right-margin>
          <top-margin>3</top-margin>
          <bottom-margin><foo></foo></bottom-margin>
        </page-margins>
        """;

      expect(
        () => PageMargins.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("should throw on invalid margin type", () {
      String input = """
        <page-margins type="foo">
          <left-margin>1</left-margin>
          <right-margin>2</right-margin>
          <top-margin>3</top-margin>
          <bottom-margin></bottom-margin>
        </page-margins>
        """;

      expect(
        () => PageMargins.fromXml(
          XmlDocument.parse(input).rootElement,
          false,
        ),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
  });
}
