import 'package:music_notation/src/models/data_types/symbol_size.dart';
import 'package:music_notation/src/models/printing.dart';

/// Clefs are represented by a combination of sign, line, and clef-octave-change elements.
///
/// The optional number attribute refers to staff numbers within the part.
/// A value of 1 is assumed if not present.
///
/// Sometimes clefs are added to the staff in non-standard line positions,
/// either to indicate cue passages,
/// or when there are multiple clefs present simultaneously on one staff.
/// In this situation, the additional attribute is set to "yes" and the line value is ignored.
///
/// The size attribute is used for clefs where the additional attribute is "yes".
/// It is typically used to indicate cue clefs.
///
/// Sometimes clefs at the start of a measure need to appear after the barline rather than before,
/// as for cues or for use after a repeated section.
/// The after-barline attribute is set to "yes" in this situation.
/// The attribute is ignored for mid-measure clefs.
///
/// Clefs appear at the start of each system
/// unless the print-object attribute has been set to "no"
/// or the additional attribute has been set to "yes".
class Clef {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  CleffContent content;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Specifies the staff number from top to bottom within the part.
  ///
  /// The value is 1 if not present.
  int number;

  /// The size attribute is used for clefs where the additional attribute is "yes".
  ///
  /// It is typically used to indicate cue clefs.
  SymbolSize? size;

  /// Sometimes clefs are added to the staff in non-standard line positions,
  /// either to indicate cue passages, or when there are multiple clefs present simultaneously on one staff.
  ///
  /// In this situation, the additional attribute is set to "yes" and the line value is ignored.
  bool afteBarline;

  /// Sometimes clefs are added to the staff in non-standard line positions,
  /// either to indicate cue passages, or when there are multiple clefs present simultaneously on one staff.
  ///
  /// In this situation, the additional attribute is set to "yes" and the line value is ignored.
  bool additional;

  PrintStyle printStyle;

  /// Specifies whether or not to print an object. It is yes if not specified.
  bool printObject;

  /// Specifies an ID that is unique to the entire document.
  String id;

  Clef({
    required this.content,
    required this.number,
    this.size,
    required this.afteBarline,
    required this.additional,
    required this.printStyle,
    required this.printObject,
    required this.id,
  });
}

/// The clef-sign type represents the different clef symbols.
///
/// The jianpu sign indicates that the music that follows should be in jianpu numbered notation,
/// just as the TAB sign indicates that the music that follows should be in tablature notation.
///
/// Unlike TAB, a jianpu sign does not correspond to a visual clef notation.
//
/// The none sign is deprecated as of MusicXML 4.0.
/// Use the clef element's print-object attribute instead.
/// When the none sign is used, notes should be displayed as if in treble clef.
enum ClefSign {
  G,
  F,
  C,
  percussion,
  tab,
  jianpu,
  @Deprecated(
    "The none sign is deprecated as of MusicXML 4.0. Use the clef element's print-object attribute instead.",
  )
  none;
}

class CleffContent {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// The sign element represents the clef symbol.
  ClefSign sign;

  /// Line numbers are counted from the bottom of the staff.
  ///
  /// They are only needed with the G, F, and C signs in order to position a pitch correctly on the staff.
  ///
  /// Standard values are 2 for the G sign (treble clef),
  /// 4 for the F sign (bass clef), and 3 for the C sign (alto clef).
  ///
  /// Line values can be used to specify positions outside the staff,
  /// such as a C clef positioned in the middle of a grand staff.
  int? line;

  // The clef-octave-change element is used for transposing clefs.
  // A treble clef for tenors would have a value of -1.
  int? clefOctaveChange;

  CleffContent({
    required this.sign,
    this.line,
    this.clefOctaveChange,
  });
}
