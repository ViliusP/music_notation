import 'package:music_notation/models/score_header.dart';

/// The score-partwise element is the root element for a partwise MusicXML score.
/// It includes a score-header group followed by a series of parts with measures inside.
/// The document-attributes attribute group includes the version attribute.
class ScorePartwise {
  final ScoreHeader scoreHeader;
  // final List<Part> parts;
  // final DocumentAttributes documentAttributes;

  ScorePartwise({
    required this.scoreHeader,
    // required this.parts,
    // required this.documentAttributes,
  });
}

	// <xs:element name="score-partwise" block="extension substitution" final="#all">
	// 	<xs:annotation>
	// 		<xs:documentation>The score-partwise element is the root element for a partwise MusicXML score. It includes a score-header group followed by a series of parts with measures inside. The document-attributes attribute group includes the version attribute.</xs:documentation>
	// 	</xs:annotation>
	// 	<xs:complexType>
	// 		<xs:sequence>
	// 			<xs:group ref="score-header"/>
	// 			<xs:element name="part" maxOccurs="unbounded">
	// 				<xs:complexType>
	// 					<xs:sequence>
	// 						<xs:element name="measure" maxOccurs="unbounded">
	// 							<xs:complexType>
	// 								<xs:group ref="music-data"/>
	// 								<xs:attributeGroup ref="measure-attributes"/>
	// 							</xs:complexType>
	// 						</xs:element>
	// 					</xs:sequence>
	// 					<xs:attributeGroup ref="part-attributes"/>
	// 				</xs:complexType>
	// 			</xs:element>
	// 		</xs:sequence>
	// 		<xs:attributeGroup ref="document-attributes"/>
	// 	</xs:complexType>
	// </xs:element>

  