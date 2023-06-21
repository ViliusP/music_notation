import 'package:music_notation/src/models/elements/score/instruments.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('Score instrument parsing', () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/assess-and-player-elements/
    test('should score-instrument from <assess> and <player> example correctly',
        () {
      String input1 = '''
          <score-instrument id="P1-I1">
            <instrument-name>ARIA Player</instrument-name>
            <instrument-sound>voice.soprano</instrument-sound>
          </score-instrument>
      ''';

      String input2 = '''
          <score-instrument id="P1-I2">
            <instrument-name>ARIA Player</instrument-name>
            <instrument-sound>voice.alto</instrument-sound>
          </score-instrument>
      ''';

      var scoreInstrument1 = ScoreInstrument.fromXml(
        XmlDocument.parse(input1).rootElement,
      );

      var scoreInstrument2 = ScoreInstrument.fromXml(
        XmlDocument.parse(input2).rootElement,
      );

      expect(scoreInstrument1.id, "P1-I1");
      expect(scoreInstrument1.instrumentName, "ARIA Player");
      expect(
        scoreInstrument1.virtualInstrumentData.instrumentSound,
        "voice.soprano",
      );
      expect(scoreInstrument2.id, "P1-I2");
      expect(scoreInstrument2.instrumentName, "ARIA Player");
      expect(
        scoreInstrument2.virtualInstrumentData.instrumentSound,
        "voice.alto",
      );
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/ensemble-element/
    test('should parse from <ensemble> example correctly', () {
      String input = '''
        <score-instrument id="P1-I1">
            <instrument-name>ARIA Player</instrument-name>
            <instrument-sound>strings.viola</instrument-sound>
            <ensemble/>
            <virtual-instrument>
              <virtual-library>Garritan Instruments for Finale</virtual-library>
              <virtual-name>008. Section Strings/2. Violas/Violas KS</virtual-name>
            </virtual-instrument>
        </score-instrument>
      ''';

      var scoreInstrument = ScoreInstrument.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(scoreInstrument.id, "P1-I1");
      expect(scoreInstrument.instrumentName, "ARIA Player");
      expect(
        scoreInstrument.virtualInstrumentData.instrumentSound,
        "strings.viola",
      );
      expect(
        scoreInstrument.virtualInstrumentData.performanceType,
        isA<Ensemble>(),
      );
      expect(
        scoreInstrument.virtualInstrumentData.virtualInstrument?.virtualLibrary,
        "Garritan Instruments for Finale",
      );
      expect(
        scoreInstrument.virtualInstrumentData.virtualInstrument?.virtualName,
        "008. Section Strings/2. Violas/Violas KS",
      );
    });

    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/instrument-change-element/
    test('should parse from <instrument-change> example correctly', () {
      String input = '''
         <score-instrument id="P1-I1">
            <instrument-name>ARIA Player</instrument-name>
            <instrument-sound>wind.reed.clarinet.bflat</instrument-sound>
            <solo/>
            <virtual-instrument>
               <virtual-library>Garritan Jazz and Big Band 3</virtual-library>
               <virtual-name>Notation/01 Saxes and Woodwinds/Clarinets/n-Bb Clarinet 1</virtual-name>
            </virtual-instrument>
         </score-instrument>
      ''';

      var scoreInstrument = ScoreInstrument.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(scoreInstrument.id, "P1-I1");
      expect(scoreInstrument.instrumentName, "ARIA Player");
      expect(
        scoreInstrument.virtualInstrumentData.instrumentSound,
        "wind.reed.clarinet.bflat",
      );
      expect(
        scoreInstrument.virtualInstrumentData.performanceType,
        isA<Solo>(),
      );
      expect(
        scoreInstrument.virtualInstrumentData.virtualInstrument?.virtualLibrary,
        "Garritan Jazz and Big Band 3",
      );
      expect(
        scoreInstrument.virtualInstrumentData.virtualInstrument?.virtualName,
        "Notation/01 Saxes and Woodwinds/Clarinets/n-Bb Clarinet 1",
      );
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/instrument-link-element/
    test('should parse from <<instrument-link>> example correctly', () {
      String input = '''
        <score-instrument id="P1-I1">
          <instrument-name>ARIA Player</instrument-name>
          <instrument-sound>wind.reed.clarinet.bflat</instrument-sound>
          <virtual-instrument>
              <virtual-library>Garritan Personal Orchestra 5</virtual-library>
              <virtual-name>Notation/01 Woodwinds/03 Clarinets/n-Bb Clarinet Plr1</virtual-name>
          </virtual-instrument>
        </score-instrument>
      ''';

      var scoreInstrument = ScoreInstrument.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(scoreInstrument.id, "P1-I1");
      expect(scoreInstrument.instrumentName, "ARIA Player");
      expect(
        scoreInstrument.virtualInstrumentData.instrumentSound,
        "wind.reed.clarinet.bflat",
      );
      expect(
        scoreInstrument.virtualInstrumentData.virtualInstrument?.virtualLibrary,
        "Garritan Personal Orchestra 5",
      );
      expect(
        scoreInstrument.virtualInstrumentData.virtualInstrument?.virtualName,
        "Notation/01 Woodwinds/03 Clarinets/n-Bb Clarinet Plr1",
      );
    });
  });
  group('Ensemble', () {
    test('should parse size correctly', () {
      String input = '''
        <ensemble>5</ensemble>
      ''';

      var scoreInstrument = Ensemble.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(scoreInstrument.size, 5);
    });
    test('should throw on invalid content correctly', () {
      String input = '''
        <ensemble>foobar</ensemble>
      ''';

      expect(
        () => Ensemble.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<InvalidXmlElementException>()),
      );
    });
  });
  group('VirtualInstrument', () {
    test('should throw on invalid virtual-library content', () {
      String input = '''
        <virtual-instrument>
          <virtual-library><foo-bar></foo-bar></virtual-library>
        </virtual-instrument>
      ''';

      expect(
        () => VirtualInstrument.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<InvalidXmlElementException>()),
      );
    });
    test('should throw on invalid virtual-name content', () {
      String input = '''
        <virtual-instrument>
          <virtual-name><foo-bar></foo-bar></virtual-name>
        </virtual-instrument>
      ''';

      expect(
        () => VirtualInstrument.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<InvalidXmlElementException>()),
      );
    });
  });
}
