import 'package:music_notation/src/notation_painter/utilities/number_extensions.dart';
import 'package:test/test.dart';

void main() {
  group("NumberExtensions.nearestMultiple", () {
    test("Finds nearest larger multiple with positive base", () {
      expect(17.0.nearestMultiple(of: 5), equals(20.0));
      expect(23.0.nearestMultiple(of: 4), equals(24.0));
      // Already a multiple
      expect(10.0.nearestMultiple(of: 10), equals(10.0));
      // Already a multiple
      expect(10.0.nearestMultiple(of: 5), equals(10.0));
    });

    test("Finds nearest smaller multiple with negative base", () {
      expect(17.0.nearestMultiple(of: -5), equals(15.0));
      expect(23.0.nearestMultiple(of: -4), equals(20.0));
      // Already a multiple
      expect(10.0.nearestMultiple(of: -10), equals(10.0));
    });

    test("Handles positive numbers with positive and negative bases", () {
      // Round up
      expect(17.0.nearestMultiple(of: 5), equals(20.0));
      // Round down
      expect(17.0.nearestMultiple(of: -5), equals(15.0));
    });

    test("Handles negative numbers with positive and negative bases", () {
      // Round up
      expect((-17.0).nearestMultiple(of: 5), equals(-15.0));
      // Round down
      expect((-17.0).nearestMultiple(of: -5), equals(-20.0));
    });

    test("Throws ArgumentError on zero base", () {
      expect(() => 17.0.nearestMultiple(of: 0), throwsArgumentError);
    });
  });

  group("NumberExtensions.directionalCeilToDouble", () {
    test("Positive numbers", () {
      expect(1.3.roundAwayFromZero(), equals(2.0));
      expect(2.7.roundAwayFromZero(), equals(3.0));
      expect(19.9.roundAwayFromZero(), equals(20.0));
    });

    test("Negative numbers", () {
      expect((-1.3).roundAwayFromZero(), equals(-2.0));
      expect((-2.7).roundAwayFromZero(), equals(-3.0));
      expect((-29.9).roundAwayFromZero(), equals(-30.0));
    });

    test("Whole numbers", () {
      expect(1.0.roundAwayFromZero(), equals(1.0));
      expect(-1.0.roundAwayFromZero(), equals(-1.0));
      expect(10.0.roundAwayFromZero(), equals(10.0));
      expect(-10.0.roundAwayFromZero(), equals(-10.0));
    });

    test("Edge cases with zero", () {
      expect(0.roundAwayFromZero(), equals(0.0));
      expect(0.0.roundAwayFromZero(), equals(0.0));
    });

    test("Small fractions", () {
      expect(0.1.roundAwayFromZero(), equals(1.0));
      expect(-0.1.roundAwayFromZero(), equals(-1.0));
      expect(0.9.roundAwayFromZero(), equals(1.0));
      expect(-0.9.roundAwayFromZero(), equals(-1.0));
    });
  });

  group("NumberExtensions.roundTowardsZero", () {
    test("Positive numbers", () {
      expect(1.3.roundTowardsZero(), equals(1.0));
      expect(2.7.roundTowardsZero(), equals(2.0));
      expect(19.9.roundTowardsZero(), equals(19.0));
    });

    test("Negative numbers", () {
      expect((-1.3).roundTowardsZero(), equals(-1.0));
      expect((-2.7).roundTowardsZero(), equals(-2.0));
      expect((-29.9).roundTowardsZero(), equals(-29.0));
    });

    test("Whole numbers", () {
      expect(1.0.roundTowardsZero(), equals(1.0));
      expect(-1.0.roundTowardsZero(), equals(-1.0));
      expect(10.0.roundTowardsZero(), equals(10.0));
      expect(-10.0.roundTowardsZero(), equals(-10.0));
    });

    test("Edge cases with zero", () {
      expect(0.roundTowardsZero(), equals(0.0));
      expect(0.0.roundTowardsZero(), equals(0.0));
    });

    test("Small fractions", () {
      expect(0.1.roundTowardsZero(), equals(0.0));
      expect(-0.1.roundTowardsZero(), equals(0.0));
      expect(0.9.roundTowardsZero(), equals(0.0));
      expect(-0.9.roundTowardsZero(), equals(0.0));
    });
  });
}
