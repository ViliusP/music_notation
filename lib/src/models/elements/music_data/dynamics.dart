import 'package:collection/collection.dart';
import 'package:music_notation/src/models/data_types/placement.dart';
import 'package:music_notation/src/models/elements/music_data/direction/direction.dart';
import 'package:music_notation/src/models/elements/music_data/other_text.dart';
import 'package:music_notation/src/models/elements/text/text.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

/// Represents dynamics in musical notation.
///
/// Dynamics can be associated either with a note or a general musical direction.
/// They represent the volume or intensity of a sound or note. Dynamics in
/// MusicXML are represented with letter abbreviations (like 'sf' for sforzando,
/// 'pp' for pianissimo, etc.). To avoid inconsistencies, this class uses the actual
/// letters as the names of these dynamic elements.
///
/// There's a wide range of dynamics that can be represented. For ones that are not
/// covered by the standard dynamic elements, the [OtherDynamics] element can be used.
/// Dynamics elements can also be combined to represent marks not covered by a single
/// element, such as 'sfmp'.
///
/// It's important to note that these letter dynamic symbols are separate from
/// crescendo, decrescendo, and wedge indications. In many musical scores, dynamic
/// representation can be inconsistent and many elements are left to be assumed by the
/// performer. MusicXML captures what's present in the score, but doesn't provide
/// optimizations for dynamic analysis or synthesis.
///
/// The `placement` attribute is used when the dynamics are associated with a note.
/// It's ignored when the dynamics are associated with a general musical direction.
/// In that case, the direction element's `placement` attribute is used instead.
class Dynamics implements DirectionType {
  /// The dynamics values associated with this instance.
  final List<DynamicsValue> values;

  /// The print style and alignment settings for the dynamic marking.
  PrintStyleAlign printStyle;

  /// The placement of the dynamics relative to the note.
  Placement? placement;

  /// Any text decorations to apply to the dynamic marking.
  TextDecoration textDecoration;

  /// The enclosure shape for the dynamics.
  EnclosureShape? enclosure;

  /// The unique identifier for this dynamics instance.
  String? id;

  Dynamics({
    this.values = const [],
    this.printStyle = const PrintStyleAlign.empty(),
    this.placement,
    this.textDecoration = const TextDecoration.empty(),
    this.enclosure,
    this.id,
  });

  /// Specifies the expected order of XML elements.
  static const Map<String, XmlQuantifier> _xmlExpectedOrder = {
    "p|pp|ppp|pppp|ppppp|pppppp|f|ff|fff|ffff|fffff|ffffff|mp|mf|sf|sfp|sfpp|fp|rf|rfz|sfz|sffz|fz|n|pf|sfzp":
        XmlQuantifier.zeroOrMore,
  };

  /// Creates a new [Dynamics] instance from a [XmlElement].
  ///
  /// It reads the sequence of dynamic markings in the XML, and constructs
  /// the corresponding [DynamicsValue] instances. Also, it extracts any print
  /// styles, placements, text decorations, enclosures, and id attributes present.
  factory Dynamics.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);
    List<DynamicsValue> values = [];

    for (var childElement in xmlElement.childElements) {
      if (childElement.name.local == "other-dynamics") {
        values.add(OtherDynamics.fromXml(childElement));
      } else {
        validateEmptyContent(childElement);
        values.add(CommonDynamics.fromString(childElement.name.local)!);
      }
    }
    return Dynamics(
      values: values,
      printStyle: PrintStyleAlign.fromXml(xmlElement),
      placement: Placement.fromXml(xmlElement),
      textDecoration: TextDecoration.fromXml(xmlElement),
      enclosure: EnclosureShape.fromXml(xmlElement),
      id: xmlElement.getAttribute("id"),
    );
  }
}

/// A sealed class used as a base class for different dynamics values.
/// In musical notation, dynamics values represent the volume or intensity of a sound or note.
sealed class DynamicsValue {}

/// Represents the standard or common dynamics markings in musical notation.
/// These markings include various levels of loudness and softness (from pianissimo
/// to fortissimo), as well as more specific markings like sforzando and rinforzando.
///
/// Each dynamics value is represented with its corresponding musical abbreviation.
enum CommonDynamics implements DynamicsValue {
  /// A piano dynamic marking.
  p,

  /// A pianissimo dynamic marking.
  pp,

  /// A triple piano dynamic marking.
  ppp,

  /// A pppp dynamic marking.
  pppp,

  /// A ppppp dynamic marking.
  ppppp,

  /// A pppppp dynamic marking.
  pppppp,

  /// A forte dynamic marking.
  f,

  /// A fortissimo dynamic marking.
  ff,

  /// A triple forte dynamic marking
  fff,

  /// An ffff dynamic marking
  ffff,

  /// An fffff dynamic marking
  fffff,

  /// An ffffff dynamic marking
  ffffff,

  /// A mezzo piano dynamic marking
  mp,

  /// A mezzo forte dynamic marking
  mf,

  /// A sforzando sf dynamic marking
  sf,

  /// A sforzando piano sfp dynamic marking
  sfp,

  /// A sforzando pianissimo sfpp dynamic marking
  sfpp,

  /// A forte piano dynamic marking.
  fp,

  /// A rinforzando rf dynamic marking.
  rf,

  /// A rinforzando rfz dynamic marking.
  rfz,

  /// A sforzando sfz dynamic marking.
  sfz,

  /// A sforzando sffz dynamic marking.
  sffz,

  /// A forzando fz dynamic marking.
  fz,

  /// A niente dynamic marking.
  n,

  /// A piano forte dynamic marking.
  pf,

  /// A sforzando piano sfzp dynamic marking.
  sfzp;

  /// Converts a string value into the corresponding [CommonDynamics] enum value.
  static CommonDynamics? fromString(String value) {
    return values.firstWhereOrNull((element) => element.name == value);
  }
}

/// Represents dynamic marks that are not covered by the standard or common
/// dynamics values. In certain musical scores, composers might use non-standard
/// or less common dynamic markings to convey specific performance instructions.
/// This class allows these "other" dynamics to be represented.
class OtherDynamics extends OtherText implements DynamicsValue {
  OtherDynamics({
    required super.value,
    super.smufl,
  });

  /// Constructs a new [OtherDynamics] instance from a given [XmlElement].
  /// This functionality is currently not implemented.
  static DynamicsValue fromXml(XmlElement xmlElement) {
    throw UnimplementedError();
  }
}
