import 'package:music_notation/models/identification.dart';
import 'package:music_notation/models/text.dart';
import 'package:xml/xml.dart';

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

  List<PartLink>? partLinks;

  /// he part-name type describes the name or abbreviation of a score-part element.
  ///
  /// Formatting attributes for the part-name element are deprecated in Version 2.0 in favor of the new part-name-display and part-abbreviation-display elements.
  ///
  /// Important: it is just String and does not implement this part from XTS
  /// ```xml
  /// <xs:attributeGroup ref="part-name-text"/>
  /// ```
  String? partName;

  // NameDisplay partNameDispaly;

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

/// The part-link type allows MusicXML data for both score and parts to be contained within a single compressed MusicXML file.
/// It links a score-part from a score document to MusicXML documents that contain parts data.
/// In the case of a single compressed MusicXML file,
/// the link href values are paths that are relative to the root folder of the zip file.
class PartLink {
  String? linkAttributes;

  /// Multiple part-link elements can link a condensed part within a score file to multiple MusicXML parts files.
  /// For example, a "Clarinet 1 and 2" part in a score file could link to separate "Clarinet 1" and "Clarinet 2" part files.
  ///
  /// The instrument-link type distinguish which of the score-instruments within a score-part are in which part file.
  ///
  /// The instrument-link id attribute refers to a score-instrument id attribute.
  ///
  /// In XML schema it references to unique identifiers.
  List<String>? instrumentLinks;

  /// Multiple part-link elements can reference different types of linked documents,
  /// such as parts and condensed score.
  ///
  /// The optional group-link elements identify the groups used in the linked document.
  ///
  /// The content of a group-link element should match the content of a group element in the linked document.
  List<String>? groupLinks;

  PartLink({
    this.instrumentLinks,
    this.groupLinks,
  });
}

/// The name-display type is used for exact formatting of multi-font text in part and group names to the left of the system.
///
/// The print-object attribute can be used to determine what, if anything, is printed at the start of each system.
///
/// Enclosure for the display-text element is none by default. Language for the display-text element is Italian ("it") by default.
class NameDisplay {
  List<FormattedText>? displayTexts;
  // List<AccidentalText>? accidentalTexts;
  // PrintObject printObject;

  NameDisplay({
    required this.displayTexts,
    // required this.accidentalTexts,
    // required this.printObject,
  });

  factory NameDisplay.fromXml(XmlElement xmlElement) {
    var displayTexts = <FormattedText>[];
    // var accidentalTexts = <AccidentalText>[];

    for (var element in xmlElement.findElements('display-text')) {
      displayTexts.add(FormattedText.fromXml(element));
    }

    // for (var element in xmlElement.findElements('accidental-text')) {
    //   accidentalTexts.add(AccidentalText.fromXml(element));
    // }

    return NameDisplay(
      displayTexts: displayTexts,
      // accidentalTexts: accidentalTexts,
      // printObject: PrintObject.fromXml(xmlElement),
    );
  }

  // <xs:complexType name="name-display">
  // 	<xs:annotation>
  // 		<xs:documentation>The name-display type is used for exact formatting of multi-font text in part and group names to the left of the system. The print-object attribute can be used to determine what, if anything, is printed at the start of each system. Enclosure for the display-text element is none by default. Language for the display-text element is Italian ("it") by default.</xs:documentation>
  // 	</xs:annotation>
  // 	<xs:sequence>
  // 		<xs:choice minOccurs="0" maxOccurs="unbounded">
  // 			<xs:element name="display-text" type="formatted-text"/>
  // 			<xs:element name="accidental-text" type="accidental-text"/>
  // 		</xs:choice>
  // 	</xs:sequence>
  // 	<xs:attributeGroup ref="print-object"/>
  // </xs:complexType>
}
