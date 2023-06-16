// <xs:complexType name="backup">
// 	<xs:annotation>
// 		<xs:documentation></xs:documentation>
// 	</xs:annotation>
// 	<xs:sequence>
// 		<xs:group ref="duration"/>
// 		<xs:group ref="editorial"/>
// 	</xs:sequence>
// </xs:complexType>

import 'package:music_notation/src/models/elements/editorial.dart';
import 'package:music_notation/src/models/elements/music_data/music_data.dart';
import 'package:xml/xml.dart';

/// The backup and forward elements are required to coordinate multiple voices in one part,
/// including music on multiple staves.
///
/// The backup type is generally used to move between voices and staves.
///
/// Thus the backup element does not include voice or staff elements. Duration values should always be positive,
/// and should not cross measure boundaries or mid-measure changes in the divisions value.
class Backup implements MusicDataElement {
  /// The duration element is defined within a group due to its uses within the note, figured-bass, backup, and forward elements.
  double duration;

  Editorial editorial;

  Backup({
    required this.duration,
    required this.editorial,
  });

  factory Backup.fromXml(XmlElement xmlElement) {
    return Backup(
      duration: 1,
      editorial: Editorial.fromXml(xmlElement),
    );
  }
}


	// <xs:simpleType name="positive-divisions">
	// 	<xs:annotation>
	// 		<xs:documentation>The positive-divisions type restricts divisions values to positive numbers.</xs:documentation>
	// 	</xs:annotation>
	// 	<xs:restriction base="divisions">
	// 		<xs:minExclusive value="0"/>
	// 	</xs:restriction>
	// </xs:simpleType>
