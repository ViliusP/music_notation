import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/utilities/case_transformers.dart';

void main() {
  group("Hyphen to camel", () {
    List<(String input, String expectedOutput)> inputsOutputs = [
      ('this-is-a-test', 'thisIsATest'),
      ('hello-world', 'helloWorld'),
      ('test', 'test'),
      ('', ''),
      ('music-xml-parser', 'musicXmlParser'),
      ('dashed-string', 'dashedString'),
      ('a-b-c-d', 'aBCD'),
      (
        'multiple-words-in-hyphen-separated-string',
        'multipleWordsInHyphenSeparatedString'
      ),
      ('only-one-word', 'onlyOneWord'),
      ('word', 'word'),
      ('hyphen-at-end-', 'hyphenAtEnd'),
      ('-hyphen-at-start', 'HyphenAtStart'),
      ('two--hyphens', 'twoHyphens'),
      ('--two-hyphens-at-start', 'TwoHyphensAtStart'),
      ('two-hyphens-at-end--', 'twoHyphensAtEnd'),
    ];
    for (var inputOuput in inputsOutputs) {
      String input = inputOuput.$1;
      String expectedOutput = inputOuput.$2;

      test("should convert '$input' to '$expectedOutput'", () {
        String result = hyphenToCamelCase(input);
        expect(result, expectedOutput);
      });
    }
  });
  group("Camel to hyphen", () {});
  group("Setence to camel", () {
    List<(String input, String expectedOutput)> inputsOutputs = [
      ("", ""),
      ('tuplet bracket', 'tupletBracket'),
      ('beam', 'beam'),
      ('light barline', 'lightBarline'),
      ('heavy barline', 'heavyBarline'),
      ('octave shift', 'octaveShift'),
      ('slur middle', 'slurMiddle'),
      ('slur tip', 'slurTip'),
      ('tie middle', 'tieMiddle'),
      ('tie tip', 'tieTip'),
      ('staff', 'staff'),
      ('stem', 'stem'),
      ('wedge', 'wedge'),
      ('ending', 'ending'),
      ('extend', 'extend'),
      ('pedal', 'pedal'),
      ('dashes', 'dashes'),
      ('enclosure', 'enclosure'),
      ('leger', 'leger'),
      ('bracket', 'bracket'),
      ('some custom type', 'someCustomType'),
      ('another custom type', 'anotherCustomType'),
    ];
    for (var inputOuput in inputsOutputs) {
      String input = inputOuput.$1;
      String expectedOutput = inputOuput.$2;

      test("should convert $input to $expectedOutput", () {
        String result = sentenceCaseToCamelCase(input);
        expect(result, expectedOutput);
      });
    }
  });
  group("Camel to sentence case", () {
    List<(String input, String expectedOutput)> inputsOutputs = [
      ("", ""),
      ('tupletBracket', 'tuplet bracket'),
      ('beam', 'beam'),
      ('lightBarline', 'light barline'),
      ('heavyBarline', 'heavy barline'),
      ('octaveShift', 'octave shift'),
      ('slurMiddle', 'slur middle'),
      ('slurTip', 'slur tip'),
      ('tieMiddle', 'tie middle'),
      ('tieTip', 'tie tip'),
      ('staff', 'staff'),
      ('stem', 'stem'),
      ('wedge', 'wedge'),
      ('ending', 'ending'),
      ('extend', 'extend'),
      ('pedal', 'pedal'),
      ('dashes', 'dashes'),
      ('enclosure', 'enclosure'),
      ('leger', 'leger'),
      ('bracket', 'bracket'),
      ('someCustomType', 'some custom type'),
      ('anotherCustomType', 'another custom type'),
      ('evenMoreCustomType', 'even more custom type'),
      (
        'reallyLongCustomTypeWithLotsOfWords',
        'really long custom type with lots of words',
      ),
      ('yetAnotherCustomType', 'yet another custom type'),
    ];

    for (var inputOuput in inputsOutputs) {
      String input = inputOuput.$1;
      String expectedOutput = inputOuput.$2;

      test("should convert $input to $expectedOutput", () {
        String result = camelCaseToSentenceCase(input);
        expect(result, expectedOutput);
      });
    }
  });
}
