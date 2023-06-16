import 'package:music_notation/models/elements/music_data/note/lyric.dart';
import 'package:music_notation/models/elements/music_data/note/note.dart';
import 'package:music_notation/models/elements/style_text.dart';
import 'package:music_notation/models/part_list.dart';
import 'package:music_notation/models/printing.dart';

/// The figured-bass element represents figured bass notation.
///
/// Figured bass elements take their position from the first regular note (not a grace note or chord note)
/// that follows in score order.
///
/// The optional duration element is used to indicate changes of figures under a note.
///
/// Figures are ordered from top to bottom. The value of parentheses is "no" if not present.
class FiguredBass {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //
  List<Figure> figures;

  /// Duration is a positive number specified in division units.
  ///
  /// This is the intended duration vs. notated duration
  /// (for instance, differences in dotted notes in Baroque-era music).
  ///
  /// Differences in duration specific to an interpretation or performance
  /// should be represented using the note element's attack and release attributes.
  ///
  /// The duration element moves the musical position when used in backup elements,
  /// forward elements, and note elements that do not contain a chord child element.
  double? duration;

  Editorial editorial;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  PrintStyleAlign printStyleAlign;

  /// Indicates whether something is above or below another element, such as a note or a notation.
  Placement placement;

  Printout printout;

  bool parentheses;

  /// Specifies an ID that is unique to the entire document.
  String? id;

  FiguredBass({
    required this.figures,
    this.duration,
    required this.editorial,
    required this.printStyleAlign,
    required this.placement,
    required this.printout,
    required this.parentheses,
    this.id,
  });
}

/// The figure type represents a single figure within a figured-bass element.
class Figure {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// Values for the prefix element include plus and the accidental values sharp,
  /// flat, natural, double-sharp, flat-flat, and sharp-sharp.
  ///
  /// The prefix element may contain additional values for symbols specific to particular figured bass styles.
  StyleText? prefix;

  /// A figure-number is a number. Overstrikes of the figure number are represented in the suffix element.
  StyleText? number;

  /// Values for the suffix element include plus and the accidental values sharp,
  /// flat, natural, double-sharp, flat-flat, and sharp-sharp.
  ///
  /// Suffixes include both symbols that come after the figure number
  /// and those that overstrike the figure number.
  ///
  /// The suffix values slash, back-slash, and vertical
  /// are used for slashed numbers indicating chromatic alteration.
  ///
  /// The orientation and display of the slash usually depends on the figure number.
  ///
  /// The suffix element may contain additional values for symbols specific to particular figured bass styles.
  StyleText? suffix;

  Extend? extend;

  Editorial editorial;

  Figure({
    this.prefix,
    this.number,
    this.suffix,
    this.extend,
    required this.editorial,
  });
}
