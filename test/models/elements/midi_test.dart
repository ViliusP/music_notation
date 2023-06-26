import 'package:music_notation/src/models/elements/midi.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('MidiDevice', () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/instrument-change-element/
    test('should parse midi-device from <instrument-change> example correctly',
        () {
      String input = '''
        <midi-device>ARIA Player</midi-device>
      ''';

      var midiDevice = MidiDevice.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(midiDevice.id, isNull);
      expect(midiDevice.name, "ARIA Player");
      expect(midiDevice.port, null);
    });
    test('should parse midi-device attributes correctly', () {
      String input = '''
        <midi-device id="foo" port="5">ARIA Player</midi-device>
      ''';

      var midiDevice = MidiDevice.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(midiDevice.id, "foo");
      expect(midiDevice.name, "ARIA Player");
      expect(midiDevice.port, 5);
    });
    test('should parse on empty content', () {
      String input = '''
        <midi-device></midi-device>
      ''';

      var midiDevice = MidiDevice.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(midiDevice.name, "");
    });
    test('should throw on invalid content', () {
      String input = '''
        <midi-device><foo>bar</foo></midi-device>
      ''';
      expect(
        () => MidiDevice.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test('should throw on invalid port', () {
      String input = '''
        <midi-device port="foo">ARIA Player</midi-device>
      ''';

      expect(
        () => MidiDevice.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test('should throw on empty port', () {
      String input = '''
        <midi-device port="">ARIA Player</midi-device>
      ''';

      expect(
        () => MidiDevice.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test('should throw on empty id', () {
      String input = '''
        <midi-device id="">ARIA Player</midi-device>
      ''';

      expect(
        () => MidiDevice.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
  });
  group('MidiInstrument', () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/instrument-change-element/
    test(
        'should parse midi-instrument from <instrument-change> example correctly',
        () {
      String input = '''
        <midi-instrument id="P1-I1">
          <midi-channel>1</midi-channel>
          <midi-program>1</midi-program>
          <volume>80</volume>
          <pan>0</pan>
        </midi-instrument>
      ''';

      var midiInstrument = MidiInstrument.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(midiInstrument.id, "P1-I1");
      expect(midiInstrument.midiChannel, 1);
      expect(midiInstrument.midiProgram, 1);
      expect(midiInstrument.volume, 80);
      expect(midiInstrument.pan, 0);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/midi-device-element/
    test('should parse midi-instrument from <midi-device> example correctly',
        () {
      String input = '''
        <midi-instrument id="P2-I2">
            <midi-channel>2</midi-channel>
            <midi-program>1</midi-program>
            <volume>80</volume>
            <pan>4</pan>
        </midi-instrument>
      ''';

      var midiInstrument = MidiInstrument.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(midiInstrument.id, "P2-I2");
      expect(midiInstrument.midiChannel, 2);
      expect(midiInstrument.midiProgram, 1);
      expect(midiInstrument.volume, 80);
      expect(midiInstrument.pan, 4);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/midi-unpitched-element/
    test('should parse midi-instrument from <midi-unpitched> example correctly',
        () {
      String input = '''
        <midi-instrument id="P1-X19">
          <midi-channel>10</midi-channel>
          <midi-program>2</midi-program>
          <midi-unpitched>54</midi-unpitched>
          <volume>80</volume>
          <pan>0</pan>
        </midi-instrument>
      ''';

      var midiInstrument = MidiInstrument.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(midiInstrument.id, "P1-X19");
      expect(midiInstrument.midiChannel, 10);
      expect(midiInstrument.midiProgram, 2);
      expect(midiInstrument.midiUnpitched, 54);
      expect(midiInstrument.volume, 80);
      expect(midiInstrument.pan, 0);
    });
    test('should parse midi-instrument correctly', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <midi-channel>10</midi-channel>
          <midi-name>Tremolo Strings</midi-name>
          <midi-bank>15489</midi-bank>
          <midi-program>1</midi-program>
          <midi-unpitched>39</midi-unpitched>
          <volume>80</volume>
          <pan>-70</pan>
          <elevation>45</elevation>
        </midi-instrument>
      ''';

      var midiInstrument = MidiInstrument.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(midiInstrument.id, "P1-X4");
      expect(midiInstrument.midiName, "Tremolo Strings");
      expect(midiInstrument.midiBank, 15489);
      expect(midiInstrument.midiProgram, 1);
      expect(midiInstrument.midiUnpitched, 39);
      expect(midiInstrument.volume, 80);
      expect(midiInstrument.pan, -70);
      expect(midiInstrument.elevation, 45);
    });
    test('should throw exception on wrong children order', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <elevation>45</elevation>
          <pan>-70</pan>
          <volume>80</volume>
          <midi-unpitched>39</midi-unpitched>
          <midi-program>1</midi-program>
          <midi-bank>15489</midi-bank>
          <midi-name>Tremolo Strings</midi-name>
          <midi-channel>10</midi-channel>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<InvalidXmlSequence>()),
      );
    });
    // midi channel
    test('should throw exception on invalid midi-channel', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <midi-channel>foo</midi-channel>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test('should throw exception on empty midi-channel', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <midi-channel></midi-channel>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test('should throw exception on invalid midi-channel content', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <midi-channel><foo></foo></midi-channel>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    // midi-name
    test('should parse empty midi-name', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <midi-name></midi-name>
        </midi-instrument>
      ''';

      var midiInstrument = MidiInstrument.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(midiInstrument.midiName, "");
    });

    test('should throw on invalid midi-name', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <midi-name><foo/></midi-name>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    // midi-bank
    test('should throw exception on invalid midi-bank', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <midi-bank>foo</midi-bank>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test('should throw exception on empty midi-bank', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <midi-bank></midi-bank>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test('should throw exception on invalid midi-bank content', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <midi-bank><foo></foo></midi-bank>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    // midi-program
    test('should throw exception on invalid midi-program', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <midi-program>foo</midi-program>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test('should throw exception on invalid midi-program content', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <midi-program><foo></foo></midi-program>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test('should throw exception on empty midi-program', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <midi-program></midi-program>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    // <midi-unpitched>
    test('should throw exception on invalid midi-unpitched', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <midi-unpitched>foo</midi-unpitched>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test('should throw exception on invalid midi-unpitched content', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <midi-unpitched><foo></foo></midi-unpitched>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test('should throw exception on empty midi-unpitched', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <midi-unpitched></midi-unpitched>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    // <volume>
    test('should throw exception on invalid volume', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <volume>foo</volume>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test('should throw exception on bigger than maximum volume', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <volume>101</volume>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test('should throw exception on invalid volume content', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <volume><foo></foo></volume>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test('should throw exception on empty volume', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <volume></volume>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    // <pan>
    test('should throw exception on invalid pan', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <pan>foo</pan>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test('should throw exception on bigger than maximum pan', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <pan>181</pan>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test('should throw exception on invalid pan content', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <pan><foo></foo></pan>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test('should throw exception on lower than minimum pan', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <pan>-181</pan>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test('should throw exception on empty pan', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <pan></pan>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    // Elevation
    test('should throw exception on invalid elevation', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <elevation>foo</elevation>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test('should throw exception on bigger than maximum elevation', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <elevation>181</elevation>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test('should throw exception on invalid elevation content', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <elevation><foo></foo></elevation>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test('should throw exception on lower than minimum elevation', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <elevation>-181</elevation>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    test('should throw exception on empty elevation', () {
      String input = '''
        <midi-instrument id="P1-X4">
          <elevation></elevation>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MusicXmlFormatException>()),
      );
    });
    // id
    test('should throw exception on empty id', () {
      String input = '''
        <midi-instrument id="">
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MissingXmlAttribute>()),
      );
    });
    test('should throw exception on missing id', () {
      String input = '''
        <midi-instrument>
        </midi-instrument>
      ''';

      expect(
        () => MidiInstrument.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<MissingXmlAttribute>()),
      );
    });
  });
}
