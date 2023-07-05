import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/elements/music_data/note/lyric.dart';
import 'package:music_notation/src/models/elements/text/text.dart';
import 'package:xml/xml.dart';

void main() {
  group("TextElementData", () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/assess-and-player-elements/
    test("should parse text element from '<assess> and <player>' example", () {
      String input = '''
        <text>Ah</text>
      ''';

      var text = TextElementData.fromXml(XmlDocument.parse(input).rootElement);
      expect(text.value, "Ah");

      // Attributes
      expect(text.color.value, isNull);
      expect(text.direction, isNull);
      expect(text.font.family, isNull);
      expect(text.font.size, isNull);
      expect(text.font.style, isNull);
      expect(text.font.weight, isNull);
      expect(text.letterSpacing, isNull);
      expect(text.decoration.lineThrough, NumberOfLines.none);
      expect(text.decoration.overline, NumberOfLines.none);
      expect(text.rotation, isNull);
      expect(text.decoration.underline, NumberOfLines.none);
      expect(text.lang, isNull);
    });
  });
