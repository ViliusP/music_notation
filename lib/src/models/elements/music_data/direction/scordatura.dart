import 'package:music_notation/src/models/elements/music_data/note/note.dart';

/// Scordatura string tunings are represented by a series of accord elements, similar to the staff-tuning elements.
///
/// Strings are numbered from high to low.
class Scordatura {
  List<Accord> accords;

  String id;

  Scordatura({
    required this.accords,
    required this.id,
  });
}

/// The accord type represents the tuning of a single string in the scordatura element.
///
/// It uses the same group of elements as the staff-tuning element.
///
/// Strings are numbered from high to low.
class Accord {
  /// The string-number type indicates a string number.
  ///
  /// Strings are numbered from high to low,
  /// with 1 being the highest pitched full-length string.
  String stringNumber;

  Tuning tuning;

  Accord({
    required this.stringNumber,
    required this.tuning,
  });
}

/// The tuning group contains the sequence of elements common to the staff-tuning and accord elements.
class Tuning extends Pitch {
  // /// The tuning-step element is represented like the step element,
  // /// with a different name to reflect its different function in string tuning.
  // Step step;

  // /// The tuning-alter element is represented like the alter element,
  // /// with a different name to reflect its different function in string tuning.
  // double alter;

  // /// The tuning-octave element is represented like the octave element,
  // /// with a different name to reflect its different function in string tuning.
  // ///
  // /// Octaves are represented by the numbers 0 to 9, where 4 indicates the octave started by middle C.
  // int octave;

  Tuning({
    required super.step,
    super.alter,
    required super.octave,
  });
}
