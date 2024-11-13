import 'package:music_notation/src/notation_painter/utilities/number_extensions.dart';
import 'package:test/test.dart';

void main() {
  group("NumberExtensions.nearestMultiple", () {
    test("Finds nearest larger multiple with positive base", () {
      expect(17.0.nearestMultiple(of: 5.0), equals(20.0));
      expect(23.0.nearestMultiple(of: 4.0), equals(24.0));
      // Already a multiple
      expect(10.0.nearestMultiple(of: 10.0), equals(10.0));
      // Already a multiple
      expect(10.0.nearestMultiple(of: 5.0), equals(10.0));
    });

    test("Finds nearest smaller multiple with negative base", () {
      expect(17.0.nearestMultiple(of: -5.0), equals(15.0));
      expect(23.0.nearestMultiple(of: -4.0), equals(20.0));
      // Already a multiple
      expect(10.0.nearestMultiple(of: -10.0), equals(10.0));
    });

    test("Handles positive numbers with positive and negative bases", () {
      // Round up
      expect(17.0.nearestMultiple(of: 5.0), equals(20.0));
      // Round down
      expect(17.0.nearestMultiple(of: -5.0), equals(15.0));
    });

    test("Handles negative numbers with positive and negative bases", () {
      // Round up
      expect((-17.0).nearestMultiple(of: 5.0), equals(-15.0));
      // Round down
      expect((-17.0).nearestMultiple(of: -5.0), equals(-20.0));
    });

    test("Handles non-integer bases", () {
      // Round up
      expect(17.0.nearestMultiple(of: 2.5), equals(17.5));
      // Round down
      expect(17.0.nearestMultiple(of: -2.5), equals(15.0));
    });

    test("Throws ArgumentError on zero base", () {
      expect(() => 17.0.nearestMultiple(of: 0), throwsArgumentError);
    });
  });
}
