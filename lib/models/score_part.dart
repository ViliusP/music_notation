import 'package:music_notation/models/identification.dart';

/// The score-part type collects part-wide information for each part in a score.
///
/// Often, each MusicXML part corresponds to a track in a Standard MIDI Format 1 file.
///
/// In this case, the midi-device element is used to make a MIDI device or port assignment
/// for the given track or specific MIDI instruments.
///
/// Initial midi-instrument assignments may be made here as well.
///
/// The score-instrument elements are used when there are multiple instruments per track.
class ScorePart {
// 		<xs:element name="part-link" type="part-link" minOccurs="0" maxOccurs="unbounded"/>
// 		<xs:element name="part-name" type="part-name"/>
// 		<xs:element name="part-name-display" type="name-display" minOccurs="0"/>
// 		<xs:element name="part-abbreviation" type="part-name" minOccurs="0"/>
// 		<xs:element name="part-abbreviation-display" type="name-display" minOccurs="0"/>
// 		<xs:element name="group" type="xs:string" minOccurs="0" maxOccurs="unbounded">
// 			<xs:annotation>
// 				<xs:documentation>The group element allows the use of different versions of the part for different purposes. Typical values include score, parts, sound, and data. Ordering information can be derived from the ordering within a MusicXML score or opus.</xs:documentation>
// 			</xs:annotation>
// 		</xs:element>
// 		<xs:element name="score-instrument" type="score-instrument" minOccurs="0" maxOccurs="unbounded"/>
// 		<xs:element name="player" type="player" minOccurs="0" maxOccurs="unbounded"/>
// 		<xs:sequence minOccurs="0" maxOccurs="unbounded">
// 			<xs:element name="midi-device" type="midi-device" minOccurs="0"/>
// 			<xs:element name="midi-instrument" type="midi-instrument" minOccurs="0"/>
// 		</xs:sequence>

  String? id;

  Identification? identification;

  String? partName;

  /// The name-display type is used for exact formatting of multi-font text
  /// in part and group names to the left of the system.
  /// The print-object attribute can be used to determine what,
  /// if anything, is printed at the start of each system.
  /// Enclosure for the display-text element is none by default.
  /// Language for the display-text element is Italian ("it") by default.
  ///
  /// Minimal occurence - 0.
  String? partNameDisplay;

  ScorePart({this.id, this.partName});
}
