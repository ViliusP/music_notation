import 'package:music_notation/src/models/data_types/accidental_value.dart';
import 'package:music_notation/src/models/elements/midi.dart';
import 'package:music_notation/src/models/elements/text/text.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/generic.dart';
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
    test('should throw on missing/empty content', () {
      String input = '''
        <midi-device></midi-device>
      ''';

      expect(
        () => MidiDevice.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<InvalidXmlElementException>()),
      );
    });
    test('should throw on invalid content', () {
      String input = '''
        <midi-device><foo>bar</foo></midi-device>
      ''';
      expect(
        () => MidiDevice.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<InvalidXmlElementException>()),
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
        throwsA(isA<InvalidMusicXmlType>()),
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
        throwsA(isA<InvalidMusicXmlType>()),
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
        throwsA(isA<InvalidMusicXmlType>()),
      );
    });
  });
  });
}
