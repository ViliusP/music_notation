import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/elements/score/defaults.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

void main() {
  group("Appearance -", () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/defaults-element/
    test("should parse 'defaults' example", () {
      String input = """
        <appearance>
          <line-width type="stem">0.7487</line-width>
          <line-width type="beam">5</line-width>
          <line-width type="staff">0.7487</line-width>
          <line-width type="light barline">0.7487</line-width>
          <line-width type="heavy barline">5</line-width>
          <line-width type="leger">0.7487</line-width>
          <line-width type="ending">0.7487</line-width>
          <line-width type="wedge">0.7487</line-width>
          <line-width type="enclosure">0.7487</line-width>
          <line-width type="tuplet bracket">0.7487</line-width>
          <note-size type="grace">65</note-size>
          <note-size type="cue">65</note-size>
          <note-size type="grace-cue">50</note-size>
          <note-size type="large">120</note-size>
          <distance type="hyphen">120</distance>
          <distance type="beam">7.5</distance>
          <glyph type="percussion-clef">unpitchedPercussionClef1</glyph>
        </appearance>
        """;

      var appearance = Appearance.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(appearance.lineWidths.length, 10);
      expect(appearance.noteSizes.length, 4);
      expect(appearance.distances.length, 2);
      expect(appearance.glyphs.length, 1);
      expect(appearance.other.length, 0);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/glyph-element/
    test("should parse '<glyph>' example", () {
      String input = """
        <appearance>
          <line-width type="stem">0.8333</line-width>
          <line-width type="staff">1.25</line-width>
          <line-width type="light barline">1.875</line-width>
          <line-width type="leger">1.875</line-width>
          <glyph type="f-clef">fClef19thCentury</glyph>
          <glyph type="quarter-rest">restQuarterOld</glyph>
        </appearance>
      """;

      var appearance = Appearance.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(appearance.lineWidths.length, 4);
      expect(appearance.noteSizes.length, 0);
      expect(appearance.distances.length, 0);
      expect(appearance.glyphs.length, 2);
      expect(appearance.other.length, 0);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/tutorial-tablature/
    test("should parse 'Tutorial: Tablature' example", () {
      String input = """
        <appearance>
          <line-width type="stem">0.8333</line-width>
          <line-width type="beam">5</line-width>
          <line-width type="staff">1.25</line-width>
          <line-width type="light barline">1.4583</line-width>
          <line-width type="heavy barline">5</line-width>
          <line-width type="leger">1.875</line-width>
          <line-width type="ending">1.4583</line-width>
          <line-width type="wedge">0.9375</line-width>
          <line-width type="enclosure">1.4583</line-width>
          <line-width type="tuplet bracket">1.4583</line-width>
          <note-size type="grace">50</note-size>
          <note-size type="cue">50</note-size>
          <distance type="hyphen">60</distance>
          <distance type="beam">7.5</distance>
        </appearance>
      """;

      var appearance = Appearance.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(appearance.lineWidths.length, 10);
      expect(appearance.noteSizes.length, 2);
      expect(appearance.distances.length, 2);
      expect(appearance.glyphs.length, 0);
      expect(appearance.other.length, 0);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/tutorial-tablature/
    test("should throw on wrong element order", () {
      String input = """
        <appearance>
          <note-size type="grace">50</note-size>
          <distance type="hyphen">60</distance>
          <line-width type="stem">0.8333</line-width>
        </appearance>
      """;

      expect(
        () => Appearance.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<XmlSequenceException>()),
      );
    });
    group("Line width", () {
      // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/defaults-element/
      test("should parse 'defaults' example's line-width elements", () {
        List<(String input, LineWidth output)> inputsOutputs = [
          (
            '<line-width type="stem">0.7487</line-width>',
            LineWidth(type: 'stem', value: .7487),
          ),
          (
            '<line-width type="beam">5</line-width>',
            LineWidth(type: 'beam', value: 5),
          ),
          (
            '<line-width type="staff">0.7487</line-width>',
            LineWidth(type: 'staff', value: 0.7487),
          ),
          (
            '<line-width type="light barline">0.7487</line-width>',
            LineWidth(type: 'light barline', value: 0.7487),
          ),
          (
            '<line-width type="heavy barline">5</line-width>',
            LineWidth(type: 'heavy barline', value: 5),
          ),
          (
            '<line-width type="leger">0.7487</line-width>',
            LineWidth(type: 'leger', value: 0.7487),
          ),
          (
            '<line-width type="ending">0.7487</line-width>',
            LineWidth(type: 'ending', value: 0.7487),
          ),
          (
            '<line-width type="wedge">0.7487</line-width>',
            LineWidth(type: 'wedge', value: 0.7487),
          ),
          (
            '<line-width type="enclosure">0.7487</line-width>',
            LineWidth(type: 'enclosure', value: 0.7487),
          ),
          (
            '<line-width type="tuplet bracket">0.7487</line-width>',
            LineWidth(type: 'tuplet bracket', value: 0.7487),
          )
        ];

        for (var inputOutput in inputsOutputs) {
          var result = LineWidth.fromXml(
            XmlDocument.parse(inputOutput.$1).rootElement,
          );

          LineWidth expectedOutput = inputOutput.$2;

          expect(result.type, expectedOutput.type);
          expect(result.value, expectedOutput.value);
          expect(result.standardType, isNotNull);
        }
      });
      test("should throw on invalid content", () {
        String input = """
          <line-width type="stem"><foo></foo></line-width>
        """;

        expect(
          () => LineWidth.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<XmlElementContentException>()),
        );
      });
      test("should throw on invalid width value", () {
        String input = """
          <line-width type="stem">foo</line-width>
        """;

        expect(
          () => LineWidth.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MusicXmlFormatException>()),
        );
      });
      test("should throw on empty content", () {
        String input = """
          <line-width type="stem"></line-width>
        """;

        expect(
          () => LineWidth.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MusicXmlFormatException>()),
        );
      });
      test("should parse empty type", () {
        String input = """
          <line-width type="">0</line-width>
        """;

        var width = LineWidth.fromXml(
          XmlDocument.parse(input).rootElement,
        );

        expect(width.type, "");
        expect(width.value, 0);
      });
      test("should thrown on missing type attribute", () {
        String input = """
          <line-width >0</line-width>
        """;

        expect(
          () => LineWidth.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MissingXmlAttribute>()),
        );
      });
    });
    group("Note size", () {
      // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/defaults-element/
      test("should parse 'defaults' example's elements", () {
        List<(String input, NoteSize output)> inputsOutputs = [
          (
            '<note-size type="grace">65</note-size>',
            NoteSize(type: NoteSizeType.grace, value: 65),
          ),
          (
            '<note-size type="cue">65</note-size>',
            NoteSize(type: NoteSizeType.cue, value: 65),
          ),
          (
            '<note-size type="grace-cue">50</note-size>',
            NoteSize(type: NoteSizeType.graceCue, value: 50),
          ),
          (
            '<note-size type="large">120</note-size>',
            NoteSize(type: NoteSizeType.large, value: 120),
          ),
        ];

        for (var inputOutput in inputsOutputs) {
          var result = NoteSize.fromXml(
            XmlDocument.parse(inputOutput.$1).rootElement,
          );

          NoteSize expectedOutput = inputOutput.$2;

          expect(result.type, expectedOutput.type);
          expect(result.value, expectedOutput.value);
        }
      });
      test("should throw on invalid content", () {
        String input = """
          <note-size type="large"><foo></foo></note-size>
        """;

        expect(
          () => NoteSize.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<XmlElementContentException>()),
        );
      });
      test("should throw on invalid width value", () {
        String input = """
          <note-size type="large">foo</note-size>
        """;

        expect(
          () => NoteSize.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MusicXmlFormatException>()),
        );
      });
      test("should throw on empty content", () {
        String input = """
          <note-size type="grace-cue"></note-size>
        """;

        expect(
          () => NoteSize.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MusicXmlFormatException>()),
        );
      });
      test("should throw on empty type", () {
        String input = """
          <note-size type="">0</note-size>
        """;

        expect(
          () => NoteSize.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MusicXmlTypeException>()),
        );
      });
      test("should throw on invalid type", () {
        String input = """
          <note-size type="foo">0</note-size>
        """;

        expect(
          () => NoteSize.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MusicXmlTypeException>()),
        );
      });
      test("should thrown on missing type attribute", () {
        String input = """
          <note-size>0</note-size>
        """;

        expect(
          () => NoteSize.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MissingXmlAttribute>()),
        );
      });
      test("should thrown on negative value", () {
        String input = """
          <note-size type="grace-cue">-1</note-size>
        """;

        expect(
          () => NoteSize.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MusicXmlFormatException>()),
        );
      });
    });
    group("Distance", () {
      // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/defaults-element/
      test("should parse '<defaults>' example's elements", () {
        List<(String input, Distance output)> inputsOutputs = [
          (
            '<distance type="hyphen">120</distance>',
            Distance(type: 'hyphen', value: 120),
          ),
          (
            '<distance type="beam">7.5</distance>',
            Distance(type: 'beam', value: 7.5),
          ),
        ];

        for (var inputOutput in inputsOutputs) {
          var result = Distance.fromXml(
            XmlDocument.parse(inputOutput.$1).rootElement,
          );

          Distance expectedOutput = inputOutput.$2;

          expect(result.type, expectedOutput.type);
          expect(result.value, expectedOutput.value);
        }
      });
      test("should throw on invalid content", () {
        String input = """
          <distance type="c-clef"><foo></foo></distance>
        """;

        expect(
          () => Distance.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<XmlElementContentException>()),
        );
      });
      test("should throw on empty content", () {
        String input = """
          <distance type="beam"></distance>
        """;

        expect(
          () => Distance.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MusicXmlFormatException>()),
        );
      });
      test("should throw on text content", () {
        String input = """
          <distance type="beam">foo</distance>
        """;

        expect(
          () => Distance.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MusicXmlFormatException>()),
        );
      });
      test("should throw on empty type", () {
        String input = """
          <distance type="">10</distance>
        """;

        expect(
          () => Distance.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MissingXmlAttribute>()),
        );
      });
      test("should thrown on missing type attribute", () {
        String input = """
          <distance>10</distance>
        """;

        expect(
          () => Glyph.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MissingXmlAttribute>()),
        );
      });
    });
    group("Glyph", () {
      // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/glyph-element/
      test("should parse '<glyph>' example's elements", () {
        List<(String input, Glyph output)> inputsOutputs = [
          (
            '<glyph type="f-clef">fClef19thCentury</glyph>',
            Glyph(type: 'f-clef', name: 'fClef19thCentury'),
          ),
          (
            '<glyph type="quarter-rest">restQuarterOld</glyph>',
            Glyph(type: 'quarter-rest', name: 'restQuarterOld'),
          ),
        ];

        for (var inputOutput in inputsOutputs) {
          var result = Glyph.fromXml(
            XmlDocument.parse(inputOutput.$1).rootElement,
          );

          Glyph expectedOutput = inputOutput.$2;

          expect(result.type, expectedOutput.type);
          expect(result.name, expectedOutput.name);
        }
      });
      test("should throw on invalid content", () {
        String input = """
          <glyph type="c-clef"><foo></foo></glyph>
        """;

        expect(
          () => Glyph.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<XmlElementContentException>()),
        );
      });
      test("should throw on empty content", () {
        String input = """
          <glyph type="c-clef"></glyph >
        """;

        expect(
          () => Glyph.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<XmlElementContentException>()),
        );
      });
      test("should throw on empty type", () {
        String input = """
          <glyph type="">restQuarterOld</glyph>
        """;

        expect(
          () => Glyph.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MissingXmlAttribute>()),
        );
      });
      test("should thrown on missing type attribute", () {
        String input = """
          <glyph>restQuarterOld</glyph>
        """;

        expect(
          () => Glyph.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MissingXmlAttribute>()),
        );
      });
    });
    group("Other appearance", () {
      test("should parse elements", () {
        List<(String input, OtherAppearance output)> inputsOutputs = [
          (
            '<other-appearance type="foo">bar</other-appearance>',
            OtherAppearance(type: 'foo', value: 'bar'),
          ),
          (
            '<other-appearance type="bar">foo</other-appearance>',
            OtherAppearance(type: 'bar', value: 'foo'),
          ),
        ];

        for (var inputOutput in inputsOutputs) {
          var result = OtherAppearance.fromXml(
            XmlDocument.parse(inputOutput.$1).rootElement,
          );

          OtherAppearance expectedOutput = inputOutput.$2;

          expect(result.type, expectedOutput.type);
          expect(result.value, expectedOutput.value);
        }
      });
      test("should throw on invalid content", () {
        String input = """
          '<other-appearance type="foo"><bar></bar></other-appearance>',
        """;

        expect(
          () => OtherAppearance.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<XmlElementContentException>()),
        );
      });
      test("should throw on empty content", () {
        String input = """
          '<other-appearance type="foo"></other-appearance>',
        """;

        expect(
          () => OtherAppearance.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<XmlElementContentException>()),
        );
      });
      test("should throw on empty type", () {
        String input = """
          '<other-appearance type="">bar</other-appearance>',
        """;

        expect(
          () => OtherAppearance.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MissingXmlAttribute>()),
        );
      });
      test("should thrown on missing type attribute", () {
        String input = """
          '<other-appearance>bar</other-appearance>',
        """;

        expect(
          () => OtherAppearance.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MissingXmlAttribute>()),
        );
      });
    });
