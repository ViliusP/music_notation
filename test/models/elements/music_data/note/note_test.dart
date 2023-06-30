import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/data_types/start_stop.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

void main() {
  group('Note', () {
    group('grace', () {
      test('should be null if not exists', () {
        String input = '''
          <note>
              <pitch>
                  <step>C</step>
                  <octave>4</octave>
              </pitch>
              <duration>4</duration>
              <type>whole</type>
          </note>
        ''';

        var note = Note.fromXml(XmlDocument.parse(input).rootElement);
        expect(note, isA<GraceNote>);

        var graceNote = note as GraceNote;
      });

      test('should parse if exists', () {
        String input = '''
          <note default-x="224.55" default-y="-10.00" xml:id="note7">
              <grace />
              <pitch>
                  <step>D</step>
                  <octave>5</octave>
              </pitch>
          </note>
        ''';

        var note = Note.fromXml(XmlDocument.parse(input).rootElement);
        expect(note, isA<GraceNote>);

        var graceNote = note as GraceNote;
      });
    });

    test('should parse all properties', () {
      String input = '''
          <grace slash="no" steal-time-following="33"/>
        ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      var grace = Grace.fromXml(rootElement);

      expect(grace.slash, false);
      expect(grace.stealTimeFollowing, 33);
      expect(grace.stealTimePrevious, null);
      expect(grace.makeTime, null);
    });

    test('should parse all properties #2', () {
      String input = '''
          <grace slash="yes"/>
        ''';

      var rootElement = XmlDocument.parse(input).rootElement;

      var grace = Grace.fromXml(rootElement);

      expect(grace.slash, true);
      expect(grace.stealTimeFollowing, null);
      expect(grace.stealTimePrevious, null);
      expect(grace.makeTime, null);
    });
  });
  // TODO: do more tests
  test('should parse all properties', () {
    String input = '''
        <note>
            <pitch>
                <step>C</step>
                <octave>4</octave>
            </pitch>
            <duration>4</duration>
            <type>whole</type>
        </note>
      ''';

    var rootElement = XmlDocument.parse(input).rootElement;

    var note = Note.fromXml(rootElement);

    expect(note, isNotNull);
  });

  test('should parse all properties #2', () {
    String input = '''
        <note default-x="128.60" default-y="10.00" xml:id="note213">
          <pitch>
              <step>F</step>
              <octave>3</octave>
          </pitch>
          <duration>8</duration>
          <voice>5</voice>
          <type>eighth</type>
          <time-modification>
              <actual-notes>3</actual-notes>
              <normal-notes>2</normal-notes>
          </time-modification>
          <stem>down</stem>
          <staff>2</staff>
          <beam number="1">begin</beam>
          <notations>
              <tuplet type="start" bracket="no" />
              <slur type="start" placement="above" number="1" />
          </notations>
        </note>
      ''';

    var rootElement = XmlDocument.parse(input).rootElement;

    var note = Note.fromXml(rootElement);

    expect(note, isNotNull);
  });
  group("Grace", () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/grace-element/
    test("should parse '<grace>' example", () {
      String input = """
          <grace slash="yes"/>
        """;

      var grace = Grace.fromXml(XmlDocument.parse(input).rootElement);

      expect(grace.slash, isTrue);
      expect(grace.makeTime, isNull);
      expect(grace.stealTimeFollowing, isNull);
      expect(grace.stealTimePrevious, isNull);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/grace-element-appoggiatura/
    test("should parse '<grace> (Appoggiatura)' example", () {
      String input = """
          <grace slash="no" steal-time-following="33"/>
        """;

      var grace = Grace.fromXml(XmlDocument.parse(input).rootElement);

      expect(grace.slash, isFalse);
      expect(grace.makeTime, isNull);
      expect(grace.stealTimeFollowing, 33);
      expect(grace.stealTimePrevious, isNull);
    });
    test("parsing should throw on invalid slash attribute", () {
      String input = """
          <grace slash="foo"/>
        """;

      expect(
        () => Grace.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(
          isA<MusicXmlTypeException>(),
        ),
      );
    });
    test("parsing should throw on invalid make-time attribute", () {
      String input = """
          <grace make-time="foo"/>
        """;

      expect(
        () => Grace.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(
          isA<MusicXmlFormatException>(),
        ),
      );
    });
    test("parsing should throw on invalid steal-time-following attribute", () {
      String input = """
          <grace steal-time-following="foo"/>
        """;

      expect(
        () => Grace.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(
          isA<MusicXmlFormatException>(),
        ),
      );
    });
    test("parsing should throw on negative steal-time-following attribute", () {
      String input = """
          <grace steal-time-following="-1"/>
        """;

      expect(
        () => Grace.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(
          isA<MusicXmlFormatException>(),
        ),
      );
    });
    test(
        "parsing should throw on bigger than 100 steal-time-following attribute",
        () {
      String input = """
          <grace steal-time-following="101"/>
        """;

      expect(
        () => Grace.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(
          isA<MusicXmlFormatException>(),
        ),
      );
    });
    test("parsing should throw on invalid steal-time-previous attribute", () {
      String input = """
          <grace steal-time-previous="foo"/>
        """;

      expect(
        () => Grace.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(
          isA<MusicXmlFormatException>(),
        ),
      );
    });
    test("parsing should throw on negative steal-time-previous attribute", () {
      String input = """
          <grace steal-time-previous="-1"/>
        """;

      expect(
        () => Grace.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(
          isA<MusicXmlFormatException>(),
        ),
      );
    });
    test(
        "parsing should throw on bigger than 100 steal-time-previous attribute",
        () {
      String input = """
          <grace steal-time-previous="101"/>
        """;

      expect(
        () => Grace.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(
          isA<MusicXmlFormatException>(),
        ),
      );
    });
  });
  group("Tie", () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/humming-element/
    test("should parse '<humming>'>' example", () {
      String input = """
          <tie type="start"/>
        """;

      var tie = Tie.fromXml(XmlDocument.parse(input).rootElement);

      expect(tie.type, StartStop.start);
      expect(tie.timeOnly, null);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/tied-element/
    test("should parse '<tied>' example", () {
      String input = """
          <tie type="stop"/>
        """;

      var tie = Tie.fromXml(XmlDocument.parse(input).rootElement);

      expect(tie.type, StartStop.stop);
      expect(tie.timeOnly, null);
    });
    test("parsing should throw on missing type attribute", () {
      String input = """
          <tie/>
        """;

      expect(
        () => Tie.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MissingXmlAttribute>()),
      );
    });
    test("parsing should throw on invalid type attribute", () {
      String input = """
          <tie type="foo"/>
        """;

      expect(
        () => Tie.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });
    test("should parse time-only attribute", () {
      String input = """
          <tie type="stop" time-only="100,200,300"/>
        """;

      var tie = Tie.fromXml(XmlDocument.parse(input).rootElement);

      expect(tie.type, StartStop.stop);
      expect(tie.timeOnly, "100,200,300");
    });
    test("parsing should throw on invalid time-only attribute", () {
      String input = """
          <tie type="stop" time-only="foo"/>
        """;

      expect(
        () => Tie.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    group("pitch", () {
      // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/accent-element/
      test("should parse '<accent>' example", () {
        String input = """
          <pitch>
            <step>A</step>
            <octave>4</octave>
          </pitch>
        """;

        var pitch = Pitch.fromXml(XmlDocument.parse(input).rootElement);

        expect(pitch.step, Step.A);
        expect(pitch.octave, 4);
      });
      // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/accidental-element/
      test("should parse '<accidental>' example", () {
        String input = """
          <pitch>
            <step>A</step>
            <alter>1</alter>
            <octave>4</octave>
          </pitch>
        """;

        var pitch = Pitch.fromXml(XmlDocument.parse(input).rootElement);

        expect(pitch.step, Step.A);
        expect(pitch.alter, 1);
        expect(pitch.octave, 4);
      });
      // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/alter-element-microtones/
      test("should parse '<alter> (Microtones)' example", () {
        String input = """
          <pitch>
            <step>B</step>
            <alter>-0.5</alter>
            <octave>4</octave>
          </pitch>
        """;

        var pitch = Pitch.fromXml(XmlDocument.parse(input).rootElement);

        expect(pitch.step, Step.B);
        expect(pitch.alter, -0.5);
        expect(pitch.octave, 4);
      });
      // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/pedal-element-symbols/
      test("should parse '<pedal> (Symbols)' example", () {
        String input = """
          <pitch>
            <step>B</step>
            <alter>-1</alter>
            <octave>2</octave>
          </pitch>
        """;

        var pitch = Pitch.fromXml(XmlDocument.parse(input).rootElement);

        expect(pitch.step, Step.B);
        expect(pitch.alter, -1);
        expect(pitch.octave, 2);
      });
      test("parsing should throw on step content", () {
        String input = """
          <pitch>
            <step><foo></foo></step>
            <alter>-1</alter>
            <octave>2</octave>
          </pitch>
        """;

        expect(
          () => Pitch.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<XmlElementContentException>()),
        );
      });
      test("parsing should throw on alter content", () {
        String input = """
          <pitch>
            <step>B</step>
            <alter><foo></foo></alter>
            <octave>2</octave>
          </pitch>
        """;

        expect(
          () => Pitch.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<XmlElementContentException>()),
        );
      });
      test("parsing should throw on octave content", () {
        String input = """
          <pitch>
            <step>B</step>
            <alter>-1</alter>
            <octave><foo></foo></octave>
          </pitch>
        """;

        expect(
          () => Pitch.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<XmlElementContentException>()),
        );
      });
      test("parsing should throw on invalid step", () {
        String input = """
          <pitch>
            <step>Z</step>
            <alter>-1</alter>
            <octave>2</octave>
          </pitch>
        """;

        expect(
          () => Pitch.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MusicXmlTypeException>()),
        );
      });
      test("parsing should throw on invalid alter", () {
        String input = """
          <pitch>
            <step>B</step>
            <alter>Z</alter>
            <octave>2</octave>
          </pitch>
        """;

        expect(
          () => Pitch.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MusicXmlFormatException>()),
        );
      });
      test("parsing should throw on invalid octave", () {
        String input = """
          <pitch>
            <step>B</step>
            <alter>-1</alter>
            <octave>fooo</octave>
          </pitch>
        """;

        expect(
          () => Pitch.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MusicXmlFormatException>()),
        );
      });
    });
  });
}
