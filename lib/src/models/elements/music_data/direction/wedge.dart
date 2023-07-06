import 'package:music_notation/src/models/data_types/line.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/elements/text/text.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

/// Represents crescendo and diminuendo wedge symbols.
///
/// For more details go to
/// [The <wedge> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/wedge/).
class Wedge {
  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Enumerates the types of a [Wedge], defining its visual representation and
  /// musical meaning.
  ///
  /// Crescendo starts a wedge that is closed on the left side, diminuendo starts
  /// a wedge closed on the right side, and stop ends a wedge. `continue` denotes
  /// the continuation of a wedge, used especially for system breaks.
  WedgeType type;

  /// Specifies the color of the [Wedge].
  Color color;

  /// Defines the dashed formatting of the [Wedge] if any.
  DashedFormatting dashedFormatting;

  /// Defines the position of the [Wedge] on the stave.
  Position position;

  /// Specifies an ID that is unique to the entire document.
  String? id;

  /// Specifies if the line is solid, dashed, dotted, or wavy. Defaults to solid
  /// if not specified.
  LineType lineType;

  /// A value is yes indicates that a circle appears at the point of the wedge,
  /// indicating a crescendo from nothing or diminuendo to nothing.
  ///
  /// It is `false` if not specified and is used only when the type is crescendo,
  /// or the type is stop for a wedge that began with a diminuendo type.
  bool niente;

  /// Distinguishes multiple wedges when they overlap in MusicXML document order.
  int? number;

  /// Represents the gap between the top and bottom of the wedge, measured in tenths.
  /// Ignored if specified at the start of a crescendo wedge or the end of a
  /// diminuendo wedge.
  double? spread;

  Wedge({
    required this.type,
    this.color = const Color.empty(),
    this.dashedFormatting = const DashedFormatting.empty(),
    this.position = const Position.empty(),
    this.id,
    this.lineType = LineType.solid,
    this.niente = false,
    this.number,
    this.spread,
  });

  /// Parses the attributes of the provided XML element to construct a new
  /// [Wedge] object. If the 'type' attribute is not present, it throws a
  /// [MissingXmlAttribute] exception. Similarly, if the 'type' attribute is
  /// not a valid wedge-type or the 'spread' attribute is not a valid double, it
  /// throws a [MusicXmlFormatException]. If wedge's [xmlElement] is not empty,
  /// it throws a [XmlElementContentException].
  ///
  /// Example usage:
  /// ```dart
  /// var xmlElement = XmlDocument.parse("<wedge type='crescendo' spread='15'/>").root;
  /// var wedge = Wedge.fromXml(xmlElement);
  /// print(wedge.type);  // crescendo
  /// print(wedge.spread);  // 15.0
  /// ```
  factory Wedge.fromXml(XmlElement xmlElement) {
    validateEmptyContent(xmlElement);

    var wedgeAttribute = xmlElement.getAttribute("type");
    if (wedgeAttribute == null) {
      throw MissingXmlAttribute(
        message: "'type' attribute is required in 'wedge' element",
        xmlElement: xmlElement,
      );
    }

    var wedge = WedgeType.fromString(wedgeAttribute);
    if (wedge == null) {
      throw MusicXmlTypeException(
        message: "'type' attribute is not valid wedge-type",
        xmlElement: xmlElement,
      );
    }

    var niente = YesNo.fromXml(xmlElement, "niente");

    var spreadAttribute = xmlElement.getAttribute("spread");

    var spread = double.tryParse(spreadAttribute ?? "");
    if (spreadAttribute != null && spread == null) {
      throw MusicXmlFormatException(
        message: "'type' attribute is not valid tenths",
        xmlElement: xmlElement,
        source: spreadAttribute,
      );
    }

    return Wedge(
      type: wedge,
      color: Color.fromXml(xmlElement),
      dashedFormatting: DashedFormatting.fromXml(xmlElement),
      position: Position.fromXml(xmlElement),
      id: xmlElement.getAttribute("id"),
      niente: niente ?? false,
      number: NumberLevel.fromXml(xmlElement),
      spread: spread,
    );
  }
}

/// Specifies the types of [Wedge].
///
/// Each variant of [WedgeType] denotes a specific type of wedge in a musical
/// notation. This impacts both the visual representation and the musical
/// interpretation of the symbol. For instance, a crescendo [Wedge] is typically
/// drawn as an open wedge that widens to the right, signifying a gradual increase in volume.
enum WedgeType {
  /// The start of a crescendo wedge that is closed on the left side.
  crescendo,

  /// The start of a diminuendo wedge that is closed on the right side.
  diminuendo,

  /// The stop of a wedge.
  stop,

  /// The continuation of a wedge, often used to represent a wedge spanning multiple systems.
  tContinue;

  static const _map = {
    "crescendo": crescendo,
    "diminuendo": diminuendo,
    "stop": stop,
    "continue": tContinue,
  };

  /// Returns the [WedgeType] that corresponds to the provided string.
  ///
  /// Example usage:
  /// ```dart
  /// var wedgeType = WedgeType.fromString("crescendo");
  /// print(wedgeType);  // WedgeType.crescendo
  /// ```
  static WedgeType? fromString(String value) => _map[value];
}
