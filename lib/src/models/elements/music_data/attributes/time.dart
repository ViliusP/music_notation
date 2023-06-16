// 	<xs:complexType name="time">
// 		<xs:annotation>
// 			<xs:documentation>Time signatures are represented by the beats element for the numerator and the beat-type element for the denominator. The symbol attribute is used to indicate common and cut time symbols as well as a single number display. Multiple pairs of beat and beat-type elements are used for composite time signatures with multiple denominators, such as 2/4 + 3/8. A composite such as 3+2/8 requires only one beat/beat-type pair.

// The print-object attribute allows a time signature to be specified but not printed, as is the case for excerpts from the middle of a score. The value is "yes" if not present. The optional number attribute refers to staff numbers within the part. If absent, the time signature applies to all staves in the part.</xs:documentation>
// 		</xs:annotation>
// 		<xs:choice>
// 			<xs:sequence>
// 				<xs:group ref="time-signature" maxOccurs="unbounded"/>
// 				<xs:element name="interchangeable" type="interchangeable" minOccurs="0"/>
// 			</xs:sequence>
// 			<xs:element name="senza-misura" type="xs:string">
// 				<xs:annotation>
// 					<xs:documentation>A senza-misura element explicitly indicates that no time signature is present. The optional element content indicates the symbol to be used, if any, such as an X. The time element's symbol attribute is not used when a senza-misura element is present.</xs:documentation>
// 				</xs:annotation>
// 			</xs:element>
// 		</xs:choice>
// 		<xs:attribute name="number" type="staff-number"/>
// 		<xs:attribute name="symbol" type="time-symbol"/>
// 		<xs:attribute name="separator" type="time-separator"/>
// 		<xs:attributeGroup ref="print-style-align"/>
// 		<xs:attributeGroup ref="print-object"/>
// 		<xs:attributeGroup ref="optional-unique-id"/>
// 	</xs:complexType>

import 'package:music_notation/src/models/printing.dart';

/// Time signatures are represented by the beats element for the numerator and
/// the beat-type element for the denominator.
///
/// The symbol attribute is used to indicate common and cut time symbols as well as a single number display.
///
/// Multiple pairs of beat and beat-type elements are used for composite time signatures with multiple denominators,
/// such as 2/4 + 3/8. A composite such as 3+2/8 requires only one beat/beat-type pair.
///
/// The print-object attribute allows a time signature to be specified but not printed,
/// as is the case for excerpts from the middle of a score. The value is "yes" if not present.
///
/// The optional number attribute refers to staff numbers within the part.
/// If absent, the time signature applies to all staves in the part.
abstract class Time {
  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Allows a time signature to apply to only the specified staff in the part.
  /// If absent, the time signature applies to all staves in the part.
  int number;

  /// Indicates how to display a time signature,
  /// such as by using common and cut time symbols or a single number display.
  TimeSymbol symbol;

  /// Indicates how to display the arrangement between the [beats] and [beatType] values in a time signature.
  TimeSeparator separator;

  PrintStyleAlign printStyleAlign;

  bool printObject;

  String? id;

  Time({
    required this.number,
    this.symbol = TimeSymbol.normal,
    this.separator = TimeSeparator.none,
    required this.printStyleAlign,
    required this.printObject,
    this.id,
  });
}

class TimeBeat extends Time {
  List<TimeSignature> timeSignatures;

  Interchangeable? interchangeable;

  TimeBeat({
    required this.timeSignatures,
    this.interchangeable,
    required super.number,
    required super.printStyleAlign,
    required super.printObject,
  });
}

/// The interchangeable type is used to represent the second in a pair of interchangeable dual time signatures,
/// such as the 6/8 in 3/4 (6/8).
///
/// A separate symbol attribute value is available compared to the time element's symbol attribute,
/// which applies to the first of the dual time signatures.
class Interchangeable {
  TimeRelation? timeRelation;

  List<TimeSignature> timeSignatures;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  TimeSymbol symbol;

  TimeSeparator timeSeparator;

  Interchangeable({
    this.timeRelation,
    required this.timeSignatures,
    required this.symbol,
    required this.timeSeparator,
  });
}

/// Time signatures are represented by the beats element for the numerator and
/// the beat-type element for the denominator.
class TimeSignature {
  /// The beats element indicates the number of beats, as found in the numerator of a time signature.
  String beats;

  /// The beat-type element indicates the beat unit, as found in the denominator of a time signature.
  String beatType;

  TimeSignature({
    required this.beats,
    required this.beatType,
  });
}

enum TimeRelation {
  parentheses,
  bracket,
  equals,
  slash,
  space,
  hyphen;
}

/// A senza-misura element explicitly indicates that no time signature is present.
///
/// The optional element content indicates the symbol to be used, if any, such as an X.
///
/// The time element's symbol attribute is not used when a senza-misura element is present.
class SenzaMisura extends Time {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  String? content;

  SenzaMisura({
    required super.number,
    required super.printStyleAlign,
    required super.printObject,
  });
}

/// The time-symbol type indicates how to display a time signature.
///
/// The normal value is the usual fractional display, and is the implied symbol type if none is specified.
///
/// Other options are the common and cut time symbols,
/// as well as a single number with an implied denominator.
///
/// The note symbol indicates that the beat-type should be represented
/// with the corresponding downstem note rather than a number.
///
/// The dotted-note symbol indicates that the beat-type should be represented
/// with a dotted downstem note that corresponds to three times the beat-type value,
/// and a numerator that is one third the beats value.
enum TimeSymbol {
  common,
  cut,
  singleNumber,
  note,
  dottedNote,
  normal;
}

/// The time-separator type indicates how to display the arrangement between
/// the beats and beat-type values in a time signature.
///
/// The default value is none.
///
/// The horizontal, diagonal, and vertical values represent
/// horizontal, diagonal lower-left to upper-right, and vertical lines respectively.
///
/// For these values, the beats and beat-type values are arranged on either side of the separator line.
///
/// The none value represents no separator with the beats and beat-type arranged vertically.
///
/// The adjacent value represents no separator with the beats and beat-type arranged horizontally.
enum TimeSeparator {
  none,
  horizontal,
  diagonal,
  vertical,
  adjacent;
}
