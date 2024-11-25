extension NumExtensions on num {
  /// Finds the nearest multiple of base [of], rounding up if base [of] is positive
  /// or rounding down if [base] is negative.
  ///
  /// Parameters:
  /// - [of] - The base multiple to find. Must be non-zero.
  ///
  /// Returns:
  /// The nearest multiple of the magnitude of base [of] in the direction specified
  /// by its sign.
  ///
  /// Throws:
  /// - `ArgumentError` if base [of] is zero.
  int nearestMultiple({required int of}) {
    if (of == 0) {
      throw ArgumentError("Base must be non-zero");
    }

    // Determine rounding direction based on the sign of base
    return of > 0
        ? (this / of).ceil() * of // Round up for positive base
        : (this / of.abs()).floor() * of.abs(); // Round down for negative base
  }

  /// Returns the nearest integer double value by rounding away from zero.
  ///
  /// - For positive numbers, it rounds up to the next whole number as a double.
  /// - For negative numbers, it rounds down to the next whole number as a double.
  ///
  /// If this is already an integer-valued double, or it is not a finite value,
  /// the value is returned unmodified.
  ///
  /// Examples:
  /// ```dart
  /// print(1.3.roundAwayFromZero()); // 2.0
  /// print((-1.3).roundAwayFromZero()); // -2.0
  /// print(19.9.roundAwayFromZero()); // 20.0
  /// print((-29.9).roundAwayFromZero()); // -30.0
  /// print(0.roundAwayFromZero()); // 0.0
  /// print((-0.0).roundAwayFromZero()); // -0.0
  /// print(1.roundAwayFromZero()); // 1.0
  /// print(-10.roundAwayFromZero()); // -10.0
  /// ```
  double roundAwayFromZero() {
    return this > 0 ? ceilToDouble() : floorToDouble();
  }

  /// Returns the nearest integer double value by rounding towards zero.
  ///
  /// - For positive numbers, it rounds down to the previous whole number as a double.
  /// - For negative numbers, it rounds up to the previous whole number as a double.
  ///
  /// If this is already an integer-valued double, or it is not a finite value,
  /// the value is returned unmodified.
  ///
  /// Examples:
  /// ```dart
  /// print(1.3.roundTowardsZero()); // 1.0
  /// print((-1.3).roundTowardsZero()); // -1.0
  /// print(19.9.roundTowardsZero()); // 19.0
  /// print((-29.9).roundTowardsZero()); // -29.0
  /// print(0.roundTowardsZero()); // 0.0
  /// print((-0.0).roundTowardsZero()); // -0.0
  /// print(1.roundTowardsZero()); // 1.0
  /// print(-10.roundTowardsZero()); // -10.0
  /// ```
  double roundTowardsZero() {
    return this > 0 ? floorToDouble() : ceilToDouble();
  }
}

class NumberConstants {
  static const int maxFiniteInt = -1 >>> 1;

  /// From https://stackoverflow.com/a/50429767
  static const int minFiniteInt = -0x8000000000000000;
}
