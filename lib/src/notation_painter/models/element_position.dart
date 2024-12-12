import 'package:music_notation/src/models/data_types/step.dart';
import 'package:music_notation/src/notation_painter/properties/constants.dart';

/// The position of a musical element in a diatonic scale.
///
/// The position is defined by a [step] (A-G) and an [octave]. It supports
/// comparison and manipulation operations, making it suitable for use in
/// musical scores and representations. The position is numerically represented
/// using a diatonic scale, where `C0` is the lowest note.
///
/// When compared, a visually lower position (e.g., C4) is considered less
/// than a visually higher position (e.g., B5), enabling intuitive sorting.
class ElementPosition implements Comparable<ElementPosition> {
  final Step step;
  final int octave;

  const ElementPosition({
    required this.step,
    required this.octave,
  });

  factory ElementPosition.fromInt(int numericPosition) {
    int octave = numericPosition ~/ NotationConstants.notesPerOctave;
    int remainder = numericPosition.remainder(NotationConstants.notesPerOctave);

    return ElementPosition(
      step: _stepFromInt(remainder),
      octave: octave,
    );
  }

  /// Numeric representation of step in octave. C being lowest as `0` and B being
  /// highest as `6`.
  int get _numericalStep {
    return switch (step) {
      Step.B => 6,
      Step.A => 5,
      Step.G => 4,
      Step.F => 3,
      Step.E => 2,
      Step.D => 1,
      Step.C => 0,
    };
  }

  /// Returns the numeric position of the element in the diatonic scale.
  ///
  /// The position is calculated relative to `C0`, the lowest note on a standard
  /// 88-key piano (frequency ~16.35 Hz). For example:
  /// - Position `7` corresponds to `C1`.
  /// - Position `25` corresponds to `G3`.
  int get numeric {
    return (octave * NotationConstants.notesPerOctave) + _numericalStep;
  }

  static Step _stepFromInt(int value) {
    return switch (value) {
      6 => Step.B,
      5 => Step.A,
      4 => Step.G,
      3 => Step.F,
      2 => Step.E,
      1 => Step.D,
      0 => Step.C,
      _ => throw ArgumentError(
          'Converting number to step, you must provide the value from 0 to 6',
        )
    };
  }

  /// Shifts the element's position by the specified [interval].
  ///
  /// - A positive [interval] moves the position higher in the scale.
  /// - A negative [interval] moves the position lower.
  ///
  /// The method computes the new position numerically and wraps it to the
  /// appropriate step and octave.
  ///
  /// Example:
  /// ```dart
  /// final position = ElementPosition(step: Step.C, octave: 4);
  /// final transposed = position.transpose(3); // Results in F4
  /// ```
  ElementPosition transpose(int interval) {
    return ElementPosition.fromInt(numeric + interval);
  }

  /// Less-than operator. Compares this [ElementPosition] to another
  /// [ElementPosition] and returns `true` if this position is numerically
  /// lower than the other. Returns `false` otherwise.
  ///
  /// This comparison aligns with the visual positioning of notes on a staff:
  /// - Lower notes (e.g., C4) are considered less than higher notes (e.g., B5).
  ///
  /// Example:
  /// ```dart
  /// final pos1 = ElementPosition(step: Step.C, octave: 4);
  /// final pos2 = ElementPosition(step: Step.D, octave: 4);
  /// print(pos1 < pos2); // true
  /// ```
  bool operator <(ElementPosition other) => numeric < other.numeric;

  /// Less-than-or-equal-to operator. Compares this [ElementPosition] to another
  /// [ElementPosition] and returns `true` if this position is numerically less
  /// than or equal to the other. Returns `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// final pos1 = ElementPosition(step: Step.C, octave: 4);
  /// final pos2 = ElementPosition(step: Step.C, octave: 4);
  /// print(pos1 <= pos2); // true
  /// ```
  bool operator <=(ElementPosition other) => numeric <= other.numeric;

  /// Greater-than operator. Compares an [ElementPosition] to another [ElementPosition]
  /// and returns `true` if the vertical position of the left-hand-side operand
  /// is higher than that of the right-hand-side operand. Returns `false` otherwise.
  ///
  /// This operator allows for natural ordering of musical elements based on
  /// their position on a staff (higher notes are considered greater).
  ///
  /// Example:
  /// ```dart
  /// final position1 = ElementPosition(step: Step.C, octave: 4);
  /// final position2 = ElementPosition(step: Step.D, octave: 4);
  /// print(position1 > position2); // false
  /// ```
  bool operator >(ElementPosition other) => numeric > other.numeric;

  /// Greater-than-or-equal-to operator. Compares two [ElementPosition] instances
  /// and returns `true` if the vertical position of the left-hand-side operand
  /// is higher than or equal to the right-hand-side operand. Returns `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// final position1 = ElementPosition(step: Step.C, octave: 4);
  /// final position2 = ElementPosition(step: Step.C, octave: 4);
  /// print(position1 >= position2); // true
  /// ```
  bool operator >=(ElementPosition other) => numeric >= other.numeric;

  /// Plus operator. Adds an integer [value] to the current position's numeric
  /// representation and returns a new [ElementPosition] instance.
  ///
  /// This operator is equivalent to transposing the current position by the
  /// given [value]. Positive values move the position higher, while negative
  /// values move it lower. It automatically handles octave changes as necessary.
  ///
  /// Example:
  /// ```dart
  /// final position = ElementPosition(step: Step.C, octave: 4);
  /// final transposed = position + 3; // Moves 3 steps up: F4
  /// print(transposed); // ElementPosition F4
  /// ```
  ElementPosition operator +(int value) => ElementPosition.fromInt(
        numeric + value,
      );

  /// Minus operator. Subtracts an integer [value] from the current position's
  /// numeric representation and returns a new [ElementPosition] instance.
  ///
  /// This operator is equivalent to transposing the current position downward
  /// by the given [value]. Positive values move the position lower, while negative
  /// values move it higher. It automatically handles octave changes as necessary.
  ///
  /// Example:
  /// ```dart
  /// final position = ElementPosition(step: Step.C, octave: 4);
  /// final transposed = position - 3; // Moves 3 steps down: A3
  /// print(transposed); // ElementPosition A3
  /// ```
  ElementPosition operator -(int value) => ElementPosition.fromInt(
        numeric - value,
      );

  /// Equality operator. Compares two [ElementPosition] instances and returns `true`
  /// if their [step] and [octave] values are identical. Returns `false` otherwise.
  ///
  /// This operator ensures that two positions are considered equal only when both
  /// the note (step) and the octave match exactly.
  ///
  /// Example:
  /// ```dart
  /// final position1 = ElementPosition(step: Step.C, octave: 4);
  /// final position2 = ElementPosition(step: Step.C, octave: 4);
  /// final position3 = ElementPosition(step: Step.D, octave: 4);
  /// print(position1 == position2); // true
  /// print(position1 == position3); // false
  /// ```
  @override
  bool operator ==(Object other) {
    return other is ElementPosition &&
        other.step == step &&
        other.octave == octave;
  }

  @override
  int get hashCode => Object.hash(step, octave);

  @override
  String toString() => 'ElementPosition  $step$octave';

  @override
  int compareTo(ElementPosition other) {
    if (this < other) {
      return -1;
    } else if (this > other) {
      return 1;
    } else {
      return 0;
    }
  }

  // Predefined [ElementPosition] constants for standard staff positions:

  /// Represents the middle of the staff (B4).
  static const ElementPosition staffMiddle = ElementPosition(
    step: Step.B,
    octave: 4,
  );

  ///  Represents the bottom line of the staff (E4).
  static const ElementPosition staffBottom = ElementPosition(
    step: Step.E,
    octave: 4,
  );

  ///  Represents the top line of the staff (F5).
  static const ElementPosition staffTop = ElementPosition(
    step: Step.F,
    octave: 5,
  );

  /// First ledger line below the staff (C4).
  static const ElementPosition firstLedgerBelow = ElementPosition(
    step: Step.C,
    octave: 4,
  );

  /// First ledger line above the staff (A5).
  static const ElementPosition firstLedgerAbove = ElementPosition(
    step: Step.A,
    octave: 5,
  );

  /// Second ledger line below the staff (A3).
  static const ElementPosition secondLedgerBelow = ElementPosition(
    step: Step.A,
    octave: 3,
  );

  ///  Second ledger line above the staff (C6).
  static const ElementPosition secondLedgerAbove = ElementPosition(
    step: Step.C,
    octave: 6,
  );

  /// Calculates the absolute numerical distance between this position and another
  /// [ElementPosition]. The result is always non-negative.
  ///
  /// Example:
  /// ```dart
  /// final position1 = ElementPosition(step: Step.C, octave: 4);
  /// final position2 = ElementPosition(step: Step.F, octave: 5);
  /// print(position1.distance(position2)); // 10
  /// ```
  int distance(ElementPosition other) {
    return (numeric - other.numeric).abs();
  }

  /// Calculates the numerical difference between this position and the middle
  /// of the staff (B4). Positive values indicate the note is above the middle,
  /// and negative values indicate it is below.
  ///
  /// Example:
  /// ```dart
  /// final position = ElementPosition(step: Step.D, octave: 5);
  /// print(position.distanceFromMiddle); // 5
  /// ```
  int get distanceFromMiddle {
    return numeric - ElementPosition.staffMiddle.numeric;
  }

  /// Calculates the numerical difference from the bottom of the staff (E4).
  ///
  /// - Positive values indicate a position above the bottom line.
  /// - Negative values indicate a position below the bottom line.
  ///
  /// Example:
  /// ```dart
  /// final position = ElementPosition(step: Step.F, octave: 5);
  /// print(position.distanceFromBottom); // 12
  /// ```
  int get distanceFromBottom {
    return numeric - ElementPosition.staffBottom.numeric;
  }

  /// Calculates the numerical difference from the top of the staff (F5).
  ///
  /// - Positive values indicate a position above the top line.
  /// - Negative values indicate a position below the top line.
  ///
  /// Example:
  /// ```dart
  /// final position = ElementPosition(step: Step.E, octave: 4);
  /// print(position.distanceFromTop); // -12
  /// ```
  int get distanceFromTop {
    return numeric - ElementPosition.staffTop.numeric;
  }
}
