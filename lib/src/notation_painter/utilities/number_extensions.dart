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

  /// Rounds the number up to the nearest double, moving away from zero.
  ///
  /// - Positive numbers round up to the next whole number as a double.
  /// - Negative numbers round down to the next whole number as a double.
  double directionalCeilToDouble() {
    // For positive values, use `ceilToDouble()`; for negative values, use `floorToDouble()`.
    return this > 0 ? ceilToDouble() : floorToDouble();
  }
}

class NumberConstants {
  static const int maxFiniteInt = -1 >>> 1;
}
