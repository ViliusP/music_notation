import 'package:music_notation/src/models/data_types/placement.dart';
import 'package:music_notation/src/models/elements/editorial.dart';
import 'package:music_notation/src/models/elements/listening.dart';
import 'package:music_notation/src/models/elements/music_data/direction/segno.dart';
import 'package:music_notation/src/models/elements/sound/sound.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/data_types/system_relation.dart';
import 'package:music_notation/src/models/elements/music_data/music_data.dart';
import 'package:music_notation/src/models/elements/offset.dart';

/// A direction is a musical indication that is not necessarily attached to a specific note.
///
/// Two or more may be combined to indicate words followed by the start of a dashed line,
/// the end of a wedge followed by dynamics, etc.
///
/// For applications where a specific direction is indeed attached to a specific note,
/// the direction element can be associated with the first note element that
/// follows it in score order that is not in a different voice.
///
/// By default, a series of direction-type elements and a series of child elements
/// of a direction-type within a single direction element follow one another in sequence visually.
///
/// For a series of direction-type children, non-positional formatting attributes
/// are carried over from the previous element by default.
///
/// For more details go to
/// [The \<direction\> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/direction/).
class Direction implements MusicDataElement {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  List<DirectionType> types;

  Offset? offset;

  EditorialVoice editorialVoice;

  /// Staff assignment is only needed for music notated on multiple staves.
  ///
  /// Staff values are numbers, with 1 referring to the top-most staff in a part.
  int? staff;

  Sound? sound;

  Listening? listening;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Changes the default-x position of a direction.
  ///
  /// It indicates that the left-hand side of the direction is aligned
  /// with the left-hand side of the time signature.
  ///
  /// If no time signature is present,
  /// the direction is aligned with the left-hand side of the first music notational element in the measure.
  ///
  /// If a default-x, justify, or halign attribute is present, it overrides this attribute.
  bool? directive;

  /// Specifies an ID that is unique to the entire document.
  String? id;

  /// Indicates whether something is above or below another element, such as a note or a notation.
  Placement? placement;

  /// Distinguishes elements that are associated with a system rather than the particular part where the element appears.
  SystemRelation? system;

  Direction({
    // -- content --
    required this.types,
    this.offset,
    this.editorialVoice = const EditorialVoice.empty(),
    this.staff,
    this.sound,
    this.listening,
    // -- attributes --
    this.directive,
    this.id,
    this.placement,
    this.system,
  });

  static const Map<String, XmlQuantifier> _xmlExpectedOrder = {
    'direction-type': XmlQuantifier.optional,
    'offset': XmlQuantifier.optional,
    'footnote': XmlQuantifier.optional,
    'level': XmlQuantifier.optional,
    'voice': XmlQuantifier.optional,
    'staff': XmlQuantifier.optional,
    'sound': XmlQuantifier.optional,
    'listening': XmlQuantifier.optional,
  };

  factory Direction.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    var soundElement = xmlElement.getElement("sound");
    var offsetElement = xmlElement.getElement("offset");

    var staffElement = xmlElement.getElement("staff");
    validateTextContent(staffElement);
    var staff = int.tryParse(staffElement?.innerText ?? "");
    if (staffElement != null && (staff == null || staff < 1)) {
      throw MusicXmlFormatException(
        message: "'staff' content is not valid positive int",
        xmlElement: xmlElement,
        source: staffElement.innerText,
      );
    }

    return Direction(
      types: xmlElement
          .findElements('direction-tye')
          .map((e) => DirectionType.fromXml(e))
          .toList(),
      offset: offsetElement != null ? Offset.fromXml(offsetElement) : null,
      editorialVoice: EditorialVoice.fromXml(xmlElement),
      staff: staff,
      sound: soundElement != null ? Sound.fromXml(xmlElement) : null,
      listening: Listening.fromXml(xmlElement),
      directive: YesNo.fromXml(xmlElement, "directive"),
      id: xmlElement.getAttribute("id"),
      placement: Placement.fromXml(xmlElement),
      system: SystemRelation.fromXml(xmlElement),
    );
  }

  @override
  XmlElement toXml() {
    // TODO: implement toXml
    throw UnimplementedError();
  }
}

/// Textual direction types may have more than 1 component due to multiple fonts.
/// The dynamics element may also be used in the notations element.
///
/// Attribute groups related to print suggestions apply to the individual
/// direction-type, not to the overall direction.
abstract class DirectionType {
  factory DirectionType.fromXml(XmlElement e) {
    return Segno();
  }
}
