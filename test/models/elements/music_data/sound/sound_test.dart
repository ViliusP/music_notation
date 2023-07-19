import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/elements/music_data/sound/sound.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

void main() {
  group('Sound', () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/tutorial-apres-un-reve/
    group("should be parsed from Tutorial: Après un rêve", () {
      test("#1", () {
        String input = """
          <sound tempo="60"/>
        """;

        var sound = Sound.fromXml(XmlDocument.parse(input).rootElement);

        expect(sound.coda, isNull);
        expect(sound.dacapo, isNull);
        expect(sound.dalsegno, isNull);
        expect(sound.damperPedal, isNull);
        expect(sound.divisions, isNull);
        expect(sound.dynamics, isNull);
        expect(sound.elevation, isNull);
        expect(sound.fine, isNull);
        expect(sound.forwardRepeat, isNull);
        expect(sound.id, isNull);
        expect(sound.pan, isNull);
        expect(sound.pizzicato, isNull);
        expect(sound.segno, isNull);
        expect(sound.sostenutoPedal, isNull);
        expect(sound.tempo, 60);
        expect(sound.timeOnly, isNull);
        expect(sound.tocoda, isNull);
      });
      test("#2", () {
        String input = """
          <sound dynamics="40"/>
        """;

        var sound = Sound.fromXml(XmlDocument.parse(input).rootElement);

        expect(sound.coda, isNull);
        expect(sound.dacapo, isNull);
        expect(sound.dalsegno, isNull);
        expect(sound.damperPedal, isNull);
        expect(sound.divisions, isNull);
        expect(sound.dynamics, 40);
        expect(sound.elevation, isNull);
        expect(sound.fine, isNull);
        expect(sound.forwardRepeat, isNull);
        expect(sound.id, isNull);
        expect(sound.pan, isNull);
        expect(sound.pizzicato, isNull);
        expect(sound.segno, isNull);
        expect(sound.sostenutoPedal, isNull);
        expect(sound.tempo, isNull);
        expect(sound.timeOnly, isNull);
        expect(sound.tocoda, isNull);
      });
    });
    group("parsing should throw exception", () {
      test("on invalid tempo attribute", () {
        String input = """
          <sound tempo="foo"/>
        """;

        expect(
          () => Sound.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MusicXmlFormatException>()),
        );
      });
      test("on invalid dynamics attribute", () {
        String input = """
          <sound dynamics="foo"/>
        """;

        expect(
          () => Sound.fromXml(XmlDocument.parse(input).rootElement),
          throwsA(isA<MusicXmlFormatException>()),
        );
      });
    });
  });
}
