import 'package:music_notation/models/note.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('', () {
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



  group('Grace', () {
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

      var rootElement = XmlDocument.parse(input).rootElement;

      var note = Note.fromXml(rootElement);

      expect(note.grace, isNull);
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

      var rootElement = XmlDocument.parse(input).rootElement;

      var note = Note.fromXml(rootElement);

      expect(note.grace, isNotNull);
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
}
