// ignore_for_file: deprecated_member_use_from_same_package

import 'package:collection/collection.dart';
import 'package:music_notation/src/models/data_types/group_symbol_value.dart';
import 'package:music_notation/src/models/data_types/start_stop.dart';
import 'package:music_notation/src/models/elements/editorial.dart';
import 'package:music_notation/src/models/elements/score/name_display.dart';
import 'package:music_notation/src/models/elements/score/part_list.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/generic.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/elements/text/text.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

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
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  GroupName? name;

  GroupName? nameAbbrevation;

  /// Formatting specified in the group-name-display element overrides formatting specified in the group-name element.
  NameDisplay? nameDisplay;

  /// Formatting specified in the group-abbreviation-display element overrides formatting specified in the group-abbreviation element.
  NameDisplay? nameDisplayAbbrevation;

  /// For defintion look at [GroupSymbol].
  GroupSymbol? groupSymbol;

  /// For defintion look at [GroupBarline].
  GroupBarline? groupBarline;

  /// The [groupTime] element indicates that the displayed time signatures
  /// should stretch across all parts and staves in the group.
  ///
  /// The [Empty] type represents an empty element with no attributes.
  Empty? groupTime;

  /// For defintion look at [Editorial].
  Editorial editorial;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Indicates the start or stop of the [PartGroup].
  StartStop type;

  /// Distinguishes overlapping and nested [PartGroup] elements, not a sequence
  /// of [PartGroup] elements.
  ///
  /// The default value is 1.
  String number;

  PartGroup({
    this.name,
    this.nameAbbrevation,
    this.nameDisplay,
    this.nameDisplayAbbrevation,
    this.groupSymbol = const GroupSymbol.none(),
    this.groupBarline,
    this.groupTime,
    required this.editorial,
    required this.type,
    this.number = "1",
  });

  // Field(s): quantifier
  static const Map<String, XmlQuantifier> _xmlExpectedOrder = {
    'group-name': XmlQuantifier.optional,
    'group-name-display': XmlQuantifier.optional,
    'group-abbreviation': XmlQuantifier.optional,
    'group-abbreviation-display': XmlQuantifier.optional,
    'group-symbol': XmlQuantifier.optional,
    'group-barline': XmlQuantifier.optional,
    'group-time': XmlQuantifier.optional,
    'footnote': XmlQuantifier.optional,
    'level': XmlQuantifier.optional,
  };

  factory PartGroup.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    // Content parsing:
    XmlElement? groupNameElement = xmlElement.getElement("group-name");

    XmlElement? nameDisplayElement = xmlElement.getElement(
      "group-name-display",
    );

    XmlElement? nameDisplayAbbrevationElement = xmlElement.getElement(
      'group-abbreviation-display',
    );

    XmlElement? groupSymbolElement = xmlElement.getElement(
      'group-symbol',
    );

    XmlElement? groupBarlineElement = xmlElement.getElement(
      'group-barline',
    );

    XmlElement? groupTimeElement = xmlElement.getElement('group-time');

    return PartGroup(
      name:
          groupNameElement != null ? GroupName.fromXml(groupNameElement) : null,
      nameDisplay: nameDisplayElement != null
          ? NameDisplay.fromXml(nameDisplayElement)
          : null,
      nameAbbrevation: nameDisplayAbbrevationElement != null
          ? GroupName.fromXml(nameDisplayAbbrevationElement)
          : null,
      groupSymbol: groupSymbolElement != null
          ? GroupSymbol.fromXml(groupSymbolElement)
          : const GroupSymbol.none(),
      groupBarline: groupBarlineElement != null
          ? GroupBarline.fromXml(groupBarlineElement)
          : null,
      groupTime: groupTimeElement != null ? const Empty() : null,
      editorial: Editorial.fromXml(xmlElement),
      type: StartStop.fromXml(xmlElement),
      number: xmlElement.getAttribute('number') ?? '1',
    );
  }

  // TODO: finish and test.
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
  final GroupSymbolValue value;

  /// For defintion, look at [Position].
  final Position position;

  /// Indicates the color of an element.
  final Color color;

  GroupSymbol({
    required this.value,
    required this.position,
    required this.color,
  });

  const GroupSymbol.none({
    this.value = GroupSymbolValue.none,
    this.position = const Position(),
    this.color = const Color.empty(),
  });

  factory GroupSymbol.fromXml(XmlElement xmlElement) {
    return GroupSymbol(
      value: GroupSymbolValue.fromXml(xmlElement),
      position: Position.fromXml(xmlElement),
      color: Color.fromXml(xmlElement),
    );
  }

  // TODO: finish and test.
  XmlElement toXml() {
    final builder = XmlBuilder();

    return builder.buildDocument().rootElement;
  }
}

/// The [GroupBarline] type indicates if the group should have common barlines.
class GroupBarline {
  GroupBarlineValue value;
  Color color;
  GroupBarline({
    required this.value,
    this.color = const Color.empty(),
  });

  factory GroupBarline.fromXml(XmlElement xmlElement) {
    return GroupBarline(
      value: GroupBarlineValue.fromXml(xmlElement),
      color: Color.fromXml(xmlElement),
    );
  }

  // TODO: finish and test.
  XmlElement toXml() {
    final builder = XmlBuilder();

    return builder.buildDocument().rootElement;
  }
}

/// The [GroupBarlineValue] type indicates if the [PartGroup] should have common barlines.
enum GroupBarlineValue {
  yes,
  no,
  mensurstrich;

  static GroupBarlineValue? fromString(String value) {
    return GroupBarlineValue.values.firstWhereOrNull(
      (e) => e.name == value.toLowerCase(),
    );
  }

  /// Takes content from element and converts it to [GroupBarlineValue].
  ///
  /// In musicXML, group-barline-value is content and always required.
  static GroupBarlineValue fromXml(XmlElement xmlElement) {
    if (xmlElement.children.length != 1 ||
        xmlElement.children.first.nodeType != XmlNodeType.TEXT) {
      throw InvalidXmlElementException(
        message:
            "${xmlElement.name} element should contain only one children - group-barline-value",
        xmlElement: xmlElement,
      );
    }

    String rawValue = xmlElement.children.first.value!;
    GroupBarlineValue? value = GroupBarlineValue.fromString(rawValue);
    if (value == null) {
      throw MusicXmlFormatException(
        message: generateValidationError(
          rawValue,
        ),
        xmlElement: xmlElement,
        source: rawValue,
      );
    }
    return value;
  }

  /// Generates a validation error message for an invalid [GroupBarlineValue] value.
  ///
  /// Parameters:
  ///   - value: The value that caused the validation error.
  ///
  /// Returns a validation error message indicating that the value is not a valid group-barline-value.
  static String generateValidationError(String value) =>
      "Content is not a group-barline-value: $value";
}

/// The group-name type describes the name or abbreviation of a part-group element.
///
/// Formatting attributes in the group-name type are deprecated in Version 2.0
/// in favor of the new group-name-display and group-abbreviation-display elements.
@Deprecated("deprecated in Version 2.0 in favor of the new GroupNameDisplay")
class GroupName {
  String value;

  /// The print-style is deprecated in MusicXML 2.0 in
  /// favor of the new group-name-display and group-abbreviation-display elements.
  PrintStyle printStyle;

  /// Indicates left, center, or right justification.
  /// The default value varies for different elements.
  /// For elements where the justify attribute is present
  /// but the halign attribute is not, the justify attribute indicates
  /// horizontal alignment as well as justification.
  ///
  /// The justify is deprecated in MusicXML 2.0
  /// in favor of the new group-name-display and group-abbreviation-display elements.
  HorizontalAlignment? justify;

  GroupName({
    required this.value,
    required this.printStyle,
    this.justify,
  });

  factory GroupName.fromXml(XmlElement xmlElement) {
    // Content parsing:
    if (xmlElement.childElements.isNotEmpty) {
      throw InvalidElementContentException(
        message: "Group name element should contain only text",
        xmlElement: xmlElement,
      );
    }

    return GroupName(
      value: xmlElement.innerText,
      printStyle: PrintStyle.fromXml(xmlElement),
      justify: HorizontalAlignment.fromXml(xmlElement),
    );
  }
}
