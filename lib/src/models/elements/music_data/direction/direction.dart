import 'package:music_notation/src/models/data_types/placement.dart';
import 'package:music_notation/src/models/elements/editorial.dart';
import 'package:music_notation/src/models/elements/image.dart';
import 'package:music_notation/src/models/elements/listening.dart';
import 'package:music_notation/src/models/elements/music_data/direction/accordion_registration.dart';
import 'package:music_notation/src/models/elements/music_data/direction/bracket.dart';
import 'package:music_notation/src/models/elements/music_data/direction/dashes.dart';
import 'package:music_notation/src/models/elements/music_data/direction/harp_pedals.dart';
import 'package:music_notation/src/models/elements/music_data/direction/metronome.dart';
import 'package:music_notation/src/models/elements/music_data/direction/octave_shift.dart';
import 'package:music_notation/src/models/elements/music_data/direction/other_direction.dart';
import 'package:music_notation/src/models/elements/music_data/direction/pedal.dart';
import 'package:music_notation/src/models/elements/music_data/direction/principal_voice.dart';
import 'package:music_notation/src/models/elements/music_data/direction/scordatura.dart';
import 'package:music_notation/src/models/elements/music_data/direction/staff_divide.dart';
import 'package:music_notation/src/models/elements/music_data/direction/wedge.dart';
import 'package:music_notation/src/models/elements/music_data/dynamics.dart';
import 'package:music_notation/src/models/elements/sound/sound.dart';
import 'package:music_notation/src/models/elements/text/text.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/data_types/system_relation.dart';
import 'package:music_notation/src/models/elements/music_data/music_data.dart';
import 'package:music_notation/src/models/elements/offset.dart';

/// Represents a direction in musical notation.
/// It holds the various musical indications that are not attached to a specific note
/// such as dynamic markings and phrase markings.
///
/// Two or more may be combined to indicate words followed by the start of a dashed line,
/// the end of a wedge followed by dynamics, etc.
///
/// For applications where a specific direction is indeed attached to a specific note,
/// the direction element can be associated with the first note element that
/// follows it in score order that is not in a different voice.
///
/// For more details go to
/// [The \<direction\> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/direction/).
class Direction implements MusicDataElement {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// A list of types of musical directions. These can be a variety of things
  /// such as dynamic markings (piano, forte, etc.), tempos (allegro, adagio),
  /// or other musical instructions (legato, staccato, etc.).
  List<DirectionType> types;

  /// An optional offset value which can adjust the position of the direction.
  Offset? offset;

  /// Contains information related to the editorial voice of the direction.
  /// This can be useful for indicating which voice or part the direction applies
  /// to in a multi-voice or multi-part score.
  EditorialVoice editorialVoice;

  /// Indicates which staff the direction applies to in a multi-staff part. This
  /// is only needed for music notated on multiple staves. By default, it refers
  /// to the top-most staff.
  int? staff;

  /// Contains information for general MIDI data for the direction.
  /// This can be used for playback purposes.
  Sound? sound;

  /// Contains information used for playback and analysis.
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

  // An ID that is unique within the document. This can be used for linking and referencing.
  String? id;

  /// Placement of the direction, specifying if it should be placed above or below other elements.
  Placement? placement;

  /// The relation of this direction with the overall system, whether it is
  /// associated with the system rather than the specific part where it appears.
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

  /// Map of XML elements and their expected order in the XML document.
  static const Map<String, XmlQuantifier> _xmlExpectedOrder = {
    'direction-type': XmlQuantifier.oneOrMore,
    'offset': XmlQuantifier.optional,
    'footnote': XmlQuantifier.optional,
    'level': XmlQuantifier.optional,
    'voice': XmlQuantifier.optional,
    'staff': XmlQuantifier.optional,
    'sound': XmlQuantifier.optional,
    'listening': XmlQuantifier.optional,
  };

  /// Factory constructor that creates an instance of [Direction] from an [xmlElement].
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

    var listeningElement = xmlElement.getElement("listening");

    return Direction(
      types: xmlElement
          .findElements('direction-type')
          .map((e) => DirectionType.fromXml(e))
          .toList(),
      offset: offsetElement != null ? Offset.fromXml(offsetElement) : null,
      editorialVoice: EditorialVoice.fromXml(xmlElement),
      staff: staff,
      sound: soundElement != null ? Sound.fromXml(xmlElement) : null,
      listening:
          listeningElement != null ? Listening.fromXml(xmlElement) : null,
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

/// A parent class representing a type of musical direction.
/// Various specific direction types will be subclasses of this class.
// TODO: make it sealed
abstract class DirectionType {
  factory DirectionType.fromXml(XmlElement xmlElement) {
    var directionTypes = xmlElement.childElements;
    var firstChild = directionTypes.firstOrNull;

    switch (directionTypes.firstOrNull?.name.local) {
      case "rehearsal":
        // return Rehearsal.fromXml(xmlElement);
        break;
      case "segno":
        // return Rehearsal.fromXml(xmlElement);
        break;
      case "coda":
        // return Rehearsal.fromXml(xmlElement);
        break;
      case "words":
        return DirectionWords(
            values: directionTypes
                .map(
                  (e) => FormattedTextId.fromXml(e),
                )
                .toList());
      case "symbol":
        return DirectionSymbols(
            values: directionTypes
                .map((e) => FormattedSymbolId.fromXml(e))
                .toList());
      case "wedge":
        return Wedge.fromXml(firstChild!);
      case "dynamics":
        return DirectionDynamics(
          values: directionTypes.map((e) => Dynamics.fromXml(e)).toList(),
        );
      case "dashes":
        return Dashes.fromXml(firstChild!);
      case "bracket":
        return Bracket.fromXml(firstChild!);
      case "pedal":
        return Pedal.fromXml(firstChild!);
      case "metronome":
        return Metronome.fromXml(firstChild!);
      case "octave-shift":
        return OctaveShift.fromXml(firstChild!);
      case "harp-pedals":
        return HarpPedals.fromXml(firstChild!);
      case "damp":
        // return Damp.fromXml(xmlElement);
        break;
      case "damp-all":
        // return Rehearsal.fromXml(xmlElement);
        break;
      case "eyeglasses":
        // return Rehearsal.fromXml(xmlElement);
        break;
      case "string-mute":
        // return Rehearsal.fromXml(xmlElement);
        break;
      case "scodatura":
        return Scordatura.fromXml(firstChild!);
      case "image":
        return Image.fromXml(firstChild!);
      case "principal-voice":
        return PrincipalVoice.fromXml(firstChild!);
      case "percussion":
        // return Percussion.fromXml(xmlElement);
        break;
      case "accordion-registration":
        return AccordionRegistration.fromXml(firstChild!);
      case "staff-divide":
        return StaffDivide.fromXml(firstChild!);
      case "other-direction":
        return OtherDirection.fromXml(firstChild!);
    }

    throw UnimplementedError();
  }
}

/// Represents specific symbol-based musical directions. These symbols are
/// used to convey certain musical ideas such as dynamics, articulations, or
/// tempo markings.
class DirectionSymbols implements DirectionType {
  final List<FormattedSymbolId> values;

  const DirectionSymbols({required this.values});
}

/// Represents text-based musical directions. These are typically used to convey
/// certain musical ideas such as dynamics (piano, forte), articulations
/// (staccato, legato), or tempos (adagio, allegro).
class DirectionWords implements DirectionType {
  final List<FormattedTextId> values;

  const DirectionWords({required this.values});
}

/// Represents dynamics (volume levels) in music. Dynamics are typically indicated
/// by specific markings like 'p' for piano (soft), 'f' for forte (loud), etc.
class DirectionDynamics implements DirectionType {
  final List<Dynamics> values;

  const DirectionDynamics({required this.values});
}
