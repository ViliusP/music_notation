extension NumberExtensions on num {
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
  num nearestMultiple({required num of}) {
    if (of == 0) {
      throw ArgumentError("Base must be non-zero");
    }

    // Determine rounding direction based on the sign of base
    return of > 0
        ? (this / of).ceil() * of // Round up for positive base
        : (this / of.abs()).floor() * of.abs(); // Round down for negative base
  }
}
