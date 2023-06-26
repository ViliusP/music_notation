// 	<xs:complexType name="harmony">
// 		<xs:annotation>
// 			<xs:documentation>The harmony type represents harmony analysis, including chord symbols in popular music as well as functional harmony analysis in classical music.

// If there are alternate harmonies possible, this can be specified using multiple harmony elements differentiated by type. Explicit harmonies have all note present in the music; implied have some notes missing but implied; alternate represents alternate analyses.

// The print-object attribute controls whether or not anything is printed due to the harmony element. The print-frame attribute controls printing of a frame or fretboard diagram. The print-style attribute group sets the default for the harmony, but individual elements can override this with their own print-style values. The arrangement attribute specifies how multiple harmony-chord groups are arranged relative to each other. Harmony-chords with vertical arrangement are separated by horizontal lines. Harmony-chords with diagonal or horizontal arrangement are separated by diagonal lines or slashes.</xs:documentation>
// 		</xs:annotation>
// 		<xs:sequence>
// 			<xs:group ref="harmony-chord" maxOccurs="unbounded"/>
// 			<xs:element name="frame" type="frame" minOccurs="0"/>
// 			<xs:element name="offset" type="offset" minOccurs="0"/>
// 			<xs:group ref="editorial"/>
// 			<xs:group ref="staff" minOccurs="0"/>
// 		</xs:sequence>
// 		<xs:attribute name="type" type="harmony-type"/>
// 		<xs:attributeGroup ref="print-object"/>
// 		<xs:attribute name="print-frame" type="yes-no"/>
// 		<xs:attribute name="arrangement" type="harmony-arrangement"/>
// 		<xs:attributeGroup ref="print-style"/>
// 		<xs:attributeGroup ref="placement"/>
// 		<xs:attributeGroup ref="system-relation"/>
// 		<xs:attributeGroup ref="optional-unique-id"/>
// 	</xs:complexType>

import 'package:music_notation/src/models/data_types/left_right.dart';
import 'package:music_notation/src/models/data_types/system_relation.dart';
import 'package:music_notation/src/models/elements/editorial.dart';
import 'package:music_notation/src/models/elements/music_data/harmony/chord.dart';
import 'package:music_notation/src/models/elements/music_data/harmony/frame.dart';
import 'package:music_notation/src/models/elements/music_data/music_data.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/offset.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:xml/xml.dart';

/// The harmony type represents harmony analysis,including chord symbols
/// in popular music as well as functional harmony analysis in classical music.
///
/// If there are alternate harmonies possible,
/// this can be specified using multiple harmony elements differentiated by type.
///
/// Explicit harmonies have all note present in the music;
/// implied have some notes missing but implied; alternate represents alternate analyses.
///
/// The print-object attribute controls whether or not anything is printed due to
/// the harmony element. The print-frame attribute controls printing of a frame or
/// fretboard diagram.
///
/// The print-style attribute group sets the default for the harmony,
/// but individual elements can override this with their own print-style values.
/// The arrangement attribute specifies
/// how multiple harmony-chord groups are arranged relative to each other.
///
/// Harmony-chords with vertical arrangement are separated by horizontal lines.
///
/// Harmony-chords with diagonal or horizontal arrangement are separated
/// by diagonal lines or slashes.
class Harmony implements MusicDataElement {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  List<HarmonyChord> chords;

  Frame? frame;

  Offset? offset;

  Editorial editorial;

  int? staff;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// If there are alternate harmonies possible,
  /// this can be specified using multiple [Harmony] elements differentiated by type.
  ///
  /// Explicit harmonies have all note present in the music;
  /// implied have some notes missing but implied; alternate represents alternate analyses.
  HarmonyType? type;

  /// Specifies whether or not to print an object. It is yes if not specified.
  bool printObject;

  /// Specifies the printing of a frame or fretboard diagram.
  bool printFrame;

  /// Specifies how multiple harmony-chords are arranged relative to each other.
  ///
  /// Harmony-chords with vertical arrangement are separated by horizontal lines.
  ///
  /// Harmony-chords with diagonal or horizontal arrangement are separated
  /// by diagonal lines or slashes.
  HarmonyArrangement? arrangement;

  /// For definition, look at [PrintStyle].
  PrintStyle printStyle;

  /// Indicates whether something is above or below another element, such as a note or a notation.
  Placement? placement;

  /// Distinguishes elements that are associated with a system
  /// rather than the particular part where the element appears.
  SystemRelation? system;

  /// Specifies an ID that is unique to the entire document.
  String? id;

  Harmony({
    required this.chords,
    this.frame,
    this.offset,
    this.type,
    required this.editorial,
    this.staff,
    this.printObject = true,
    this.printFrame = false,
    required this.printStyle,
    this.arrangement,
    required this.placement,
    required this.system,
    this.id,
  });

  static Harmony fromXml(XmlElement xmlElement) {
    List<HarmonyChord> chords = [];

    if (chords.isEmpty) {
      throw XmlElementContentException(
        message: "One or more times",
        xmlElement: xmlElement,
      );
    }

    bool? printObject = YesNo.toBool(
      xmlElement.getAttribute("print-object") ?? "",
    );

    bool? printFrame = YesNo.toBool(
      xmlElement.getAttribute("print-frame") ?? "",
    );

    return Harmony(
      chords: chords,
      editorial: Editorial.fromXml(xmlElement),
      staff: int.tryParse(xmlElement.getElement("staff")?.value ?? ""),
      printObject: printObject ?? true,
      printFrame: printFrame ?? false,
      printStyle: PrintStyle.fromXml(xmlElement),
      placement: Placement.fromString(
        xmlElement.getAttribute("placement") ?? "",
      ),
      system: SystemRelation.fromString(
        xmlElement.getAttribute("system-relation") ?? "",
      ),
      id: xmlElement.getAttribute("id"),
    );
  }
}

/// The harmony-arrangement type indicates how stacked
/// chords and bass notes are displayed within a harmony element.
enum HarmonyArrangement {
  /// The horizontal value specifies that the second element appears to the right of the first.
  horizontal,

  /// The vertical value specifies that the second element appears below the first.
  vertical,

  /// The diagonal value specifies that the second element appears both below and to the right of the first.
  diagonal;
}

/// The harmony-type type differentiates different types of harmonies when alternate harmonies are possible.
enum HarmonyType {
  /// Alternate analysis.
  alternate,

  /// All notes present in the music.
  explicit,

  /// Some notes are missing but implied.
  implied;
}

/// The harmony-alter type represents the chromatic alteration of the root, numeral,
/// or bass of the current harmony-chord group within the harmony element.
///
/// In some chord styles, the text of the preceding element may include alteration information.
///
/// In that case, the print-object attribute of this type can be set to no.
///
/// The location attribute indicates whether the alteration should appear to the left or the right of the preceding element.
///
/// Its default value varies by element.
class HarmonyAlter {
  /// The semitones type is a number representing semitones, used for chromatic alteration.
  ///
  /// A value of -1 corresponds to a flat and a value of 1 to a sharp.
  ///
  /// Decimal values like 0.5 (quarter tone sharp) are used for microtones.
  double semitones;

  /// Specifies whether or not to print an object. It is yes if not specified.
  bool printObject;

  PrintStyle printStyle;

  /// Indicates whether the alteration should appear to the left or the right of the step.
  ///
  /// It is right if not specified.
  LeftRight location;

  HarmonyAlter({
    required this.semitones,
    required this.printObject,
    required this.printStyle,
    required this.location,
  });
}
