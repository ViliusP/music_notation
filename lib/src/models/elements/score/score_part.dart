// ignore_for_file: deprecated_member_use_from_same_package

import 'package:music_notation/src/models/utilities/common_attributes.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/elements/link.dart';
import 'package:music_notation/src/models/elements/score/name_display.dart';
import 'package:music_notation/src/models/elements/score/part_list.dart';
import 'package:music_notation/src/models/elements/text/text.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/elements/score/identification.dart';
import 'package:music_notation/src/models/instruments.dart';
import 'package:music_notation/src/models/midi.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';

/// The [ScorePart] type collects part-wide information for each part in a score.
///
/// Often, each MusicXML part corresponds to a track in a Standard MIDI Format 1 file.
///
/// In this case, the [MidiDevice] elements is used to make a MIDI device or port assignment
/// for the given track or specific [MidiInstrument].
///
/// Initial [midiInstruments] assignments may be made here as well.
///
/// The [scoreInstruments] are used when there are multiple instruments per track.
///
/// More information at [The \<score-part\> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/score-part/).
class ScorePart implements PartListElement {
  Identification? identification;

  List<PartLink> partLinks;

  /// The [partName] type describes the name or abbreviation of a score-part element.
  ///
  /// Formatting attributes for the part-name element are deprecated in Version 2.0 in favor of the new part-name-display and part-abbreviation-display elements.
  PartName partName;

  PartName? partAbbreviation;

  /// The name-display type is used for exact formatting of multi-font text
  /// in part and group names to the left of the system.
  /// The print-object attribute can be used to determine what,
  /// if anything, is printed at the start of each system.
  /// Enclosure for the display-text element is none by default.
  /// Language for the display-text element is Italian ("it") by default.
  NameDisplay? partNameDisplay;

  NameDisplay? partAbbreviationDisplay;

  /// The group element allows the use of different versions of the part for different purposes.
  /// Typical values include score, parts, sound, and data.
  /// Ordering information can be derived from the ordering within a MusicXML score or opus.
  List<String> groups;

  List<ScoreInstrument> scoreInstruments;

  List<Player> players;

  final List<MidiDevice> midiDevices;
  final List<MidiInstrument> midiInstruments;

  /// Required.
  String id;

  ScorePart({
    this.identification,
    this.partLinks = const [],
    required this.partName,
    this.partNameDisplay,
    this.partAbbreviation,
    this.partAbbreviationDisplay,
    this.groups = const [],
    this.scoreInstruments = const [],
    this.players = const [],
    this.midiDevices = const [],
    this.midiInstruments = const [],
    required this.id,
  });

  // Field(s): quantifier
  static const Map<dynamic, XmlQuantifier> _xmlExpectedOrder = {
    'identification': XmlQuantifier.optional,
    'part-link': XmlQuantifier.zeroOrMore,
    'part-name': XmlQuantifier.required,
    'part-name-display': XmlQuantifier.optional,
    'part-abbreviation': XmlQuantifier.optional,
    'part-abbreviation-display': XmlQuantifier.optional,
    'group': XmlQuantifier.zeroOrMore,
    'score-instrument': XmlQuantifier.zeroOrMore,
    'player': XmlQuantifier.zeroOrMore,
    {
      'midi-device': XmlQuantifier.optional,
      'midi-instrument': XmlQuantifier.optional,
    }: XmlQuantifier.zeroOrMore,
  };

  factory ScorePart.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    Identification? identification;
    final partLinks = <PartLink>[];
    PartName? partName;
    NameDisplay? partNameDisplay;
    PartName? partAbbreviation;
    NameDisplay? partAbbreviationDisplay;
    final groups = <String>[];
    final scoreInstruments = <ScoreInstrument>[];
    final players = <Player>[];
    final midiDevices = <MidiDevice>[];
    final midiInstruments = <MidiInstrument>[];

    for (var child in xmlElement.children.whereType<XmlElement>()) {
      switch (child.name.local) {
        case 'identification':
          identification = Identification.fromXml(child);
          break;
        case 'part-link':
          partLinks.add(PartLink.fromXml(child));
          break;
        case 'part-name':
          partName = PartName.fromXml(child);
          break;
        case 'part-name-display':
          partNameDisplay = NameDisplay.fromXml(child);
          break;
        case 'part-abbreviation':
          partAbbreviation = PartName.fromXml(child);
          break;
        case 'part-abbreviation-display':
          partAbbreviationDisplay = NameDisplay.fromXml(child);
          break;
        case 'group':
          var groupElement = child.firstElementChild;

          if (groupElement == null ||
              groupElement.nodeType != XmlNodeType.TEXT) {
            throw InvalidXmlElementException(
              message: 'Group must have text inside',
              xmlElement: xmlElement,
            );
          }
          groups.add(groupElement.value!);
          break;
        case 'score-instrument':
          scoreInstruments.add(ScoreInstrument.fromXml(child));
          break;
        case 'player':
          players.add(Player.fromXml(child));
          break;
        case 'midi-device':
          midiDevices.add(MidiDevice.fromXml(child));
          break;
        case 'midi-instrument':
          midiInstruments.add(MidiInstrument.fromXml(child));
          break;
      }
    }

    String? id = xmlElement.getAttribute("id");

    if (id == null || id.isEmpty) {
      throw XmlAttributeRequired(
        message: "'score-part' element must to have 'id' attribute",
        xmlElement: xmlElement,
      );
    }

    if (partName == null) {
      throw XmlElementRequired(
        "part-name is required in score-part element",
        xmlElement,
      );
    }

    return ScorePart(
      identification: identification,
      partLinks: partLinks,
      partName: partName,
      partNameDisplay: partNameDisplay,
      partAbbreviation: partAbbreviation,
      partAbbreviationDisplay: partAbbreviationDisplay,
      groups: groups,
      scoreInstruments: scoreInstruments,
      players: players,
      midiDevices: midiDevices,
      midiInstruments: midiInstruments,
      id: id,
    );
  }

  // TODO: implement and test.
  XmlElement toXml() {
    return XmlElement(XmlName("local"));
  }
}

/// The [PartLink] type allows MusicXML data for both score and parts to be contained within a single compressed MusicXML file.
/// It links a score-part from a score document to MusicXML documents that contain parts data.
/// In the case of a single compressed MusicXML file,
/// the link href values are paths that are relative to the root folder of the zip file.
class PartLink {
  /// All the simple XLink attributes supported in the MusicXML format
  LinkAttributes linkAttributes;

  /// Multiple part-link elements can link a condensed part
  /// within a score file to multiple MusicXML parts files.
  /// For example, a "Clarinet 1 and 2" part in a score file could link
  /// to separate "Clarinet 1" and "Clarinet 2" part files.
  ///
  /// The [instrumentLinks] type distinguish which of the score-instruments within a score-part are in which part file.
  ///
  /// The [instrumentLinks] id attribute refers to a [ScoreInstrument] id attribute.
  ///
  /// In XML schema it references to unique identifiers.
  List<String> instrumentLinks;

  /// Multiple elements can reference different types of linked documents,
  /// such as parts and condensed score.
  ///
  /// The optional [groupLinks] identify the groups used in the linked document.
  ///
  /// The content of a [groupLinks] element should match the content of a group element in the linked document.
  List<String> groupLinks;

  PartLink({
    this.instrumentLinks = const [],
    this.groupLinks = const [],
    required this.linkAttributes,
  });

  // Field(s): quantifier
  static const Map<dynamic, XmlQuantifier> _xmlExpectedOrder = {
    'instrument-link': XmlQuantifier.zeroOrMore,
    'group-link': XmlQuantifier.zeroOrMore,
  };

  factory PartLink.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    List<String> instrumentLinks = [];
    var instrumentLinkElements = xmlElement.findElements('instrument-link');
    if (instrumentLinkElements.isNotEmpty) {
      instrumentLinks.addAll(
        instrumentLinkElements.map((element) {
          String? id = element.getAttribute("id");
          if (id == null || id.isEmpty) {
            throw XmlAttributeRequired(
              message: "'instrument-link' must have ID",
              xmlElement: xmlElement,
            );
          }
          return id;
        }),
      );
    }

    List<String> groupLink = [];
    var groupLinkElements = xmlElement.findElements('group-link');
    if (groupLinkElements.isNotEmpty) {
      groupLink.addAll(
        groupLinkElements.map((element) {
          XmlNode? child = element.firstChild;

          if (child?.nodeType != XmlNodeType.TEXT ||
              child?.value?.isEmpty == true) {
            throw InvalidXmlElementException(
              message: "'group-link' content should be text",
              xmlElement: xmlElement,
            );
          }
          return child!.value!;
        }),
      );
    }

    return PartLink(
      instrumentLinks: instrumentLinks,
      groupLinks: groupLink,
      linkAttributes: LinkAttributes.fromXml(xmlElement),
    );
  }
}

/// The player type allows for multiple players per score-part for use in listening applications.
///
/// One player may play multiple instruments, while a single instrument may include multiple players in divisi sections.
class Player {
  /// Required.
  String id;

  /// The player-name element is typically used within a software application, rather than appearing on the printed page of a score.
  /// name=player-name
  String name;

  Player({
    required this.id,
    required this.name,
  });

  factory Player.fromXml(XmlElement xmlElement) {
    // TODO: not implemented
    throw UnimplementedError("TODO: not implemented");
  }
}

/// The part-name type describes the name or abbreviation of a score-part element.
///
/// Formatting attributes for the [PartName] element are deprecated in Version 2.0
/// in favor of the new [NameDisplay] elements.
@Deprecated("Deprecated in Version 2.0")
class PartName {
  String value;

  /// For definition see [PrintStyle].
  PrintStyle printStyle;

  /// Specifies whether or not to print an object.
  ///
  /// It is yes if not specified.
  bool printObject;

  /// Indicates left, center, or right justification.
  ///
  /// The default value varies for different elements.
  ///
  /// For elements where the justify attribute is present but the halign attribute is not,
  /// the justify attribute indicates horizontal alignment as well as justification.
  HorizontalAlignment? justify;

  PartName({
    required this.value,
    required this.printStyle,
    required this.printObject,
    this.justify,
  });

  factory PartName.fromXml(XmlElement xmlElement) {
    // Content parsing:
    if (xmlElement.children.length != 1 ||
        xmlElement.children.first.nodeType != XmlNodeType.TEXT) {
      throw InvalidXmlElementException(
        message: "Group name element should contain only text",
        xmlElement: xmlElement,
      );
    }
    String content = xmlElement.children.first.value!;

    return PartName(
      value: content,
      printStyle: PrintStyle.fromXml(xmlElement),
      printObject:
          YesNo.fromXml(xmlElement, CommonAttributes.printObject) ?? true,
      justify: HorizontalAlignment.fromXml(xmlElement),
    );
  }
}
