// <xs:group name="music-data">
// 	<xs:annotation>
// 		<xs:documentation>The music-data group contains the basic musical data that is either associated with a part or a measure, depending on whether the partwise or timewise hierarchy is used.</xs:documentation>
// 	</xs:annotation>
// 	<xs:sequence>
// 		<xs:choice minOccurs="0" maxOccurs="unbounded">
// 			<xs:element name="note" type="note"/>
// 			<xs:element name="backup" type="backup"/>
// 			<xs:element name="forward" type="forward"/>
// 			<xs:element name="direction" type="direction"/>
// 			<xs:element name="attributes" type="attributes"/>
// 			<xs:element name="harmony" type="harmony"/>
// 			<xs:element name="figured-bass" type="figured-bass"/>
// 			<xs:element name="print" type="print"/>
// 			<xs:element name="sound" type="sound"/>
// 			<xs:element name="listening" type="listening"/>
// 			<xs:element name="barline" type="barline"/>
// 			<xs:element name="grouping" type="grouping"/>
// 			<xs:element name="link" type="link"/>
// 			<xs:element name="bookmark" type="bookmark"/>
// 		</xs:choice>
// 	</xs:sequence>
// </xs:group>

import 'package:xml/xml.dart';

/// The music-data group contains the basic musical data that is either associated with a part or a measure,
/// depending on whether the partwise or timewise hierarchy is used.
class MusicData {
  List<MusicDataElement> data;
  MusicData({
    required this.data,
  });

  toXml() {}

  fromXml(XmlElement? element) {}
}

abstract class MusicDataElement {}
