// <xs:complexType name="accordion-registration">

// 	<xs:sequence>
// 		<xs:element name="accordion-high" type="empty" minOccurs="0">
// 			<xs:annotation>
// 				<xs:documentation>The accordion-high element indicates the presence of a dot in the high (4') section of the registration symbol. This element is omitted if no dot is present.</xs:documentation>
// 			</xs:annotation>
// 		</xs:element>
// 		<xs:element name="accordion-middle" type="accordion-middle" minOccurs="0">
// 			<xs:annotation>
// 				<xs:documentation>The accordion-middle element indicates the presence of 1 to 3 dots in the middle (8') section of the registration symbol. This element is omitted if no dots are present.</xs:documentation>
// 			</xs:annotation>
// 		</xs:element>
// 		<xs:element name="accordion-low" type="empty" minOccurs="0">
// 			<xs:annotation>
// 				<xs:documentation>The accordion-low element indicates the presence of a dot in the low (16') section of the registration symbol. This element is omitted if no dot is present.</xs:documentation>
// 			</xs:annotation>
// 		</xs:element>
// 	</xs:sequence>
// 	<xs:attributeGroup ref="print-style-align"/>
// 	<xs:attributeGroup ref="optional-unique-id"/>
// </xs:complexType>

import 'package:music_notation/src/models/generic.dart';
import 'package:music_notation/src/models/printing.dart';

/// The accordion-registration type is used for accordion registration symbols.
///
/// These are circular symbols divided horizontally into high, middle, and low sections
/// that correspond to 4', 8', and 16' pipes.
///
/// Each accordion-high, accordion-middle, and accordion-low element represents
/// the presence of one or more dots in the registration diagram.
///
/// An accordion-registration element needs to have at least one of the child elements present.
class AccordionRegistration {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// The accordion-high element indicates the presence of a dot in
  /// the high (4') section of the registration symbol.
  ///
  /// This element is omitted if no dot is present.
  Empty? high;

  /// The accordion-middle element indicates the presence of 1 to 3 dots in
  /// the middle (8') section of the registration symbol.
  ///
  /// This element is omitted if no dots are present.
  Empty? middle;

  /// The accordion-low element indicates the presence of a dot
  /// in the low (16') section of the registration symbol.
  ///
  /// This element is omitted if no dot is present.
  Empty? low;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  PrintStyleAlign printStyleAlign;

  String? id;

  AccordionRegistration({
    this.high,
    this.middle,
    this.low,
    required this.printStyleAlign,
    this.id,
  });
}
