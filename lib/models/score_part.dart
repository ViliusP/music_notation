import 'package:music_notation/models/elements/link.dart';
import 'package:music_notation/models/midi.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/models/generic.dart';
import 'package:music_notation/models/identification.dart';
import 'package:music_notation/models/text.dart';

import 'instruments.dart';

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
  /// Required.
  String id;

  Identification? identification;

  List<PartLink>? partLinks;

  /// The part-name type describes the name or abbreviation of a score-part element.
  ///
  /// Formatting attributes for the part-name element are deprecated in Version 2.0 in favor of the new part-name-display and part-abbreviation-display elements.
  ///
  /// Important: it is just String and does not implement this part from XTS
  /// ```xml
  /// <xs:attributeGroup ref="part-name-text"/>
  /// ```
  String? partName;

  String? partAbbreviation;

  /// The name-display type is used for exact formatting of multi-font text
  /// in part and group names to the left of the system.
  /// The print-object attribute can be used to determine what,
  /// if anything, is printed at the start of each system.
  /// Enclosure for the display-text element is none by default.
  /// Language for the display-text element is Italian ("it") by default.
  ///
  /// Minimal occurence - 0.
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

  factory ScorePart.fromXml(XmlElement xmlElement) {
    Identification? identification;
    final partLinks = <PartLink>[];
    String? partName;
    NameDisplay? partNameDisplay;
    String? partAbbreviation;
    NameDisplay? partAbbreviationDisplay;
    final groups = <String>[];
    final scoreInstruments = <ScoreInstrument>[];
    final players = <Player>[];
    final midiDevices = <MidiDevice>[];
    final midiInstruments = <MidiInstrument>[];
    final id = xmlElement.getAttribute('id')!;

    for (var child in xmlElement.children.whereType<XmlElement>()) {
      switch (child.name.local) {
        case 'identification':
          identification = Identification.fromXml(child);
          break;
        case 'part-link':
          partLinks.add(PartLink.fromXml(child));
          break;
        case 'part-name':
          // partName = PartName.fromXml(child);
          partName = child.text;
          break;
        case 'part-name-display':
          partNameDisplay = NameDisplay.fromXml(child);
          break;
        case 'part-abbreviation':
          // partAbbreviation = PartName.fromXml(child);
          partAbbreviation = child.text;
          break;
        case 'part-abbreviation-display':
          partAbbreviationDisplay = NameDisplay.fromXml(child);
          break;
        case 'group':
          groups.add(child.text);
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

    return ScorePart(
      identification: identification,
      partLinks: partLinks,
      partName: partName!,
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
}

/// The part-link type allows MusicXML data for both score and parts to be contained within a single compressed MusicXML file.
/// It links a score-part from a score document to MusicXML documents that contain parts data.
/// In the case of a single compressed MusicXML file,
/// the link href values are paths that are relative to the root folder of the zip file.
class PartLink {
  LinkAttributes? linkAttributes;

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
    this.linkAttributes,
  });

  factory PartLink.fromXml(XmlElement xmlElement) {
    List<String>? instrumentLinks;
    var instrumentLinkElements = xmlElement.findElements('instrument-link');
    if (instrumentLinkElements.isNotEmpty) {
      instrumentLinks =
          instrumentLinkElements.map((element) => element.text).toList();
    }

    List<String>? groupLink;
    var groupLinkElements = xmlElement.findElements('group-link');
    if (groupLinkElements.isNotEmpty) {
      groupLink = groupLinkElements.map((element) => element.text).toList();
    }

    LinkAttributes linkAttributes = LinkAttributes.fromXml(xmlElement);

    return PartLink(
      instrumentLinks: instrumentLinks,
      groupLinks: groupLink,
      linkAttributes: linkAttributes,
    );
  }
}

/// The name-display type is used for exact formatting of multi-font text in part and group names to the left of the system.
///
/// The print-object attribute can be used to determine what, if anything, is printed at the start of each system.
///
/// Enclosure for the display-text element is none by default. Language for the display-text element is Italian ("it") by default.
class NameDisplay {
  List<FormattedText>? displayTexts;
  List<AccidentalText>? accidentalTexts;

  /// The print-object attribute specifies whether or not to print an object (e.g. a note or a rest).
  /// It is yes (true) by default.
  bool printObject;

  NameDisplay({
    required this.displayTexts,
    required this.accidentalTexts,
    this.printObject = true,
  });

  factory NameDisplay.fromXml(XmlElement xmlElement) {
    var displayTexts = <FormattedText>[];

    for (var element in xmlElement.findElements('display-text')) {
      displayTexts.add(FormattedText.fromXml(element));
    }

    var accidentalTexts = <AccidentalText>[];

    for (var element in xmlElement.findElements('accidental-text')) {
      accidentalTexts.add(AccidentalText.fromXml(element));
    }

    bool? printObject = YesNo.toBool(xmlElement.innerText);

    // Checks if provided value is "yes", "no" or nothing.
    // If it is something different, it throws error;
    if (xmlElement.innerText.isNotEmpty && printObject == null) {
      // TODO: correct attribute
      YesNo.generateValidationError(
        "xmlElement.innerText",
        xmlElement.innerText,
      );
    }

    return NameDisplay(
      displayTexts: displayTexts,
      accidentalTexts: accidentalTexts,
      printObject: printObject ?? true,
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
