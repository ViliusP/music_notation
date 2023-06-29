import 'package:xml/xml.dart';

/// Attribute group collects the different controls over printing an object (e.g. a note or rest) and its parts,
/// including augmentation dots and lyrics.
///
/// This is especially useful for notes that overlap in different voices,
/// or for chord sheets that contain lyrics and chords but no melody.
///
/// By default, all these attributes are set to yes. If print-object is set to no,
/// the print-dot and print-lyric attributes are interpreted to also be set to no if they are not present.
class Printout {
  /// The print-object attribute specifies whether or not to print an object (e.g. a note or a rest).
  ///
  /// It is yes by default.
  bool? printObject;

  /// Controls the printing of an augmentation dot separately from the rest of the note or rest.
  /// This is especially useful for notes that overlap in different voices,
  /// or for chord sheets that contain lyrics and chords but no melody.
  ///  If print-object is set to no, this attribute is also interpreted as being set to no if not present.
  bool? printDot;

  /// The print-spacing attribute controls whether or not spacing is left for an invisible note or object.
  ///
  /// It is used only if no note, dot, or lyric is being printed.
  ///
  /// The value is yes (leave spacing) by default.
  bool? printSpacing;

  bool? printLyric;

  Printout();

  factory Printout.fromXml(XmlElement xmlElement) {
    return Printout();
  }
}
