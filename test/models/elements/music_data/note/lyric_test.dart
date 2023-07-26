import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/data_types/start_stop.dart';
import 'package:music_notation/src/models/elements/music_data/note/lyric.dart';
import 'package:music_notation/src/models/elements/text/text.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

void main() {
  group("Lyric", () {
    test("should parse <assess> and <player> example", () {
      String input = '''
        <lyric default-y="-62" justify="left" number="1">
          <syllabic>single</syllabic>
          <text>Ah</text>
          <extend type="start"/>
        </lyric>
      ''';

      var lyric = Lyric.fromXml(XmlDocument.parse(input).rootElement);
      expect(lyric.content, isA<TextLyric>());
      var textLyric = lyric.content as TextLyric;

      expect(textLyric.textParts.length, 2);
      expect(textLyric.textParts[0], isA<Syllabic>());
      var syllabic = textLyric.textParts[0] as Syllabic;
      expect(syllabic, Syllabic.single);

      expect(textLyric.textParts[1], isA<TextElementData>());
      var text = textLyric.textParts[1] as TextElementData;
      expect(text.value, "Ah");

      expect(textLyric.extend, isNotNull);

      expect(lyric.endLine, isNull);
      expect(lyric.endParagraph, isNull);
      expect(lyric.editorial.footnote, isNull);
      expect(lyric.editorial.level, isNull);

      // Attributes
      expect(lyric.color.value, isNull);
      expect(lyric.position.defaultX, isNull);
      expect(lyric.position.defaultY, -62);
      expect(lyric.id, isNull);
      expect(lyric.justify, HorizontalAlignment.left);
      expect(lyric.name, isNull);
      expect(lyric.number, "1");
      expect(lyric.placement, isNull);
      expect(lyric.printObject, true);
      expect(lyric.position.relativeX, isNull);
      expect(lyric.position.relativeY, isNull);
      expect(lyric.timeOnly, isNull);
    });
    test("should parse <elision> example", () {
      String input = '''
        <lyric default-y="-80" number="1">
          <syllabic>end</syllabic>
          <text>cro</text>
          <elision>‿</elision>
          <syllabic>single</syllabic>
          <text>a</text>
        </lyric>
      ''';

      var lyric = Lyric.fromXml(XmlDocument.parse(input).rootElement);
      expect(lyric.content, isA<TextLyric>());
      var textLyric = lyric.content as TextLyric;

      expect(textLyric.textParts.length, 5);
      expect(textLyric.textParts[0], isA<Syllabic>());
      var syllabic = textLyric.textParts[0] as Syllabic;
      expect(syllabic, Syllabic.end);

      expect(textLyric.textParts[1], isA<TextElementData>());
      var text = textLyric.textParts[1] as TextElementData;
      expect(text.value, "cro");

      expect(textLyric.textParts[2], isA<Elision>());
      var elision = textLyric.textParts[2] as Elision;
      expect(elision.value, "‿");

      expect(textLyric.textParts[3], isA<Syllabic>());
      var syllabic2 = textLyric.textParts[3] as Syllabic;
      expect(syllabic2, Syllabic.single);

      expect(textLyric.textParts[4], isA<TextElementData>());
      var text2 = textLyric.textParts[4] as TextElementData;
      expect(text2.value, "a");

      expect(textLyric.extend, isNull);

      expect(lyric.endLine, isNull);
      expect(lyric.endParagraph, isNull);
      expect(lyric.editorial.footnote, isNull);
      expect(lyric.editorial.level, isNull);

      // Attributes
      expect(lyric.color.value, isNull);
      expect(lyric.position.defaultX, isNull);
      expect(lyric.position.defaultY, -80);
      expect(lyric.id, isNull);
      expect(lyric.justify, null);
      expect(lyric.name, isNull);
      expect(lyric.number, "1");
      expect(lyric.placement, isNull);
      expect(lyric.printObject, true);
      expect(lyric.position.relativeX, isNull);
      expect(lyric.position.relativeY, isNull);
      expect(lyric.timeOnly, isNull);
    });

    test("parsing should thrown on invalid child elements order", () {
      String input = '''
        <lyric default-y="-80" number="1">
          <text>cro</text>
          <syllabic>end</syllabic>
          <elision>‿</elision>
          <syllabic>single</syllabic>
          <text>a</text>
        </lyric>
      ''';

      expect(
        () => Lyric.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlSequenceException>()),
      );
    });
  });
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
  group("Elision", () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/elision-element/
    test("should parse elision element from '<elision>' example", () {
      String input = '''
        <elision>‿</elision>
      ''';

      var text = Elision.fromXml(XmlDocument.parse(input).rootElement);
      expect(text.value, "‿");

      // Attributes
      expect(text.color.value, isNull);
      expect(text.font.family, isNull);
      expect(text.font.size, isNull);
      expect(text.font.style, isNull);
      expect(text.font.weight, isNull);
      expect(text.smufl, isNull);
    });
    test("should parse elision element from '<ipa>' example", () {
      String input = '''
        <elision/>
      ''';

      var text = Elision.fromXml(XmlDocument.parse(input).rootElement);
      expect(text.value, isNull);

      // Attributes
      expect(text.color.value, isNull);
      expect(text.font.family, isNull);
      expect(text.font.size, isNull);
      expect(text.font.style, isNull);
      expect(text.font.weight, isNull);
      expect(text.smufl, isNull);
    });
    test("parsing should should throw on invalid content", () {
      String input = '''
        <elision><foo></foo></elision>
      ''';

      expect(
        () => Elision.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
  });
  group("Extend", () {
    test("should parse from '<assess> and <player>' example", () {
      String input = '''
        <extend type="start"/>
      ''';

      var extend = Extend.fromXml(XmlDocument.parse(input).rootElement);
      expect(extend.type, StartStopContinue.start);

      // Attributes
      expect(extend.color.value, isNull);
      expect(extend.position.defaultX, isNull);
      expect(extend.position.defaultY, isNull);
      expect(extend.position.relativeX, isNull);
      expect(extend.position.relativeY, isNull);
    });
    test("parsing should should throw on text content", () {
      String input = '''
        <extend type="start">foo</extend>
      ''';

      expect(
        () => Extend.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("parsing should should throw on invalid content", () {
      String input = '''
        <extend type="start"><foo/></extend>
      ''';

      expect(
        () => Extend.fromXml(XmlDocument.parse(input).rootElement),
        throwsA(isA<XmlElementContentException>()),
      );
    });
  });
}
