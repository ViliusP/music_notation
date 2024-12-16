import 'package:collection/collection.dart';
import 'package:music_notation/src/notation_painter/models/element_position.dart';

typedef Subtractor<T, D> = D Function(T max, T min);

/// A generic class representing a range with a minimum and maximum value.
///
/// This class is restricted to types that implement [Subtractable].
base class Range<T, D> {
  final T _a;
  final T _b;

  /// The lower bound of the range.
  T get min => _comparator(_a, _b) <= 0 ? _a : _b;

  /// The upper bound of the range.
  T get max => _comparator(_a, _b) >= 0 ? _a : _b;

  final Subtractor<T, D> _subtract;

  final Comparator<T> _comparator;

  /// Creates a [Range] from two values [a] and [b].
  ///
  /// Automatically determines the minimum and maximum values, ensuring
  /// that [min] is less than or equal to [max].
  const Range._({
    required T a,
    required T b,
    required Subtractor<T, D> subtractor,
    required Comparator<T> comparator,
  })  : _a = a,
        _b = b,
        _subtract = subtractor,
        _comparator = comparator;

  /// Checks if a given value [value] lies within the range (inclusive).
  bool contains(T value) {
    return _comparator(value, min) >= 0 && _comparator(value, max) <= 0;
  }

  /// The distance between the maximum and minimum values.
  D get distance => _subtract(max, min);

  // Returns new range where lower or upper bound is changed.
  // If given value is between lower and upper bounds, same range will be returned.
  Range include(T value) {
    if (_comparator(_a, value) < -1) {
      return _copyWith(a: value);
    }
    if (_comparator(_b, value) < -1) {
      return _copyWith(b: value);
    }
    return this;
  }

  // Returns new range where lower or upper bound is changed.
  // If given value is between lower and upper bounds, same range will be returned.
  Range includeAll(List<T> values) {
    if (values.isEmpty) return this;
    if (values.length == 1) return include(values.first);
    var sortedValues = values.sorted(_comparator);
    return include(sortedValues.first).include(sortedValues.last);
  }

  Range _copyWith({
    T? a,
    T? b,
    Subtractor<T, D>? subtractor,
    Comparator<T>? comparator,
  }) {
    return Range<T, D>._(
      a: a ?? this._a,
      b: b ?? this._b,
      subtractor: subtractor ?? this._subtract,
      comparator: comparator ?? this._comparator,
    );
  }

  @override
  String toString() => '$runtimeType(min: $min, max: $max)';
}

final class ComparablesRange<T extends Comparable<T>, D> extends Range<T, D> {
  const ComparablesRange(T a, T b, Subtractor<T, D> subtractor)
      : super._(
          a: a,
          b: b,
          subtractor: subtractor,
          comparator: _defaultCompare,
        );

  static int _defaultCompare<T extends Comparable<T>>(T a, T b) {
    return a.compareTo(b);
  }
}

final class NumericalRange<T extends num> extends Range<T, T> {
  const NumericalRange(T a, T b)
      : super._(
          a: a,
          b: b,
          subtractor: _numericalSubtract,
          comparator: _numericalCompare,
        );

  static T _numericalSubtract<T extends num>(T max, T min) {
    return (max - min) as T;
  }

  static int _numericalCompare<T extends num>(T a, T b) {
    return a.compareTo(b);
  }
}

final class PositionalRange extends ComparablesRange<ElementPosition, int> {
  const PositionalRange(ElementPosition a, ElementPosition b)
      : super(a, b, _positionalSubtract);

  static int _positionalSubtract(
    ElementPosition max,
    ElementPosition min,
  ) {
    return max.numeric - min.numeric;
  }
}
