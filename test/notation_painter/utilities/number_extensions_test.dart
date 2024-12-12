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

  group('NumberExtensions.limit', () {
    test('Should return the number if no limits are provided', () {
      expect(5.limit(), equals(5));
      expect((-10).limit(), equals(-10));
      expect(0.limit(), equals(0));
    });

    test('Should enforce the bottom limit', () {
      expect(5.limit(bottom: 10), equals(10));
      expect((-10).limit(bottom: -5), equals(-5));
      expect(0.limit(bottom: 0), equals(0));
    });

    test('Should enforce the top limit', () {
      expect(15.limit(top: 10), equals(10));
      expect((-5).limit(top: -10), equals(-10));
      expect(10.limit(top: 10), equals(10));
    });

    test('Should clamp the number within both bottom and top limits', () {
      expect(7.limit(bottom: 5, top: 10), equals(7));
      expect(3.limit(bottom: 5, top: 10), equals(5));
      expect(15.limit(bottom: 5, top: 10), equals(10));
    });

    test('Should handle cases where bottom and top are the same', () {
      expect(7.limit(bottom: 5, top: 5), equals(5));
      expect(5.limit(bottom: 5, top: 5), equals(5));
    });

    test('Should handle cases with negative numbers', () {
      expect((-7).limit(bottom: -10, top: -5), equals(-7));
      expect((-15).limit(bottom: -10, top: -5), equals(-10));
      expect((-3).limit(bottom: -10, top: -5), equals(-5));
    });

    test('Should work with positive decimals', () {
      expect(5.5.limit(bottom: 5.0, top: 6.0), equals(5.5));
      expect(4.9.limit(bottom: 5.0, top: 6.0), equals(5.0));
      expect(6.1.limit(bottom: 5.0, top: 6.0), equals(6.0));
    });

    test('Should work with negative decimals', () {
      expect((-5.5).limit(bottom: -6.0, top: -5.0), equals(-5.5));
      expect((-6.1).limit(bottom: -6.0, top: -5.0), equals(-6.0));
      expect((-4.9).limit(bottom: -6.0, top: -5.0), equals(-5.0));
    });

    test('Should handle mixed decimal limits (negative and positive)', () {
      expect((-0.5).limit(bottom: -1.0, top: 0.0), equals(-0.5));
      expect((-1.5).limit(bottom: -1.0, top: 0.0), equals(-1.0));
      expect(0.5.limit(bottom: -1.0, top: 0.0), equals(0.0));
    });
  });
}
