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

import 'package:music_notation/models/elements/bookmark.dart';
import 'package:music_notation/models/elements/link.dart';
import 'package:music_notation/models/elements/listening.dart';
import 'package:music_notation/models/elements/music_data/attributes/attributes.dart';
import 'package:music_notation/models/elements/music_data/backup.dart';
import 'package:music_notation/models/elements/music_data/barline.dart';
import 'package:music_notation/models/elements/music_data/direction/direction.dart';
import 'package:music_notation/models/elements/music_data/figured_bass.dart';
import 'package:music_notation/models/elements/music_data/forward.dart';
import 'package:music_notation/models/elements/music_data/harmony/harmony.dart';
import 'package:music_notation/models/elements/music_data/note/note.dart';
import 'package:music_notation/models/elements/music_data/print.dart';
import 'package:music_notation/models/elements/sound/sound.dart';
import 'package:xml/xml.dart';

/// The music-data group contains the basic musical data that is either associated with a part or a measure,
/// depending on whether the partwise or timewise hierarchy is used.
class MusicData {
  List<MusicDataElement> data;
  MusicData({
    required this.data,
  });

  toXml() {}

  factory MusicData.fromXml(XmlElement element) {
    return MusicData(data: []);
  }
}

abstract class MusicDataElement {
  factory MusicDataElement.fromXml(XmlElement xmlElement) {
    switch (xmlElement.name.local) {
      case 'note':
        return Note.fromXml(xmlElement);
      case 'backup':
        return Backup.fromXml(xmlElement);
      case 'forward':
        return Forward.fromXml(xmlElement);
      case 'direction':
        return Direction.fromXml(xmlElement);
      case 'attributes':
        return Attributes.fromXml(xmlElement);
      case 'harmony':
        return Harmony.fromXml(xmlElement);
      case 'figured-bass':
        return FiguredBass.fromXml(xmlElement);
      case 'print':
        return Print.fromXml(xmlElement);
      case 'sound':
        return Sound.fromXml(xmlElement);
      case 'listening':
        return Listening.fromXml(xmlElement);
      case 'barline':
        return Barline.fromXml(xmlElement);
      case 'grouping':
        return Barline.fromXml(xmlElement);
      case 'link':
        return Link.fromXml(xmlElement);
      case 'bookmark':
        return Bookmark.fromXml(xmlElement);
      default:
        throw Exception('Unknown element: ${xmlElement.name.local}');
    }
  }
}
