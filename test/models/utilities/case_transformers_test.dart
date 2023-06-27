import 'package:flutter_test/flutter_test.dart';
import 'package:music_notation/src/models/utilities/case_transformers.dart';

void main() {
  group("Hyphen to camel", () {});
  group("Camel to hyphen", () {});
  group("Setence to camel", () {
    List<(String input, String expectedOutput)> inputsOuputs = [
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
    for (var inputOuput in inputsOuputs) {
      String input = inputOuput.$1;
      String expectedOutput = inputOuput.$2;

      test("should convert $input to $expectedOutput", () {
        String result = sentenceCaseToCamelCase(input);
        expect(result, expectedOutput);
      });
    }
  });
}
