import 'package:music_notation/models/printing.dart';

/// The other-direction type is used to define any direction symbols not yet in the MusicXML format.
///
/// The smufl attribute can be used to specify a particular direction symbol,
/// allowing application interoperability
/// without requiring every SMuFL glyph to have a MusicXML element equivalent.
///
/// Using the other-direction type without the smufl attribute allows for extended representation,
/// though without application interoperability.
class OtherDirection {
  String value;

  bool printObject;

  PrintStyleAlign printStyleAlign;

  String? smufl;

  String? id;

  OtherDirection({
    required this.value,
    required this.printObject,
    required this.printStyleAlign,
    this.smufl,
    this.id,
  });
}

// <xs:complexType name="other-direction">
// 	<xs:annotation>
// 		<xs:documentation>The other-direction type is used to define any direction symbols not yet in the MusicXML format. The smufl attribute can be used to specify a particular direction symbol, allowing application interoperability without requiring every SMuFL glyph to have a MusicXML element equivalent. Using the other-direction type without the smufl attribute allows for extended representation, though without application interoperability.</xs:documentation>
// 	</xs:annotation>
// 	<xs:simpleContent>
// 		<xs:extension base="xs:string">
// 			<xs:attributeGroup ref="print-object"/>
// 			<xs:attributeGroup ref="print-style-align"/>
// 			<xs:attributeGroup ref="smufl"/>
// 			<xs:attributeGroup ref="optional-unique-id"/>
// 		</xs:extension>
// 	</xs:simpleContent>
// </xs:complexType>
