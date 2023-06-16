import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/printing.dart';

/// Fingering is typically indicated 1,2,3,4,5.
///
/// Multiple fingerings may be given, typically to substitute fingerings in the middle of a note.
///
/// The substitution and alternate values are "no" if the attribute is not present.
///
/// For guitar and other fretted instruments,
/// the fingering element represents the fretting finger;
/// the pluck element represents the plucking finger.
class Fingering {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  String value;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Indicates that this fingering is a substitution in the middle of a note. It is no if not present.
  bool substitution;

  /// Indicates that this is an alternate fingering. It is no if not present.
  bool alternate;

  PrintStyle printStyle;

  /// Indicates whether something is above or below another element, such as a note or a notation.
  Placement? placement;

  Fingering({
    required this.value,
    this.substitution = false,
    this.alternate = false,
    required this.printStyle,
    required this.placement,
  });
}
