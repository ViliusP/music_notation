import 'package:xml/xml.dart';

import 'package:music_notation/models/printing.dart';
import 'package:music_notation/models/score_part.dart';
import 'package:music_notation/models/text.dart';

// <xs:complexType name="part-list">
// 	<xs:annotation>
// 		<xs:documentation>The part-list identifies the different musical parts in this document. Each part has an ID that is used later within the musical data. Since parts may be encoded separately and combined later, identification elements are present at both the score and score-part levels. There must be at least one score-part, combined as desired with part-group elements that indicate braces and brackets. Parts are ordered from top to bottom in a score based on the order in which they appear in the part-list.</xs:documentation>
// 	</xs:annotation>
// 	<xs:sequence>
// 		<xs:group ref="part-group" minOccurs="0" maxOccurs="unbounded"/>
// 		<xs:group ref="score-part"/>
// 		<xs:choice minOccurs="0" maxOccurs="unbounded">
// 			<xs:group ref="part-group"/>
// 			<xs:group ref="score-part"/>
// 		</xs:choice>
// 	</xs:sequence>
// </xs:complexType>
//

// 	<xs:group name="score-part">
// 		<xs:annotation>
// 			<xs:documentation>The score-part element is defined within a group due to its multiple uses within the part-list element.</xs:documentation>
// 		</xs:annotation>
// 		<xs:sequence>
// 			<xs:element name="score-part" type="score-part">
// 				<xs:annotation>
// 					<xs:documentation>Each MusicXML part corresponds to a track in a Standard MIDI Format 1 file. The score-instrument elements are used when there are multiple instruments per track. The midi-device element is used to make a MIDI device or port assignment for the given track. Initial midi-instrument assignments may be made here as well.</xs:documentation>
// 				</xs:annotation>
// 			</xs:element>
// 		</xs:sequence>
// 	</xs:group>

/// The part-list identifies the different musical parts in this document.
///
/// Each part has an ID that is used later within the musical data.
///
/// Since parts may be encoded separately and combined later, identification elements are present at both the score and score-part levels.
///
/// There must be at least one score-part, combined as desired with part-group elements that indicate braces and brackets.
///
/// Parts are ordered from top to bottom in a score based on the order in which they appear in the part-list.
class PartList {
  // TODO: wtf this spec?
  final List<PartGroup> partGroups;
  final List<ScorePart> scoreParts;
  final List<dynamic>
      additionalPartGroupOrScorePart; // This could be PartGroup or ScorePart

  PartList({
    required this.partGroups,
    required this.scoreParts,
    required this.additionalPartGroupOrScorePart,
  });

  factory PartList.fromXml(XmlElement xmlElement) {
    return PartList(
      partGroups: xmlElement
          .findElements('part-group')
          .map((e) => PartGroup.fromXml(e))
          .toList(),
      scoreParts: xmlElement
          .findElements('score-part')
          .map((e) => ScorePart.fromXml(e))
          .toList(),
      additionalPartGroupOrScorePart:
          xmlElement.children.whereType<XmlElement>().map((e) {
        final element = e;
        switch (element.name.toString()) {
          case 'part-group':
            return PartGroup.fromXml(element);
          case 'score-part':
            return ScorePart.fromXml(element);
          default:
            throw ArgumentError(
                'Unsupported element ${element.name.toString()}');
        }
      }).toList(),
    );
  }

  XmlElement toXml() {
    final children = <XmlElement>[];
    children.addAll(partGroups.map((e) => e.toXml()));
    // children.addAll(scoreParts.map((e) => e.toXml()));
    // children.addAll(additionalPartGroupOrScorePart.map((e) {
    //   if (e is PartGroup) {
    //     return e.toXml();
    //   } else if (e is ScorePart) {
    //     return e.toXml();
    //   } else {
    //     throw ArgumentError('Unsupported type ${e.runtimeType}');
    //   }
    // }));
    return XmlElement(XmlName('part-list'), [], children);
  }
}

/// The part-group element indicates groupings of parts in the score, usually indicated by braces and brackets.
///
/// Braces that are used for multi-staff parts should be defined in the attributes element for that part.
///
/// The part-group start element appears before the first score-part in the group.
/// The part-group stop element appears after the last score-part in the group.
///
/// The number attribute is used to distinguish overlapping and nested part-groups,
/// not the sequence of groups. As with parts, groups can have a name and abbreviation.
/// Values for the child elements are ignored at the stop of a group.
///
/// A part-group element is not needed for a single multi-staff part.
///
/// By default, multi-staff parts include a brace symbol and (if appropriate given the bar-style) common barlines.
///
/// The symbol formatting for a multi-staff part can be more fully specified using the part-symbol element.
class PartGroup {
  GroupName? name;
  GroupName? nameAbbrevation;

  /// Formatting specified in the group-name-display element overrides formatting specified in the group-name element.
  NameDisplay? nameDisplay;

  /// Formatting specified in the group-abbreviation-display element overrides formatting specified in the group-abbreviation element.
  NameDisplay? nameDisplayAbbrevation;

  GroupSymbol? groupSymbol;

  GroupBarline? groupBarline;

  /// The group-time element indicates that the displayed time signatures should stretch across all parts and staves in the group.
  ///
  /// Type of "empty".
  /// The empty type represents an empty element with no attributes.
  bool? groupTime;

  Editorial editorial;

  StartStop type;

  String number = "1";

  PartGroup({
    this.name,
    this.nameAbbrevation,
    this.nameDisplay,
    this.nameDisplayAbbrevation,
    this.groupSymbol,
    this.groupBarline,
    this.groupTime,
    required this.editorial,
    required this.type,
    required this.number,
  });

// 			<xs:group ref="editorial"/>
// 		</xs:sequence>
// 		<xs:attribute name="type" type="start-stop" use="required"/>
// 		<xs:attribute name="number" type="xs:token" default="1"/>

  factory PartGroup.fromXml(XmlElement xmlElement) {
    return PartGroup(
      name: GroupName.fromXml(xmlElement.getElement('group-name')),
      nameDisplay: NameDisplay.fromXml(
        xmlElement.getElement('group-name-display')!,
      ),
      nameAbbrevation:
          GroupName.fromXml(xmlElement.getElement('group-abbreviation')),
      nameDisplayAbbrevation: NameDisplay.fromXml(
        xmlElement.getElement('group-abbreviation-display')!,
      ),
      groupSymbol: GroupSymbol.fromXml(xmlElement.getElement('group-symbol')),
      groupBarline:
          GroupBarline.fromXml(xmlElement.getElement('group-barline')),
      groupTime: xmlElement.getElement('group-time') != null,
      editorial: Editorial.fromXml(xmlElement.getElement('editorial')),
      type: StartStop.fromString(xmlElement.getAttribute('type')!),
      number: xmlElement.getAttribute('number', namespace: '*') ?? '1',
    );
  }

  XmlElement toXml() {
    final builder = XmlBuilder();
    // builder.element('part-group', attributes: {
    //   'type': type,
    //   'number': number,
    // }, nest: () {
    //   if (groupName != null) builder.element('group-name', nest: groupName);
    //   groupNameDisplay?.toXml(builder);
    //   if (groupAbbreviation != null)
    //     builder.element(
    //       'group-abbreviation',
    //       nest: groupAbbreviation,
    //     );
    //   groupAbbreviationDisplay?.toXml(builder);
    //   groupSymbol?.toXml(builder);
    //   groupBarline?.toXml(builder);
    //   if (groupTime) builder.element('group-time');
    //   editorial?.toXml(builder);
    // });

    return builder.buildDocument().rootElement;
  }
}

/// The group-symbol type indicates how the symbol for a group is indicated in the score.
///
/// It is none if not specified.
class GroupSymbol {
  GroupSymbolValue value = GroupSymbolValue.none;

  Position position;
  Color color;
  GroupSymbol({
    required this.position,
    required this.color,
  });

  static fromXml(XmlElement? element) {}
}

/// The group-symbol-value type indicates how the symbol for a group or multi-staff part is indicated in the score.
enum GroupSymbolValue {
  none,
  brace,
  line,
  bracket,
  square;
}

/// The group-barline type indicates if the group should have common barlines.
class GroupBarline {
  GroupSymbolValue value;
  Color color; // Maybe could be extend class Colarable (not implemented yet)
  GroupBarline({
    required this.value,
    required this.color,
  });

  static fromXml(XmlElement? element) {}
}

/// The group-name type describes the name or abbreviation of a part-group element.
///
/// Formatting attributes in the group-name type are deprecated in
///
/// Version 2.0 in favor of the new group-name-display and group-abbreviation-display elements.
class GroupName {
  String value;

  /// The print-style is deprecated in MusicXML 2.0 in favor of the new group-name-display and group-abbreviation-display elements.
  PrintStyle printStyle;

  /// The justify is deprecated in MusicXML 2.0 in favor of the new group-name-display and group-abbreviation-display elements.
  LeftCenterRight justify;

  GroupName({
    required this.value,
    required this.printStyle,
    required this.justify,
  });

  static fromXml(XmlElement? element) {}
}

/// The editorial group specifies editorial information for a musical element.
class Editorial {
  Footnote footnote;

  Level level;
  Editorial({
    required this.footnote,
    required this.level,
  });

  static fromXml(XmlElement? element) {}
}

/// The footnote element specifies editorial information that appears in footnotes in the printed score.
///
/// It is defined within a group due to its multiple uses within the MusicXML schema.
class Footnote {
  FormattedText value;
  Footnote({
    required this.value,
  });
}

/// The level element specifies editorial information for different MusicXML elements.
///
/// It is defined within a group due to its multiple uses within the MusicXML schema.
class Level {
  LevelType level;

  Level(this.level);
}

/// The level type is used to specify editorial information for different MusicXML elements.
///
/// The content contains identifying and/or descriptive text about the editorial status of the parent element.
///
/// If the reference attribute is yes, this indicates editorial information that is for display only and should not affect playback.
///
/// For instance, a modern edition of older music may set reference="yes" on the attributes containing the music's original clef, key, and time signature.
/// It is no if not specified.
///
/// The type attribute indicates whether the editorial information applies to the start of a series of symbols, the end of a series of symbols, or a single symbol.
///
/// It is single if not specified for compatibility with earlier MusicXML versions.
class LevelType {
  String value;
  bool reference;
  LevelDisplay diplay;

  LevelType({
    required this.value,
    required this.reference,
    required this.diplay,
  });
}

/// The level-display attribute group specifies three common ways to indicate editorial indications:
///
/// putting parentheses or square brackets around a symbol, or making the symbol a different size.
///
/// If not specified, they are left to application defaults.
///
/// It is used by the level and accidental elements.
class LevelDisplay {
  bool parentheses;
  bool bracket;
  SymbolSize size;

  LevelDisplay({
    required this.parentheses,
    required this.bracket,
    required this.size,
  });
}

/// The symbol-size type is used to distinguish between full, cue sized, grace cue sized, and oversized symbols.
enum SymbolSize {
  full,
  cue,
  graceCue,
  large;
}

/// The start-stop-single type is used for an attribute of musical elements
/// that can be used for either multi-note or single-note musical elements, as for groupings.
///
/// When multiple elements with the same tag are used within the same note,
/// their order within the MusicXML document should match the musical score order.
enum StartStopSingle {
  start,
  stop,
  single;
}

/// The start-stop type is used for an attribute of musical elements that can either start or stop, such as tuplets.
///
/// The values of start and stop refer to how an element appears in musical score order, not in MusicXML document order.
/// An element with a stop attribute may precede the corresponding element with a start attribute within a MusicXML document.
/// This is particularly common in multi-staff music.
/// For example, the stopping point for a tuplet may appear in staff 1 before the starting point for the tuplet appears in staff 2 later in the document.
///
/// When multiple elements with the same tag are used within the same note, their order within the MusicXML document should match the musical score order.
enum StartStop {
  start,
  stop;

  static fromString(String value) {
    throw UnimplementedError();
  }
}
