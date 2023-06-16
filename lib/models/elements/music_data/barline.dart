import 'package:music_notation/models/elements/music_data/music_data.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/models/data_types/system_relation.dart';
import 'package:music_notation/models/elements/music_data/direction/coda.dart';
import 'package:music_notation/models/elements/music_data/direction/segno.dart';
import 'package:music_notation/models/elements/music_data/note/notations/notation.dart';
import 'package:music_notation/models/elements/music_data/note/notations/ornaments.dart';
import 'package:music_notation/models/part_list.dart';
import 'package:music_notation/models/printing.dart';
import 'package:music_notation/models/text.dart';

/// If a barline is other than a normal single barline,
/// it should be represented by a barline type that describes it.
///
/// This includes information about repeats and multiple endings,
/// as well as line style. Barline data is on the same level as
/// the other musical data in a score - a child of a measure in a partwise score,
/// or a part in a timewise score. This allows for barlines within measures,
/// as in dotted barlines that subdivide measures in complex meters.
/// The two fermata elements allow for fermatas on both sides of the barline (the lower one inverted).
///
/// Barlines have a location attribute to make it easier to process barlines
/// independently of the other musical data in a score.
/// It is often easier to set up measures separately from entering notes.
/// The location attribute must match where the barline element occurs
/// within the rest of the musical data in the score.
///
/// The segno, coda, and divisions attributes work the same way as in the sound element.
/// They are used for playback when barline elements contain segno or coda child elements.
class Barline implements MusicDataElement {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// The bar-style type represents barline style information.
  /// Choices are regular, dotted, dashed, heavy, light-light, light-heavy,
  /// heavy-light, heavy-heavy, tick (a short stroke through the top line),
  /// short (a partial barline between the 2nd and 4th lines), and none.
  BarStyle? barStyle;

  Color? barColor;

  Editorial editorial;

  WavyLine? wavyLine;

  Segno? segno;

  Coda? coda;

  Fermata? fermata1;

  Fermata? fermata2;

  Ending? ending;

  Repeat? repeat;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Used for playback when there is a [coda] child element.
  ///
  /// Indicates the end point for a forward jump to a coda sign.
  ///
  /// If there are multiple jumps, the value of these parameters can be used to name and distinguish them.
  String? codaPlayback;

  /// Used for playback when there is a [segno] child element.
  ///
  /// Indicates the end point for a backward jump to a segno sign.
  ///
  /// If there are multiple jumps, the value of these parameters can be used to name and distinguish them.
  String? segnoPlayback;

  /// If the segno or coda attributes are used, the divisions attribute
  /// can be used to indicate the number of divisions per quarter note.
  /// Otherwise sound and MIDI generating programs may have to recompute this.
  double? divisions;

  /// Specifies an ID that is unique to the entire document.
  String? id;

  /// Barlines have a location attribute to make it easier to process barlines
  /// independently of the other musical data in a score.
  ///
  /// It is often easier to set up measures separately from entering notes.
  /// The location attribute must match where the [Barline] element
  /// occurs within the rest of the musical data in the score.
  /// If location is [BarlineLocation.left], it should be the first element in the measure,
  /// aside from the [Print], [Bookmark], and [Link] elements.
  ///
  /// If location is [BarlineLocation.right], it should be the last element,
  /// again with the possible exception of the [Print], [Bookmark], and [Link] elements.
  ///
  /// The default value is right.
  BarlineLocation location;

  Barline({
    this.barStyle,
    this.barColor,
    required this.editorial,
    this.wavyLine,
    this.segno,
    this.coda,
    this.fermata1,
    this.fermata2,
    this.ending,
    this.repeat,
    this.location = BarlineLocation.right,
  });

  factory Barline.fromXml(XmlElement xmlElement) {
    return Barline(
      editorial: Editorial.fromXml(xmlElement),
    );
  }
}

/// The right-left-middle types is used to specify barline location.
enum BarlineLocation {
  /// Right barline.
  right,

  /// Left barline;
  left,

  /// Mid-measure barline;
  middle;
}

enum BarStyle {
  regular,
  dotted,
  dashed,
  heavy,
  lightLight,
  lightHeavy,
  heavyLight,
  heavyHeavy,
  tick,
  short,
  none;
}

class Repeat {
  /// The start of the repeat has a forward direction while the end of the repeat has a backward direction.
  RepeatDirection direction;

  bool? afterJump;

  int? times;

  Winged winged;

  Repeat({
    required this.direction,
    this.afterJump,
    this.times,
    this.winged = Winged.none,
  });

  factory Repeat.fromXml() {
    return Repeat(
      direction: RepeatDirection.backward,
    );
  }
}

/// The backward-forward type is used to specify repeat directions.
///
/// The start of the repeat has a forward direction while the end of the repeat has a backward direction.
enum RepeatDirection {
  backward,
  forward;
}

/// The winged attribute indicates whether the repeat has winged extensions
/// that appear above and below the barline.
/// The straight and curved values represent single wings,
/// while the double-straight and double-curved values represent double wings.
///
/// The none value indicates no wings and is the default.
enum Winged {
  none,
  straight,
  curved,
  doubleStraight,
  doubleCurved;
}

/// The ending type represents multiple (e.g. first and second) endings.
///
/// Typically, the start type is associated with the left barline of the first measure in an ending.
///
/// The stop and discontinue types are associated with the right barline of the last measure in an ending.
///
/// Stop is used when the ending mark concludes with a downward jog,
/// as is typical for first endings.
///
/// Discontinue is used when there is no downward jog, as is typical
/// for second endings that do not conclude a piece.
///
/// The length of the jog can be specified using the end-length attribute.
///
/// The text-x and text-y attributes are offsets that specify where
/// the baseline of the start of the ending text appears, relative to the start of the ending line.
///
/// The number attribute indicates which times the ending is played,
/// similar to the time-only attribute used by other elements.
///
/// While this often represents the numeric values for what is under the ending line,
/// it can also indicate whether an ending is played during a larger dal segno or da capo repeat.
///
/// Single endings such as "1" or comma-separated multiple endings such as "1,2" may be used.
///
/// The ending element text is used when the text displayed in the ending is different
///
/// than what appears in the number attribute.
///
/// The print-object attribute is used to indicate when an ending is present but not printed,
/// as is often the case for many parts in a full score.
class Ending {
  String value;

  /// The ending-number type is used to specify either a comma-separated
  /// list of positive integers without leading zeros,
  /// or a string of zero or more spaces.
  ///
  /// It is used for the number attribute of the ending element.
  /// The zero or more spaces version is used when software knows that an ending is present,
  /// but cannot determine the type of the ending.
  // <xs:pattern value="([ ]*)|([1-9][0-9]*(, ?[1-9][0-9]*)*)"/>
  String number;

  EndingType type;

  /// Specifies whether or not to print an object. It is yes if not specified.
  bool printObject;

  PrintStyle printStyle;

  /// Distinguishes elements that are associated with a system
  /// rather than the particular part where the element appears.
  SystemRelation? system;

  /// Specifies the length of the ending jog.
  double? endLength;

  /// An offset that specifies where the start of the ending text appears,
  /// relative to the start of the ending line.
  double? textX;

  /// An offset that specifies where the baseline of ending text appears,
  /// relative to the start of the ending line.
  double? textY;

  Ending({
    required this.value,
    required this.number,
    required this.type,
    this.printObject = true,
    required this.printStyle,
    this.system,
    this.endLength,
    this.textX,
    this.textY,
  });

  factory Ending.fromXml(XmlElement xmlElement) {
    return Ending(
      value: "0",
      number: "1",
      type: EndingType.stop,
      printStyle: PrintStyle.fromXml(xmlElement),
    );
  }
}

/// This enum used to specify [Ending] types.
enum EndingType {
  /// Used with the left barline of the first measure in an ending.
  start,

  /// Used with the right barline of the last measure in an ending.
  ///
  /// Indicates the ending mark concludes with a downward jog, as is typical for first endings
  stop,

  /// Used with the right barline of the last measure in an ending.
  /// Indicates there is no downward jog,
  /// as is typical for second endings that do not conclude a piece.
  discontinue;
}
