import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/elements/score/part.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

void main() {
  group("Part", () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/assess-and-player-elements/
    test("should parse '<assess> and <player>' example", () {
      String input = """
        <part id="P1">
          <measure number="1" width="191">
            <attributes>
              <divisions>2</divisions>
              <key>
                <fifths>0</fifths>
                <mode>minor</mode>
              </key>
              <time>
                <beats>4</beats>
                <beat-type>4</beat-type>
              </time>
              <clef>
                <sign>G</sign>
                <line>2</line>
              </clef>
            </attributes>
            <note default-x="83">
              <pitch>
                <step>A</step>
                <octave>4</octave>
              </pitch>
              <duration>8</duration>
              <instrument id="P1-I2"/>
              <voice>1</voice>
              <type>whole</type>
              <lyric default-y="-62" justify="left" number="1">
                <syllabic>single</syllabic>
                <text>Ah</text>
                <extend type="start"/>
              </lyric>
              <listen>
                <assess type="no" player="P1-M1"/>
                <assess type="no" player="P1-M2"/>
              </listen>
            </note>
            <note default-x="83">
              <chord/>
              <pitch>
                <step>C</step>
                <octave>5</octave>
              </pitch>
              <duration>8</duration>
              <instrument id="P1-I1"/>
              <voice>1</voice>
              <type>whole</type>
              <listen>
                <assess type="no" player="P1-M3"/>
                <assess type="no" player="P1-M4"/>
              </listen>
            </note>
          </measure>
          <measure number="2" width="120">
            <note default-x="13">
              <pitch>
                <step>A</step>
                <octave>4</octave>
              </pitch>
              <duration>8</duration>
              <instrument id="P1-I2"/>
              <voice>1</voice>
              <type>whole</type>
              <lyric number="1">
                <extend type="stop"/>
              </lyric>
              <listen>
                <assess type="no" player="P1-M1"/>
                <assess type="no" player="P1-M2"/>
              </listen>
            </note>
            <note default-x="13">
              <chord/>
              <pitch>
                <step>C</step>
                <octave>5</octave>
              </pitch>
              <duration>8</duration>
              <instrument id="P1-I1"/>
              <voice>1</voice>
              <type>whole</type>
              <listen>
                <assess type="no" player="P1-M1"/>
                <assess type="no" player="P1-M3"/>
                <assess type="no" player="P1-M4"/>
              </listen>
            </note>
            <note default-x="13">
              <chord/>
              <pitch>
                <step>E</step>
                <octave>5</octave>
              </pitch>
              <duration>8</duration>
              <instrument id="P1-I1"/>
              <voice>1</voice>
              <type>whole</type>
              <listen>
                <assess type="no" player="P1-M2"/>
                <assess type="no" player="P1-M3"/>
                <assess type="no" player="P1-M4"/>
              </listen>
            </note>
          </measure>
        </part>
      """;

      var part = Part.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(part.id, "P1");
      expect(part.measures.length, 2);
    });
    test("parsing should throw exception on missing id attribute", () {
      String input = """
        <part>
          <measure number="1" width="191">           
            <note default-x="83">
              <chord/>
              <pitch>
                <step>C</step>
                <octave>5</octave>
              </pitch>
              <duration>8</duration>
              <instrument id="P1-I1"/>
              <voice>1</voice>
              <type>whole</type>
              <listen>
                <assess type="no" player="P1-M3"/>
                <assess type="no" player="P1-M4"/>
              </listen>
            </note>
          </measure>
        </part>
      """;

      expect(
        () => Part.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MissingXmlAttribute>()),
      );
    });
    test("parsing should throw exception on empty id", () {
      String input = """
        <part id="">
          <measure number="1" width="191">           
            <note default-x="83">
              <chord/>
              <pitch>
                <step>C</step>
                <octave>5</octave>
              </pitch>
              <duration>8</duration>
              <instrument id="P1-I1"/>
              <voice>1</voice>
              <type>whole</type>
              <listen>
                <assess type="no" player="P1-M3"/>
                <assess type="no" player="P1-M4"/>
              </listen>
            </note>
          </measure>
        </part>
      """;

      expect(
        () => Part.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MissingXmlAttribute>()),
      );
    });
    test("parsing should throw exception on zero measures", () {
      String input = """
        <part id="P1">
        </part>
      """;

      expect(
        () => Part.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<XmlSequenceException>()),
      );
    });
    test("parsing should throw exception on missing id attribute", () {
      String input = """
        <part>
          <measure number="1" width="191">           
            <note default-x="83">
              <chord/>
              <pitch>
                <step>C</step>
                <octave>5</octave>
              </pitch>
              <duration>8</duration>
              <instrument id="P1-I1"/>
              <voice>1</voice>
              <type>whole</type>
              <listen>
                <assess type="no" player="P1-M3"/>
                <assess type="no" player="P1-M4"/>
              </listen>
            </note>
          </measure>
        </part>
      """;

      expect(
        () => Part.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MissingXmlAttribute>()),
      );
    });
  });
  group("Measure", () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/assess-and-player-elements/
    test("should parse first measure from '<assess> and <player>' example", () {
      String input = """
        <measure number="1" width="191">
          <attributes>
            <divisions>2</divisions>
            <key>
              <fifths>0</fifths>
              <mode>minor</mode>
            </key>
            <time>
              <beats>4</beats>
              <beat-type>4</beat-type>
            </time>
            <clef>
              <sign>G</sign>
              <line>2</line>
            </clef>
          </attributes>
          <note default-x="83">
            <pitch>
              <step>A</step>
              <octave>4</octave>
            </pitch>
            <duration>8</duration>
            <instrument id="P1-I2"/>
            <voice>1</voice>
            <type>whole</type>
            <lyric default-y="-62" justify="left" number="1">
              <syllabic>single</syllabic>
              <text>Ah</text>
              <extend type="start"/>
            </lyric>
            <listen>
              <assess type="no" player="P1-M1"/>
              <assess type="no" player="P1-M2"/>
            </listen>
          </note>
          <note default-x="83">
            <chord/>
            <pitch>
              <step>C</step>
              <octave>5</octave>
            </pitch>
            <duration>8</duration>
            <instrument id="P1-I1"/>
            <voice>1</voice>
            <type>whole</type>
            <listen>
              <assess type="no" player="P1-M3"/>
              <assess type="no" player="P1-M4"/>
            </listen>
          </note>
        </measure>
      """;

      var measure = Measure.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(measure.attributes.number, "1");
      expect(measure.attributes.id, isNull);
      expect(measure.attributes.implicit, isFalse);
      expect(measure.attributes.nonControlling, isFalse);
      expect(measure.attributes.text, isNull);
      expect(measure.attributes.width, 191);
      expect(measure.data.length, 3);
    });
    test("should parse second measure from '<assess> and <player>' example",
        () {
      String input = """
        <measure number="2" width="120">
          <note default-x="13">
            <pitch>
              <step>A</step>
              <octave>4</octave>
            </pitch>
            <duration>8</duration>
            <instrument id="P1-I2"/>
            <voice>1</voice>
            <type>whole</type>
            <lyric number="1">
              <extend type="stop"/>
            </lyric>
            <listen>
              <assess type="no" player="P1-M1"/>
              <assess type="no" player="P1-M2"/>
            </listen>
          </note>
          <note default-x="13">
            <chord/>
            <pitch>
              <step>C</step>
              <octave>5</octave>
            </pitch>
            <duration>8</duration>
            <instrument id="P1-I1"/>
            <voice>1</voice>
            <type>whole</type>
            <listen>
              <assess type="no" player="P1-M1"/>
              <assess type="no" player="P1-M3"/>
              <assess type="no" player="P1-M4"/>
            </listen>
          </note>
          <note default-x="13">
            <chord/>
            <pitch>
              <step>E</step>
              <octave>5</octave>
            </pitch>
            <duration>8</duration>
            <instrument id="P1-I1"/>
            <voice>1</voice>
            <type>whole</type>
            <listen>
              <assess type="no" player="P1-M2"/>
              <assess type="no" player="P1-M3"/>
              <assess type="no" player="P1-M4"/>
            </listen>
          </note>
        </measure>
      """;

      var measure = Measure.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(measure.attributes.number, "2");
      expect(measure.attributes.id, isNull);
      expect(measure.attributes.implicit, isFalse);
      expect(measure.attributes.nonControlling, isFalse);
      expect(measure.attributes.text, isNull);
      expect(measure.attributes.width, 120);
      expect(measure.data.length, 3);
    });
    test("parsing should throw on wrong child element", () {
      String input = """
        <measure number="2" width="120">
          <foo></foo>
        </measure>
      """;

      expect(
        () => Measure.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlSequenceException>()),
      );
    });
    // number
    test("parsing should throw on missing number attribute", () {
      String input = """
        <measure width="120">
        </measure>
      """;

      expect(
        () => Measure.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MissingXmlAttribute>()),
      );
    });
    test("parsing should throw on empty number attribute", () {
      String input = """
        <measure number="" width="120">
        </measure>
      """;

      expect(
        () => Measure.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MissingXmlAttribute>()),
      );
    });
    // id
    test("parsing should throw on empty id attribute", () {
      String input = """
        <measure number="0" id="" width="120">
        </measure>
      """;

      expect(
        () => Measure.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MissingXmlAttribute>()),
      );
    });
    // implicit
    test("parsing should throw on empty implicit attribute", () {
      String input = """
        <measure number="1" implicit="">
        </measure>
      """;

      expect(
        () => Measure.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("parsing should throw on invalid implicit attribute", () {
      String input = """
        <measure number="1" implicit="foo">
        </measure>
      """;

      expect(
        () => Measure.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    // non-controlling
    test("parsing should throw on empty non-controlling attribute", () {
      String input = """
        <measure number="1" non-controlling="">
        </measure>
      """;

      expect(
        () => Measure.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("parsing should throw on invalid non-controlling attribute", () {
      String input = """
        <measure number="1" non-controlling="foo">
        </measure>
      """;

      expect(
        () => Measure.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    // text
    test("parsing should throw on empty text attribute", () {
      String input = """
        <measure number="1" text="">
        </measure>
      """;

      expect(
        () => Measure.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on text attribute with only white-spaces", () {
      String input = """
        <measure number="1" text="     ">
        </measure>
      """;

      expect(
        () => Measure.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    // width
    test("parsing should throw on empty width attribute", () {
      String input = """
        <measure number="1" width="">
        </measure>
      """;

      expect(
        () => Measure.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("parsing should throw on invalid width attribute", () {
      String input = """
        <measure number="1" width="foo">
        </measure>
      """;

      expect(
        () => Measure.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
  });
}
