import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/data_types/accidental_value.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/key.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

void main() {
  group("Traditional key ", () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/tutorial-hello-world/
    test("should parse 'Tutorial: Hello, World' example", () {
      String input = """
        <key>
          <fifths>0</fifths>
        </key>
      """;

      Key key = Key.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(key.id, isNull);
      expect(key.number, isNull);
      expect(key.printObject, true);
      expect(key.octaves.length, 0);
      expect(key, isA<TraditionalKey>());

      TraditionalKey traditionalKey = key as TraditionalKey;
      expect(traditionalKey.cancel, isNull);
      expect(traditionalKey.fifths, 0);
      expect(traditionalKey.mode, isNull);
    });
    test("should parse 'Tutorial: Percussion' example", () {
      String input = """
        <key>
            <fifths>0</fifths>
            <mode>major</mode>
        </key>
      """;

      Key key = Key.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(key.id, isNull);
      expect(key.number, isNull);
      expect(key.printObject, true);
      expect(key.octaves.length, 0);
      expect(key, isA<TraditionalKey>());

      TraditionalKey traditionalKey = key as TraditionalKey;
      expect(traditionalKey.cancel, isNull);
      expect(traditionalKey.fifths, 0);
      expect(traditionalKey.mode, Mode.major);
    });
    test("should parse '<cancel>' example", () {
      String input = """
        <key>
          <cancel>-2</cancel>
          <fifths>-1</fifths>
          <mode>major</mode>
        </key>
      """;

      Key key = Key.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(key.id, isNull);
      expect(key.number, isNull);
      expect(key.printObject, true);
      expect(key.octaves.length, 0);
      expect(key, isA<TraditionalKey>());

      TraditionalKey traditionalKey = key as TraditionalKey;
      expect(traditionalKey.cancel?.value, -2);
      expect(traditionalKey.fifths, -1);
      expect(traditionalKey.mode, Mode.major);
    });
    test("parsing should throw on invalid fifths content", () {
      String input = """
        <key>
          <fifths><foo></foo></fifths>
        </key>
      """;

      expect(
        () => Key.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("parsing should throw on non integer fifths content", () {
      String input = """
        <key>
          <fifths>foo</fifths>
        </key>
      """;

      expect(
        () => Key.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on empty content", () {
      String input = """
        <key>
          <fifths></fifths>
        </key>
      """;

      expect(
        () => Key.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on invalid mode content", () {
      String input = """
        <key>
          <fifths>1</fifths>
          <mode><foo></foo></mode>
        </key>
      """;

      expect(
        () => Key.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("parsing should throw on invalid mode", () {
      String input = """
        <key>
          <fifths>1</fifths>
          <mode>mode</mode>
        </key>
      """;

      expect(
        () => Key.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
  });
  group("Cancel", () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/cancel-element/
    test("should parse '<cancel>' example", () {
      String input = """
        <cancel>-2</cancel>
      """;

      Cancel cancel = Cancel.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(cancel.value, -2);
      expect(cancel.location, CancelLocation.left);
    });

    test("should parse cancel location", () {
      String input = """
        <cancel location="right">2</cancel>
      """;

      Cancel cancel = Cancel.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(cancel.value, 2);
      expect(cancel.location, CancelLocation.right);
    });
    test("parsing should throw on invalid content", () {
      String input = """
        <cancel location="right"><foo></foo></cancel>
      """;

      expect(
        () => Cancel.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("parsing should throw on non integer content", () {
      String input = """
        <cancel location="right">foo</cancel>
      """;

      expect(
        () => Cancel.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on empty content", () {
      String input = """
        <cancel location="right"></cancel>
      """;

      expect(
        () => Cancel.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on empty location attribute", () {
      String input = """
        <cancel location="">2</cancel>
      """;

      expect(
        () => Cancel.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("parsing should throw on invalid location attribute", () {
      String input = """
        <cancel location="">2</cancel>
      """;

      expect(
        () => Cancel.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
  });
  group("Non-Traditional key ", () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/key-element-non-traditional/
    test("should parse '<key> (Non-Traditional)' example", () {
      String input = """
        <key>
          <key-step>B</key-step>
          <key-alter>-1</key-alter>
          <key-accidental>quarter-flat</key-accidental>
          <key-step>E</key-step>
          <key-alter>-2</key-alter>
          <key-accidental>slash-flat</key-accidental>
          <key-step>A</key-step>
          <key-alter>-2</key-alter>
          <key-accidental>slash-flat</key-accidental>
          <key-step>F</key-step>
          <key-alter>2</key-alter>
          <key-accidental>sharp</key-accidental>
        </key>
      """;

      Key key = Key.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(key.id, isNull);
      expect(key.number, isNull);
      expect(key.printObject, true);
      expect(key.octaves.length, 0);
      expect(key, isA<NonTraditionalKey>());

      NonTraditionalKey nonTraditionalKey = key as NonTraditionalKey;
      expect(nonTraditionalKey.content.length, 4);
      expect(nonTraditionalKey.content[0].step, Step.B);
      expect(nonTraditionalKey.content[0].alter, -1);
      expect(
        nonTraditionalKey.content[0].accidental?.value,
        AccidentalValue.quarterFlat,
      );
      expect(nonTraditionalKey.content[1].step, Step.E);
      expect(nonTraditionalKey.content[1].alter, -2);
      expect(
        nonTraditionalKey.content[1].accidental?.value,
        AccidentalValue.slashFlat,
      );
      expect(nonTraditionalKey.content[2].step, Step.A);
      expect(nonTraditionalKey.content[2].alter, -2);
      expect(
        nonTraditionalKey.content[2].accidental?.value,
        AccidentalValue.slashFlat,
      );
      expect(nonTraditionalKey.content[3].step, Step.F);
      expect(nonTraditionalKey.content[3].alter, 2);
      expect(
        nonTraditionalKey.content[3].accidental?.value,
        AccidentalValue.sharp,
      );
    });
    test("should parse '<key-octave>' example", () {
      String input = """
        <key>
          <key-step>F</key-step>
          <key-alter>1</key-alter>
          <key-step>G</key-step>
          <key-alter>1</key-alter>
          <key-octave number="1">4</key-octave>
          <key-octave number="2">4</key-octave>
        </key>
      """;

      Key key = Key.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(key.id, isNull);
      expect(key.number, isNull);
      expect(key.printObject, true);
      expect(key.octaves.length, 2);
      expect(key.octaves[0].number, 1);
      expect(key.octaves[0].value, 4);
      expect(key.octaves[1].number, 2);
      expect(key.octaves[1].value, 4);
      expect(key, isA<NonTraditionalKey>());

      NonTraditionalKey nonTraditionalKey = key as NonTraditionalKey;
      expect(nonTraditionalKey.content.length, 2);
      expect(nonTraditionalKey.content[0].step, Step.F);
      expect(nonTraditionalKey.content[0].alter, 1);
      expect(nonTraditionalKey.content[0].accidental, null);
      expect(nonTraditionalKey.content[1].step, Step.G);
      expect(nonTraditionalKey.content[1].alter, 1);
      expect(nonTraditionalKey.content[1].accidental, null);
    });
    test("parsing should wrong sequence", () {
      String input = """
        <key>
          <key-accidental>quarter-flat</key-accidental>
          <key-step>F</key-step>
          <key-alter>1</key-alter>
        </key>
      """;

      expect(
        () => Key.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("parsing should on invalid key-step content", () {
      String input = """
        <key>
          <key-step><foo></foo></key-step>
          <key-alter>1</key-alter>
        </key>
      """;

      expect(
        () => Key.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("parsing should on non-step key-step content", () {
      String input = """
        <key>
          <key-step>foo</key-step>
          <key-alter>1</key-alter>
        </key>
      """;

      expect(
        () => Key.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("parsing should on empty key-step content", () {
      String input = """
        <key>
          <key-step></key-step>
          <key-alter>1</key-alter>
        </key>
      """;

      expect(
        () => Key.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("parsing should on invalid key-alter content", () {
      String input = """
        <key>
          <key-step>F</key-step>
          <key-alter><foo></foo></key-alter>
        </key>
      """;

      expect(
        () => Key.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("parsing should on empty key-alter content", () {
      String input = """
        <key>
          <key-step>F</key-step>
          <key-alter></key-alter>
        </key>
      """;

      expect(
        () => Key.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should on non-double key-alter content", () {
      String input = """
        <key>
          <key-step>F</key-step>
          <key-alter>foo</key-alter>
        </key>
      """;

      expect(
        () => Key.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should on invalid key-accidental content", () {
      String input = """
        <key>
          <key-step>F</key-step>
          <key-alter>1</key-alter>
          <key-accidental><foo></foo></key-accidental>
        </key>
      """;

      expect(
        () => Key.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<XmlElementContentException>()),
      );
    });
  });
  group("Key octave ", () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/key-octave-element/
    test("should parse '<key-octave>' example #1", () {
      String input = """
        <key-octave number="1">4</key-octave>
      """;

      KeyOctave keyOctave = KeyOctave.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(keyOctave.number, 1);
      expect(keyOctave.value, 4);
      expect(keyOctave.cancel, false);
    });
    test("should parse '<key-octave>' example #2", () {
      String input = """
        <key-octave number="2">4</key-octave>
      """;

      KeyOctave keyOctave = KeyOctave.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(keyOctave.number, 2);
      expect(keyOctave.value, 4);
      expect(keyOctave.cancel, false);
    });
    test("parsing should throw on negative value", () {
      String input = """
        <key-octave number="2">-1</key-octave>
      """;

      expect(
        () => KeyOctave.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on value bigger than 9", () {
      String input = """
        <key-octave number="2">10</key-octave>
      """;

      expect(
        () => KeyOctave.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on invalid content", () {
      String input = """
        <key-octave number="2"><foo></foo></key-octave>
      """;

      expect(
        () => KeyOctave.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("parsing should throw on negative number attribute", () {
      String input = """
        <key-octave number="-1">1</key-octave>
      """;

      expect(
        () => KeyOctave.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on empty number attribute", () {
      String input = """
        <key-octave number="">1</key-octave>
      """;

      expect(
        () => KeyOctave.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on invalid number attribute", () {
      String input = """
        <key-octave number="foo">1</key-octave>
      """;

      expect(
        () => KeyOctave.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on missing number attribute", () {
      String input = """
        <key-octave>1</key-octave>
      """;

      expect(
        () => KeyOctave.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MissingXmlAttribute>()),
      );
    });
    test("parsing should throw on invalid cancel attribute", () {
      String input = """
        <key-octave number="1" cancel="foo">1</key-octave>
      """;

      expect(
        () => KeyOctave.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
  });
}
