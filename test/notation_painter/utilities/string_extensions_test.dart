import 'package:music_notation/src/notation_painter/utilities/string_extensions.dart';
import 'package:test/test.dart';

void main() {
  group('FormattingExtension - padCenter', () {
    test('Pads a string evenly when total padding is even', () {
      const input = 'center';
      final result = input.padCenter(10);
      expect(result, equals('  center  '));
    });

    test('Adds one extra space to the right when total padding is odd', () {
      const input = 'center';
      final result = input.padCenter(11);
      expect(result, equals('  center   '));
    });

    test('Returns the original string when width is equal to the string length',
        () {
      const input = 'center';
      final result = input.padCenter(input.length);
      expect(result, equals(input));
    });

    test('Returns the original string when width is less than string length',
        () {
      const input = 'center';
      final result = input.padCenter(4);
      expect(result, equals(input));
    });

    test('Handles empty strings', () {
      const input = '';
      final result = input.padCenter(5);
      expect(result, equals('     ')); // 5 spaces
    });

    test('Handles width of zero for any string', () {
      const input = 'test';
      final result = input.padCenter(0);
      expect(result, equals(input));
    });

    test('Handles width of zero for an empty string', () {
      const input = '';
      final result = input.padCenter(0);
      expect(result, equals(''));
    });

    test('Returns the original string for negative width', () {
      const input = 'negative';
      final result = input.padCenter(-5);
      expect(result, equals(input));
    });
  });
}
