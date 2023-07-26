import 'dart:io';

import 'package:music_notation/src/models/elements/link.dart';
import 'package:music_notation/src/models/elements/score/score.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

import '../../../test_path.dart';

void main() {
  group('ScorePartwise', () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/group-abbreviation-display-element/
    test('should parse <assess> and <player> example correctly', () {
      final inputFile = File(
        testPath('/test_resources/assess_player.xml'),
      );

      var rootElement = XmlDocument.parse(inputFile.readAsStringSync());

      var scorePartwise = ScorePartwise.fromXml(rootElement);

      expect(scorePartwise.version, "4.0");
      expect(scorePartwise.parts.length, 1);
      expect(scorePartwise.scoreHeader.work, isNull);
      expect(scorePartwise.scoreHeader.movementNumber, isNull);
      expect(scorePartwise.scoreHeader.movementTitle, isNull);
      expect(scorePartwise.scoreHeader.identification, isNull);
      expect(scorePartwise.scoreHeader.defaults, isNull);
      expect(scorePartwise.scoreHeader.credits.length, 0);
      expect(scorePartwise.scoreHeader.partList, isNotNull);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/concert-score-and-for-part-elements/
    test('should parse <concert-score> and <for-part> example correctly', () {
      final inputFile = File(
        testPath('/test_resources/concert_score_and_for_part.xml'),
      );

      var rootElement = XmlDocument.parse(inputFile.readAsStringSync());

      var scorePartwise = ScorePartwise.fromXml(rootElement);

      expect(scorePartwise.version, "4.0");
      expect(scorePartwise.parts.length, 3);
      expect(scorePartwise.scoreHeader.work, isNull);
      expect(scorePartwise.scoreHeader.movementNumber, isNull);
      expect(scorePartwise.scoreHeader.movementTitle, "C Sounds");
      expect(scorePartwise.scoreHeader.identification, isNull);
      expect(scorePartwise.scoreHeader.defaults, isNotNull);
      expect(scorePartwise.scoreHeader.credits.length, 1);
      expect(scorePartwise.scoreHeader.partList, isNotNull);
    });
  });
  group('Work', () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/work-element/
    test("should correctly parse <work> example", () {
      String input = '''
        <work>
          <work-number>D. 911</work-number>
          <work-title>Winterreise</work-title>
          <opus xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="opus/winterreise.musicxml" xlink:show="new"/>
        </work>
      ''';

      var work = Work.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(work.number, "D. 911");
      expect(work.title, "Winterreise");
      expect(work.opus?.href, "opus/winterreise.musicxml");
      expect(work.opus?.show, XLinkShow.new_);
    });
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/movement-number-and-movement-title-elements/
    test(
        "should correctly parse <movement-number> and <movement-title> example",
        () {
      String input = '''
        <work>
          <work-number>D. 911</work-number>
          <work-title>Winterreise</work-title>
        </work>
      ''';

      var work = Work.fromXml(
        XmlDocument.parse(input).rootElement,
      );

      expect(work.number, "D. 911");
      expect(work.title, "Winterreise");
      expect(work.opus, isNull);
    });
    test("should throw if work-number has invalid content", () {
      String input = '''
        <work>
          <work-number><foo/></work-number>
          <work-title>Winterreise</work-title>
          <opus xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="opus/winterreise.musicxml" xlink:show="new"/>
        </work>
      ''';

      expect(
        () => Work.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("should throw if work-title has invalid content", () {
      String input = '''
        <work>
          <work-number>991</work-number>
          <work-title><foo/></work-title>
          <opus xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="opus/winterreise.musicxml" xlink:show="new"/>
        </work>
      ''';

      expect(
        () => Work.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<XmlElementContentException>()),
      );
    });
    test("should throw if order of elements in out of order", () {
      String input = '''
        <work>
          <work-number>991</work-number>
          <opus xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="opus/winterreise.musicxml" xlink:show="new"/>
          <work-title>foo</work-title>
        </work>
      ''';

      expect(
        () => Work.fromXml(
          XmlDocument.parse(input).rootElement,
        ),
        throwsA(isA<XmlSequenceException>()),
      );
    });
  });
}
