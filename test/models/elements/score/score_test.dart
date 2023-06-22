import 'dart:io';

import 'package:music_notation/music_notation.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

import '../../test_path.dart';

void main() {
  group('ScorePartwise', () {
    // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/group-abbreviation-display-element/
    test('should parse <assess> and <player> example correctly', () {
      final inputFile = File(
        testPath('models/test_resources/assess_player.xml'),
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
        testPath('models/test_resources/concert_score_and_for_part.xml'),
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
}
