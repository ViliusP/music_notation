import 'package:music_notation/src/models/data_types/accidental_value.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/printing.dart';

/// The key type represents a key signature.
/// Both traditional and non-traditional key signatures are supported.
/// The optional number attribute refers to staff numbers.
/// If absent, the key signature applies to all staves in the part.
/// Key signatures appear at the start of each system unless the print-object attribute has been set to "no".
abstract class Key {
  /// The optional list of key-octave elements is used to
  /// specify in which octave each element of the key signature appears.
  List<KeyOctave> keyOctaves;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Allows a key signature to apply to only the specified staff in the part.
  /// If absent, the key signature applies to all staves in the part.
  int? number;

  PrintStyle printStyle;

  bool printObject;

  String? id;

  Key({
    required this.keyOctaves,
    this.number,
    required this.printStyle,
    required this.printObject,
    this.id,
  });
}

class TraditionalKey extends Key {
  Cancel? cancel;

  int fifths;

  /// The mode type is used to specify major/minor and other mode distinctions.
  ///
  /// Valid mode values include major, minor, dorian, phrygian, lydian, mixolydian, aeolian, ionian, locrian, and none.
  String? mode;

  TraditionalKey({
    this.cancel,
    required this.fifths,
    this.mode,
    required super.keyOctaves,
    required super.printStyle,
    required super.printObject,
  });
}

/// A cancel element indicates that the old key signature should be cancelled before the new one appears.
///
/// This will always happen when changing to C major or A minor and need not be specified then.
///
/// The cancel value matches the fifths value of the cancelled key signature
/// (e.g., a cancel of -2 will provide an explicit cancellation for changing from B flat major to F major).
///
/// The optional location attribute indicates where the cancellation appears relative to the new key signature.
class Cancel {
  int fifths;

  /// Indicates where the cancellation appears relative to the new key signature. It is left if not specified.
  CancelLocation? location;

  Cancel({
    required this.fifths,
    this.location = CancelLocation.right,
  });
}

/// The cancel-location type is used to indicate where a key signature cancellation appears relative to a new key signature:
/// to the left, to the right, or before the barline and to the left.
///
/// It is left by default. For mid-measure key elements,
/// a cancel-location of before-barline should be treated like a cancel-location of left.
enum CancelLocation {
  left,
  right,
  beforeBarline;
}

class NonTraditionalKey extends Key {
  List<NonTraditionalKeyContent> content;

  NonTraditionalKey({
    required this.content,
    required super.keyOctaves,
    required super.printStyle,
    required super.printObject,
  });
}

class NonTraditionalKeyContent {
  Step keyStep;

  double keyAlter;

  AccidentalValue? keyAccidental;

  NonTraditionalKeyContent({
    required this.keyStep,
    required this.keyAlter,
    this.keyAccidental,
  });
}

/// The key-octave type specifies in which octave an element of a key signature appears.
///
/// The content specifies the octave value using the same values as the display-octave element.
///
/// The number attribute is a positive integer that refers to the key signature element in left-to-right order.
///
/// If the cancel attribute is set to yes, then this number refers to the canceling key signature specified
///
/// by the cancel element in the parent key element. The cancel attribute cannot be set to yes
/// if there is no corresponding cancel element within the parent key element.
///
/// It is no by default.
class KeyOctave {
  /// Octaves are represented by the numbers 0 to 9,
  /// where 4 indicates the octave started by middle C.
  int value;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// A positive integer that refers to the key signature element in left-to-right order.
  int number;

  /// If set to yes, then the number refers to the canceling key signature specified
  /// by the cancel element in the parent [key] element.
  ///
  /// It cannot be set to yes if there is no corresponding cancel element within the parent [key] element.
  /// It is no if absent.
  bool cancel;

  KeyOctave({
    required this.value,
    required this.number,
    this.cancel = false,
  });
}
