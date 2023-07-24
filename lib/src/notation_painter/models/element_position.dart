import 'package:music_notation/src/models/data_types/step.dart';

/// The position of a musical element in a diatonic scale.
///
/// An [ElementPosition] is defined by a step (A-G) and an octave. This allows
/// for precise definition and comparison of positions in a musical context.
///
/// The class provides various methods and operators for comparing and
/// manipulating the position of musical elements. It also provides a numerical
/// representation based on the traditional notion of steps and octaves in a
/// diatonic scale.
///
/// This class is used in the context of generating and manipulating musical
/// scores and representations, enabling operations that require knowledge of
/// the position of notes or other musical elements.
class ElementPosition {
  final Step step;
  final int octave;

  const ElementPosition({
    required this.step,
    required this.octave,
  });

  /// Numeric representation of step in octave. C being lowest as `0` and B being
  /// highest as `6`.
  int get numericalStep {
    switch (step) {
      case Step.B:
        return 6;
      case Step.A:
        return 5;
      case Step.G:
        return 4;
      case Step.F:
        return 3;
      case Step.E:
        return 2;
      case Step.D:
        return 1;
      case Step.C:
        return 0;
    }
  }

  static const int _notesPerOctave = 7;

  /// Calculates vertical note/music element position from C0. Note at `7` position
  /// would be C1, on `25` position would be G3.
  ///
  /// Position is calculated from 'C0' because it is the lowest note on standard,
  /// 88-key piano. Also, the frequency of C0 is approximately 16.35 Hz, which
  /// is at the very lower end of the human hearing range.
  int get numericPosition => (octave * _notesPerOctave) + numericalStep;

  factory ElementPosition.fromInt(int numericPosition) {
    int octave = numericPosition ~/ _notesPerOctave;
    int remainder = numericPosition.remainder(_notesPerOctave);

    return ElementPosition(
      step: _fromInt(remainder)!,
      octave: octave,
    );
  }

  static Step? _fromInt(int value) {
    switch (value) {
      case 6:
        return Step.B;
      case 5:
        return Step.A;
      case 4:
        return Step.G;
      case 3:
        return Step.F;
      case 2:
        return Step.E;
      case 1:
        return Step.D;
      case 0:
        return Step.C;
      default:
        return null;
    }
  }

  /// Less-than operator. Compares an [ElementPosition] to another [ElementPosition]
  /// and returns true if the vertical position in staff left-hand-side operand
  /// are lower than the position of the right-hand-side operand respectively.
  /// Returns false otherwise.
  ///
  /// This is a partial ordering. It is possible for two values to be neither
  /// less, nor greater than, nor equal to, another.
  bool operator <(ElementPosition other) =>
      numericPosition < other.numericPosition;

  /// Greater-than operator. Compares an [ElementPosition] to another [ElementPosition]
  /// and returns true if the vertical position in staff left-hand-side operand
  /// are higher than the value of the right-hand-side operand respectively.
  /// Returns false otherwise.
  ///
  /// This is a partial ordering. It is possible for two values to be neither
  /// less, nor greater than, nor equal to, another.
  bool operator >(ElementPosition other) =>
      numericPosition > other.numericPosition;

  /// Greater-than-or-equal-to operator. Compares an [ElementPosition] to another
  /// [ElementPosition] and returns true if the vertical position in staff
  /// left-hand-side operand are higher than or equal to the value of the
  /// right-hand-side operand respectively. Returns false otherwise.
  ///
  /// This is a partial ordering. It is possible for two values to be neither
  /// less, nor greater than, nor equal to, another.
  bool operator >=(ElementPosition other) =>
      numericPosition >= other.numericPosition;

  /// Less-than-or-equal-to operator. Compares an [ElementPosition] to another
  /// [ElementPosition] and returns true if the vertical position in staff
  /// left-hand-side operand are lower than or equal to the value of the
  /// right-hand-side operand respectively. Returns false otherwise.
  ///
  /// This is a partial ordering. It is possible for two values to be neither
  /// less, nor greater than, nor equal to, another.
  bool operator <=(ElementPosition other) =>
      numericPosition <= other.numericPosition;

  /// Equality operator. Compares an [ElementPosition] to another [ElementPosition]
  /// and returns true if the step and octave of the left-hand-side operand are
  /// equal to the step and octave values of the right-hand-side operand
  /// respectively. Returns false otherwise.
  @override
  bool operator ==(Object other) {
    return other is ElementPosition &&
        other.step == step &&
        other.octave == octave;
  }

  @override
  int get hashCode => Object.hash(step, octave);

  @override
  String toString() {
    return "$step$octave";
  }

  static const ElementPosition staffMiddle = ElementPosition(
    step: Step.B,
    octave: 4,
  );
}
