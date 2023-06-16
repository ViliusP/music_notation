import 'package:music_notation/src/models/data_types/group_symbol_value.dart';
import 'package:music_notation/src/models/data_types/start_stop.dart';
import 'package:music_notation/src/models/elements/editorial.dart';
import 'package:music_notation/src/models/elements/score/score_part.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/text.dart';

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
  final ScorePart scorePart;

  /// // This could be PartGroup or ScorePart;
  final List<PartListElement> additionalParts;

  PartList({
    this.partGroups = const [],
    required this.scorePart,
    this.additionalParts = const [],
  });

  factory PartList.fromXml(XmlElement xmlElement) {
    return PartList(scorePart: ScorePart.fromXml(xmlElement));
    // return PartList(
    //   partGroups: xmlElement
    //       .findElements('part-group')
    //       .map((e) => PartGroup.fromXml(e))
    //       .toList(),
    //   scorePart: xmlElement
    //       .findElements('score-part')
    //       .map((e) => ScorePart.fromXml(e))
    //       .toList(),
    //   additionalPartGroupOrScorePart:
    //       xmlElement.children.whereType<XmlElement>().map((e) {
    //     final element = e;
    //     switch (element.name.toString()) {
    //       case 'part-group':
    //         return PartGroup.fromXml(element);
    //       case 'score-part':
    //         return ScorePart.fromXml(element);
    //       default:
    //         throw ArgumentError(
    //             'Unsupported element ${element.name.toString()}');
    //     }
    //   }).toList(),
    // );
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

abstract class PartListElement {}

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
class PartGroup implements PartListElement {
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
    XmlElement? editorialElement = xmlElement.getElement('editorial');

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
      editorial: editorialElement != null
          ? Editorial.fromXml(editorialElement)
          : Editorial.empty(),
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
  HorizontalAlignment justify;

  GroupName({
    required this.value,
    required this.printStyle,
    required this.justify,
  });

  static fromXml(XmlElement? element) {}
}
