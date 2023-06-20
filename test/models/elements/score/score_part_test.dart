import 'package:music_notation/src/models/elements/score/score_part.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('Score part parsing', () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/assess-and-player-elements/
    test('should score-part list from <assess> and <player> example correctly',
        () {
      String input = '''
        <score-part id="P1">
          <part-name>Soprano Alto</part-name>
          <part-name-display>
            <display-text xml:space="preserve">Soprano Alto</display-text>
          </part-name-display>
          <score-instrument id="P1-I1">
            <instrument-name>ARIA Player</instrument-name>
            <instrument-sound>voice.soprano</instrument-sound>
          </score-instrument>
          <score-instrument id="P1-I2">
            <instrument-name>ARIA Player</instrument-name>
            <instrument-sound>voice.alto</instrument-sound>
          </score-instrument>
          <player id="P1-M1">
            <player-name>Soprano 1</player-name>
          </player>
          <player id="P1-M2">
            <player-name>Soprano 2</player-name>
          </player>
          <player id="P1-M3">
            <player-name>Alto 1</player-name>
          </player>
          <player id="P1-M4">
            <player-name>Alto 2</player-name>
          </player>
        </score-part>
      ''';

      var scorePart = ScorePart.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(scorePart.id, "P1");
      expect(scorePart.partName, isNotNull);
      expect(scorePart.partNameDisplay, isNotNull);
      expect(scorePart.scoreInstruments.length, 2);
      expect(scorePart.players.length, 4);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/concert-score-and-for-part-elements/
    test(
        'should score parts from <concert-score> and <for-part> example correctly',
        () {
      String input = '''
        <score-part id="P1">
          <part-name>Piccolo</part-name>
          <group>score</group>
        </score-part>
        <score-part id="P2">
          <part-name>Oboe</part-name>
          <group>score</group>
        </score-part>
        <score-part id="P3">
          <part-name>Bass Clarinet</part-name>
          <group>score</group>
        </score-part>
      ''';

      var scorePart = ScorePart.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(scorePart.id, "P1");
      expect(scorePart.partName, isNotNull);
      expect(scorePart.partNameDisplay, isNotNull);
      expect(scorePart.scoreInstruments.length, 2);
      expect(scorePart.players.length, 4);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/ensemble-element/
    test('should score parts from  <ensemble> example correctly', () {
      String input = '''
        <score-part id="P1">
          <part-name>Viola.</part-name>
          <group>score</group>
          <score-instrument id="P1-I1">
              <instrument-name>ARIA Player</instrument-name>
              <instrument-sound>strings.viola</instrument-sound>
              <ensemble/>
              <virtual-instrument>
                <virtual-library>Garritan Instruments for Finale</virtual-library>
                <virtual-name>008. Section Strings/2. Violas/Violas KS</virtual-name>
              </virtual-instrument>
          </score-instrument>
        </score-part>
      ''';

      var scorePart = ScorePart.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(scorePart.id, "P1");
      expect(scorePart.partName, isNotNull);
      expect(scorePart.groups.length, 1);
      expect(scorePart.scoreInstruments.length, 1);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/instrument-change-element/
    test('should score parts from <instrument-change> example correctly', () {
      String input = '''
        <score-part id="P1">
          <part-name>Clarinet in Bb</part-name>
          <part-name-display>
              <display-text>Clarinet in B</display-text>
              <accidental-text>flat</accidental-text>
          </part-name-display>
          <part-abbreviation>Bb Cl.</part-abbreviation>
          <part-abbreviation-display>
              <display-text>B</display-text>
              <accidental-text>flat</accidental-text>
              <display-text>Cl.</display-text>
          </part-abbreviation-display>
          <group>score</group>
          <score-instrument id="P1-I1">
              <instrument-name>ARIA Player</instrument-name>
              <instrument-sound>wind.reed.clarinet.bflat</instrument-sound>
              <solo/>
              <virtual-instrument>
                <virtual-library>Garritan Jazz and Big Band 3</virtual-library>
                <virtual-name>Notation/01 Saxes and Woodwinds/Clarinets/n-Bb Clarinet 1</virtual-name>
              </virtual-instrument>
          </score-instrument>
          <midi-device>ARIA Player</midi-device>
          <midi-instrument id="P1-I1">
              <midi-channel>1</midi-channel>
              <midi-program>1</midi-program>
              <volume>80</volume>
              <pan>0</pan>
          </midi-instrument>
        </score-part>
      ''';

      var scorePart = ScorePart.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(scorePart.id, "P1");
      expect(scorePart.partName, isNotNull);
      expect(scorePart.partNameDisplay, isNotNull);
      expect(scorePart.partAbbreviation, isNotNull);
      expect(scorePart.partAbbreviationDisplay, isNotNull);
      expect(scorePart.groups.length, 1);
      expect(scorePart.scoreInstruments.length, 1);
      expect(scorePart.midiDevices.length, 1);
      expect(scorePart.midiInstruments.length, 1);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/instrument-link-element/
    test('should score parts from <instrument-link> example correctly', () {
      String input = '''
        <score-part id="P1">
            <part-link xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="p1.musicxml" xlink:title="Clarinet 1" xlink:show="new">
              <instrument-link id="P1-I1"/>
              <group-link>parts</group-link>
            </part-link>
            <part-link xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="p2.musicxml" xlink:title="Clarinet 2" xlink:show="new">
              <instrument-link id="P1-I2"/>
              <group-link>parts</group-link>
            </part-link>
            <part-name>Clarinets 1&2</part-name>
            <part-abbreviation>Cl. 1&2</part-abbreviation>
            <group>score</group>
            <score-instrument id="P1-I1">
              <instrument-name>ARIA Player</instrument-name>
              <instrument-sound>wind.reed.clarinet.bflat</instrument-sound>
              <virtual-instrument>
                  <virtual-library>Garritan Personal Orchestra 5</virtual-library>
                  <virtual-name>Notation/01 Woodwinds/03 Clarinets/n-Bb Clarinet Plr1</virtual-name>
              </virtual-instrument>
            </score-instrument>
            <score-instrument id="P1-I2">
              <instrument-name>ARIA Player</instrument-name>
              <instrument-sound>wind.reed.clarinet.bflat</instrument-sound>
              <virtual-instrument>
                  <virtual-library>Garritan Personal Orchestra 5</virtual-library>
                  <virtual-name>Notation/01 Woodwinds/03 Clarinets/n-Bb Clarinet Plr2</virtual-name>
              </virtual-instrument>
            </score-instrument>
        </score-part>
      ''';

      var scorePart = ScorePart.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(scorePart.id, "P1");
      expect(scorePart.partLinks.length, 2);
      expect(scorePart.partName, isNotNull);
      expect(scorePart.partAbbreviation, isNotNull);
      expect(scorePart.groups.length, 1);
      expect(scorePart.scoreInstruments.length, 2);
    });
    test('Should throw exception if "id" attribute is missing or empty', () {
      String input1 = '''
        <score-part id="">
          <part-name>Soprano Alto</part-name>
        </score-part>
      ''';

      String input2 = '''
        <score-part >
          <part-name>Soprano Alto</part-name>
        </score-part>
      ''';

      expect(
        () => ScorePart.fromXml(
          XmlDocument.parse(input1).rootElement,
        ),
        throwsA(isA<XmlAttributeRequired>()),
      );
      expect(
        () => ScorePart.fromXml(
          XmlDocument.parse(input2).rootElement,
        ),
        throwsA(isA<XmlAttributeRequired>()),
      );
    });
    test('Should throw exception if "part-name" element is missing', () {
      String input = '''
        <score-part id="P1">
        </score-part>
      ''';

      expect(
        () => ScorePart.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<InvalidXmlSequence>()),
      );
    });
  });
}
