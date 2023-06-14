import 'package:xml/xml.dart';

import 'package:music_notation/models/elements/music_data/music_data.dart';
import 'package:music_notation/models/elements/offset.dart';

/// A direction is a musical indication that is not necessarily attached to a specific note.
///
/// Two or more may be combined to indicate words followed by the start of a dashed line,
/// the end of a wedge followed by dynamics, etc.
///
/// For applications where a specific direction is indeed attached to a specific note,
/// the direction element can be associated with the first note element that follows it in score order that is not in a different voice.
///
/// By default, a series of direction-type elements and a series of child elements of a direction-type within a single direction element follow one another in sequence visually.
///
/// For a series of direction-type children, non-positional formatting attributes are carried over from the previous element by default.
class Direction extends MusicDataElement {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  List<DirectionType> types;

  Offset? offset;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  Direction({
    required this.types,
    this.offset,
  });

  factory Direction.fromXml(XmlElement xmlElement) {
    return Direction(
      types: [],
    );
  }
}

// 	<xs:complexType name="direction">
// 		<xs:annotation>
// 			<xs:documentation></xs:documentation>
// 		</xs:annotation>
// 		<xs:sequence>
// 			<xs:element name="direction-type" type="direction-type" maxOccurs="unbounded"/>
// 			<xs:element name="offset" type="offset" minOccurs="0"/>
// 			<xs:group ref="editorial-voice-direction"/>
// 			<xs:group ref="staff" minOccurs="0"/>
// 			<xs:element name="sound" type="sound" minOccurs="0"/>
// 			<xs:element name="listening" type="listening" minOccurs="0"/>
// 		</xs:sequence>
// 		<xs:attributeGroup ref="placement"/>
// 		<xs:attributeGroup ref="directive"/>
// 		<xs:attributeGroup ref="system-relation"/>
// 		<xs:attributeGroup ref="optional-unique-id"/>
// 	</xs:complexType>
/// Textual direction types may have more than 1 component due to multiple fonts.
///
/// The dynamics element may also be used in the notations element.
///
/// Attribute groups related to print suggestions apply to the individual direction-type, not to the overall direction.
abstract class DirectionType {}
