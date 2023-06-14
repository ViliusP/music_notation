// <xs:complexType name="staff-details">
// 	<xs:annotation>
// 		<xs:documentation>The staff-details element is used to indicate different types of staves. The optional number attribute specifies the staff number from top to bottom on the system, as with clef. The print-object attribute is used to indicate when a staff is not printed in a part, usually in large scores where empty parts are omitted. It is yes by default. If print-spacing is yes while print-object is no, the score is printed in cutaway format where vertical space is left for the empty part.</xs:documentation>
// 	</xs:annotation>
// 	<xs:sequence>
// 		<xs:element name="staff-type" type="staff-type" minOccurs="0"/>
// 		<xs:sequence minOccurs="0">
// 			<xs:element name="staff-lines" type="xs:nonNegativeInteger">
// 				<xs:annotation>
// 					<xs:documentation>The staff-lines element specifies the number of lines and is usually used for a non 5-line staff. If the staff-lines element is present, the appearance of each line may be individually specified with a line-detail element. </xs:documentation>
// 				</xs:annotation>
// 			</xs:element>
// 			<xs:element name="line-detail" type="line-detail" minOccurs="0" maxOccurs="unbounded"/>
// 		</xs:sequence>
// 		<xs:element name="staff-tuning" type="staff-tuning" minOccurs="0" maxOccurs="unbounded"/>
// 		<xs:element name="capo" type="xs:nonNegativeInteger" minOccurs="0">
// 			<xs:annotation>
// 				<xs:documentation>The capo element indicates at which fret a capo should be placed on a fretted instrument. This changes the open tuning of the strings specified by staff-tuning by the specified number of half-steps.</xs:documentation>
// 			</xs:annotation>
// 		</xs:element>
// 		<xs:element name="staff-size" type="staff-size" minOccurs="0"/>
// 	</xs:sequence>
// 	<xs:attribute name="number" type="staff-number"/>
// 	<xs:attribute name="show-frets" type="show-frets"/>
// 	<xs:attributeGroup ref="print-object"/>
// 	<xs:attributeGroup ref="print-spacing"/>
// </xs:complexType>

import 'package:music_notation/models/elements/music_data/direction/scordatura.dart';
import 'package:music_notation/models/elements/music_data/note/notations/notation.dart';
import 'package:music_notation/models/text.dart';

/// The staff-details element is used to indicate different types of staves.
///
/// The optional number attribute specifies the staff number from top to bottom on the system, as with clef.
///
/// The print-object attribute is used to indicate when a staff is not printed in a part,
/// usually in large scores where empty parts are omitted.
/// It is yes by default.
///
/// If print-spacing is yes while print-object is no,
/// the score is printed in cutaway format where vertical space is left for the empty part.
class StaffDetails {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //
  StaffType? staffType;

  /// The staff-lines element specifies the number of lines and is usually used for a non 5-line staff.
  ///
  /// If the staff-lines element is present,
  /// the appearance of each line may be individually specified with a line-detail element.
  int staffLines;

  /// See more at [LineDetail].
  List<LineDetail> lineDetails;

  /// See more at [StaffTuning].
  List<StaffTuning> staffTunings;

  /// Indicates at which fret a capo should be placed on a fretted instrument.
  ///
  /// This changes the open tuning of the strings specified by the [StaffTuning] element
  /// by the specified number of half-steps.
  int? capo;

  /// See more at [StaffSize].
  StaffSize? staffSize;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Specifies the staff number from top to bottom within the part.
  ///
  /// The value is 1 if not present.
  int number;

  /// Specifies whether or not to print an object.
  ///
  /// It is yes if not specified.
  bool printObject;

  /// Controls whether or not spacing is left for an invisible note or object.
  ///
  ///  It is used only if no note, dot, or lyric is being printed.
  ///
  /// The value is yes (leave spacing) if not specified.
  bool printSpacing;

  ShowFrets showFrets;

  StaffDetails({
    this.staffType,
    required this.staffLines,
    required this.lineDetails,
    required this.staffTunings,
    this.capo,
    this.staffSize,
    required this.number,
    required this.printObject,
    required this.printSpacing,
    required this.showFrets,
  });
}

/// The show-frets type indicates whether to show tablature frets
/// as numbers (0, 1, 2) or letters (a, b, c).
///
/// The default choice is numbers.
enum ShowFrets {
  letters,
  numbers;
}

/// The staff-type value can be ossia, editorial, cue, alternate, or regular.
///
/// An ossia staff represents music that can be played instead of what appears on the regular staff.
///
/// An editorial staff also represents musical alternatives,
/// but is created by an editor rather than the composer.
///
///  It can be used for suggested interpretations or alternatives from other sources.
///
/// A cue staff represents music from another part.
///
/// An alternate staff shares the same music as the prior staff,
/// but displayed differently (e.g., treble and bass clef, standard notation and tablature).
///
/// It is not included in playback.
///
/// An alternate staff provides more information to an application reading a file
/// than encoding the same music in separate parts,
/// so its use is preferred in this situation if feasible.
///
/// A regular staff is the standard default staff-type.
enum StaffType {
  ossia,
  editorial,
  cue,
  alternate,
  regular;
}

/// If the staff-lines element is present,
/// the appearance of each line may be individually specified with a line-detail type.
///
/// Staff lines are numbered from bottom to top.
///
/// The print-object attribute allows lines to be hidden within a staff.
///
/// This is used in special situations such as a widely-spaced percussion staff
/// where a note placed below the higher line is distinct from a note placed above the lower line.
///
/// Hidden staff lines are included when specifying clef lines and determining
/// display-step / display-octave values,
/// but are not counted as lines for the purposes of the system-layout and staff-layout elements.
class LineDetail {
  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Indicates the staff line affected, numbered from bottom to top.
  int staffLine;

  /// Staff line width in tenths.
  double width;

  /// Indicates the color of an element.
  Color color;

  /// Specifies if the line is solid, dashed, dotted, or wavy.
  LineType lineType;

  /// Specifies whether or not to print an object. It is yes if not specified.
  bool printObject;

  LineDetail({
    required this.staffLine,
    required this.width,
    required this.color,
    required this.lineType,
    required this.printObject,
  });
}

/// The staff-tuning type specifies the open, non-capo tuning of the lines on a tablature staff.
class StaffTuning {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  Tuning tuning;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Indicates the staff line for this tuning, numbered from bottom to top.
  int line;

  StaffTuning({
    required this.tuning,
    required this.line,
  });
}

/// The staff-size element indicates how large a staff space is on this staff,
/// expressed as a percentage of the work's default scaling.
/// Values less than 100 make the staff space smaller while values over 100 make the staff space larger.
/// A staff-type of cue, ossia, or editorial implies a staff-size of less than 100,
/// but the exact value is implementation-dependent unless specified here.
///
/// Staff size affects staff height only, not the relationship of the staff to the left and right margins.
///
/// In some cases, a staff-size different than 100 also scales the notation on the staff,
/// such as with a cue staff.
///
/// In other cases, such as percussion staves,
/// the lines may be more widely spaced without scaling the notation on the staff.
///
/// The scaling attribute allows these two cases to be distinguished.
///
/// It specifies the percentage scaling that applies to the notation.
///
/// Values less that 100 make the notation smaller while values over 100 make the notation larger.
///
/// The staff-size content and scaling attribute are both non-negative decimal values.
class StaffSize {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  double value;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  double? scaling;

  StaffSize({
    required this.value,
    this.scaling,
  });
}
