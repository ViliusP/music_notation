import 'package:music_notation/models/elements/music_data/music_data.dart';
import 'package:xml/xml.dart';


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

  Offset offset;


  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //


  Direction({
    required this.duration,
    required this.staff,
    required this.editorialVoice,
  });

  factory Direction.fromXml(XmlElement xmlElement) {
    return Direction(
      duration: 1,
      staff: 1,
      editorialVoice: EditorialVoice.fromXml(xmlElement),
    );
  }
}


enum DirectionType {

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
class DirectionType {

}

// 	<xs:complexType name="direction-type">
// 		<xs:annotation>
// 			<xs:documentation></xs:documentation>
// 		</xs:annotation>
// 		<xs:choice>
// 			<xs:element name="rehearsal" type="formatted-text-id" maxOccurs="unbounded">
// 				<xs:annotation>
// 					<xs:documentation>The rehearsal element specifies letters, numbers, and section names that are notated in the score for reference during rehearsal. The enclosure is square if not specified. The language is Italian ("it") if not specified. Left justification is used if not specified.</xs:documentation>
// 				</xs:annotation>
// 			</xs:element>
// 			<xs:element name="segno" type="segno" maxOccurs="unbounded"/>
// 			<xs:element name="coda" type="coda" maxOccurs="unbounded"/>
// 			<xs:choice maxOccurs="unbounded">
// 				<xs:element name="words" type="formatted-text-id">
// 					<xs:annotation>
// 						<xs:documentation>The words element specifies a standard text direction. The enclosure is none if not specified. The language is Italian ("it") if not specified. Left justification is used if not specified.</xs:documentation>
// 					</xs:annotation>
// 				</xs:element>
// 				<xs:element name="symbol" type="formatted-symbol-id">
// 					<xs:annotation>
// 						<xs:documentation>The symbol element specifies a musical symbol using a canonical SMuFL glyph name. It is used when an occasional musical symbol is interspersed into text. It should not be used in place of semantic markup, such as metronome marks that mix text and symbols. Left justification is used if not specified. Enclosure is none if not specified.</xs:documentation>
// 					</xs:annotation>
// 				</xs:element>
// 			</xs:choice>
// 			<xs:element name="wedge" type="wedge"/>
// 			<xs:element name="dynamics" type="dynamics" maxOccurs="unbounded"/>
// 			<xs:element name="dashes" type="dashes"/>
// 			<xs:element name="bracket" type="bracket"/>
// 			<xs:element name="pedal" type="pedal"/>
// 			<xs:element name="metronome" type="metronome"/>
// 			<xs:element name="octave-shift" type="octave-shift"/>
// 			<xs:element name="harp-pedals" type="harp-pedals"/>
// 			<xs:element name="damp" type="empty-print-style-align-id">
// 				<xs:annotation>
// 					<xs:documentation>The damp element specifies a harp damping mark.</xs:documentation>
// 				</xs:annotation>
// 			</xs:element>
// 			<xs:element name="damp-all" type="empty-print-style-align-id">
// 				<xs:annotation>
// 					<xs:documentation>The damp-all element specifies a harp damping mark for all strings.</xs:documentation>
// 				</xs:annotation>
// 			</xs:element>
// 			<xs:element name="eyeglasses" type="empty-print-style-align-id">
// 				<xs:annotation>
// 					<xs:documentation>The eyeglasses element represents the eyeglasses symbol, common in commercial music.</xs:documentation>
// 				</xs:annotation>
// 			</xs:element>
// 			<xs:element name="string-mute" type="string-mute"/>
// 			<xs:element name="scordatura" type="scordatura"/>
// 			<xs:element name="image" type="image"/>
// 			<xs:element name="principal-voice" type="principal-voice"/>
// 			<xs:element name="percussion" type="percussion" maxOccurs="unbounded"/>
// 			<xs:element name="accordion-registration" type="accordion-registration"/>
// 			<xs:element name="staff-divide" type="staff-divide"/>
// 			<xs:element name="other-direction" type="other-direction"/>
// 		</xs:choice>
// 		<xs:attributeGroup ref="optional-unique-id"/>
// 	</xs:complexType>
