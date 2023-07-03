import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/data_types/start_stop.dart';
import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/models/data_types/symbol_size.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

void main() {
  group('Note', () {
    test("should throw on invalid staff content", () {
      String input = '''
          <note>
            <pitch>
              <step>C</step>
              <octave>4</octave>
            </pitch>
            <duration>4</duration>
            <staff><foo></foo></staff>
          </note>
        ''';

      expect(
        () => Note.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("should throw on invalid staff value", () {
      String input = '''
          <note>
            <pitch>
              <step>C</step>
              <octave>4</octave>
            </pitch>
            <duration>4</duration>
            <staff>foo</staff>
          </note>
        ''';

      expect(
        () => Note.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("should throw on negative staff value", () {
      String input = '''
          <note>
            <pitch>
              <step>C</step>
              <octave>4</octave>
            </pitch>
            <duration>4</duration>
            <staff>-1</staff>
          </note>
        ''';

      expect(
        () => Note.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test("should throw on invalid rest measure attribute", () {
      String input = """
          <note>
            <rest measure="foo"/>
            <duration>6</duration>
            <voice>2</voice>
            <staff>2</staff>
          </note>  
        """;

      expect(
        () => Note.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlTypeException>()),
      );
    });

    group("regular", () {
      test("should parse 'Tutorial: Hello, World' example", () {
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
        expect(note, isA<RegularNote>());

        var regularNote = note as RegularNote;
        expect(regularNote.chord, isNull);
        expect(regularNote.form, isA<Pitch>());
        var pitch = regularNote.form as Pitch;
        expect(pitch.alter, isNull);
        expect(pitch.step, Step.C);
        expect(pitch.octave, 4);
        expect(regularNote.duration, 4);
        expect(regularNote.ties.length, 0);
        expect(regularNote.instrument.length, 0);
        expect(regularNote.type?.value, NoteTypeValue.whole);
        expect(regularNote.type?.size, SymbolSize.full);
        expect(regularNote.dots.length, 0);
        expect(regularNote.accidental, isNull);
        expect(regularNote.timeModification, isNull);
        expect(regularNote.stem, isNull);
        expect(regularNote.notehead, isNull);
        expect(regularNote.noteheadText, isNull);
        expect(regularNote.staff, isNull);
        expect(regularNote.beams.length, 0);
        expect(regularNote.notations.length, 0);
        expect(regularNote.lyrics.length, 0);
        expect(regularNote.play, isNull);
        expect(regularNote.listen, isNull);
      });
      test("should parse rest from 'Tutorial: Après un rêve' example", () {
        String input = """
          <note>
            <rest measure="yes"/>
            <duration>6</duration>
            <voice>2</voice>
            <staff>2</staff>
          </note>  
        """;

        var note = Note.fromXml(XmlDocument.parse(input).rootElement);
        expect(note, isA<RegularNote>());

        var regularNote = note as RegularNote;
        expect(regularNote.duration, 6);
        expect(regularNote.editorialVoice.voice, "2");

        expect(regularNote.form, isA<Rest>());
        var rest = regularNote.form as Rest;
        expect(rest.measure, true);
        expect(rest.displayOctave, isNull);
        expect(rest.displayOctave, isNull);

        expect(regularNote.ties.length, 0);
        expect(regularNote.instrument.length, 0);
        expect(regularNote.type, isNull);
        expect(regularNote.dots.length, 0);
        expect(regularNote.accidental, isNull);
        expect(regularNote.timeModification, isNull);
        expect(regularNote.stem, isNull);
        expect(regularNote.notehead, isNull);
        expect(regularNote.noteheadText, isNull);
        expect(regularNote.staff, 2);
        expect(regularNote.beams.length, 0);
        expect(regularNote.notations.length, 0);
        expect(regularNote.lyrics.length, 0);
        expect(regularNote.play, isNull);
        expect(regularNote.listen, isNull);
      });
    });
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
    test("should parse '<humming>' example", () {
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
