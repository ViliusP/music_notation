import 'package:music_notation/src/notation_painter/utilities/list_extensions.dart';
import 'package:test/test.dart';

void main() {
  group("ListExtensions.everyNth", () {
    test("Returns every nth element from a list of integers", () {
      final list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      expect(list.everyNth(2), equals([1, 3, 5, 7, 9]));
      expect(list.everyNth(3), equals([1, 4, 7, 10]));
    });

    test("Returns every nth element from a list of strings", () {
      final list = ["a", "b", "c", "d", "e"];
      expect(list.everyNth(2), equals(["a", "c", "e"]));
      expect(list.everyNth(3), equals(["a", "d"]));
    });

    test("Handles n greater than list length", () {
      final list = [1, 2, 3];
      // Only the first element is returned
      expect(list.everyNth(5), equals([1]));
    });

    test("Handles n equal to 1 (returns full list)", () {
      final list = [1, 2, 3, 4, 5];
      expect(list.everyNth(1), equals([1, 2, 3, 4, 5]));
    });

    test("Returns empty list for empty input", () {
      final list = <int>[];
      expect(list.everyNth(2), equals([]));
    });

    test("Throws ArgumentError for n <= 0", () {
      final list = [1, 2, 3];
      expect(() => list.everyNth(0), throwsArgumentError);
      expect(() => list.everyNth(-1), throwsArgumentError);
    });
  });
}
