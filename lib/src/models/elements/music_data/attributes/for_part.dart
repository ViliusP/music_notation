import 'package:music_notation/src/models/elements/music_data/attributes/attributes.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/transpose.dart';

/// Indicates the transposition for a transposed part created from a concert score.
///
/// It is only used in score files that contain a concert-score element in the defaults.
///
/// This allows concert scores with transposed parts to be represented in a single uncompressed MusicXML file.
///
/// The optional number attribute refers to staff numbers,
/// from top to bottom on the system.
///
/// If absent, the child elements apply to all staves in the created part.
class ForPart extends Transposition {
  @override
  String get name => "for-part";
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  // TODO: check.

  /// The sign element represents the clef symbol.
  ClefSign sign;

  /// Line numbers are counted from the bottom of the staff.
  ///
  /// They are only needed with the G, F, and C signs in order to position a pitch correctly on the staff.
  ///
  /// Standard values are 2 for the [ClefSign.G] (treble clef),
  /// 4 for the [ClefSign.F] (bass clef), and 3 for the [ClefSign.C] (alto clef).
  ///
  /// Line values can be used to specify positions outside the staff,
  /// such as a [ClefSign.C] positioned in the middle of a grand staff.
  int? _line;
  int? get line => _line ?? sign.defaultLineNumber;
  set line(int? value) {
    _line = value;
  }

  /// This is used for transposing clefs. A [ClefSign.G] for tenors would have a value of -1.
  int? octaveChange;

  TransposeContent partTranspose;

  ForPart({
    required this.sign,
    int? line,
    this.octaveChange,
    required this.partTranspose,
  });
}
