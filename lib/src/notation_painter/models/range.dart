typedef Subtractor<T, D> = D Function(T max, T min);

/// A generic class representing a range with a minimum and maximum value.
///
/// This class is restricted to types that implement [Subtractable].
class Range<T extends Comparable<T>, D> {
  /// The lower bound of the range.
  final T min;

  /// The upper bound of the range.
  final T max;

  final Subtractor<T, D> _subtract;

  /// Creates a [Range] from two values [a] and [b].
  ///
  /// Automatically determines the minimum and maximum values, ensuring
  /// that [min] is less than or equal to [max].
  Range(T a, T b, Subtractor<T, D> subtractor)
      : min = a.compareTo(b) <= 0 ? a : b,
        max = a.compareTo(b) >= 0 ? a : b,
        _subtract = subtractor;

  /// Checks if a given value [value] lies within the range (inclusive).
  bool contains(T value) {
    return value.compareTo(min) >= 0 && value.compareTo(max) <= 0;
  }

  /// The distance between the maximum and minimum values.
  D get distance => _subtract(max, min);

  @override
  String toString() => 'Range($min, $max)';
}
