import 'package:collection/collection.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/elements/text/text.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

/// Represents a stem in MusicXML notation.
///
/// A stem is a graphical line extending from a notehead that
/// indicates the duration and rhythmic value of a note. The stem
/// direction can be down, up, none, or even double for specific notations.
///
/// The position attributes can be used to specify stem length.
/// The relative values specify the end of the stem relative to the program default.
/// Default values specify an absolute end stem position.
/// Negative values of relative-y that would flip a stem instead of shortening it are ignored.
///
/// In the case of a rest, a stem refers to a stemlet, a shortened stem.
///
/// For more details go to
/// [The \<stem\> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/stem/).
class Stem {
  /// Direction of stem. It can be 'down', 'up', 'none', or 'double'.
  StemValue value;

  /// The color of the stem. This can be used for visual highlights or
  /// analysis purposes.
  Color color;

  /// The position of the stem. This can be used to explicitly control the
  /// stem's vertical position.
  Position position;

  Stem({
    required this.value,
    this.color = const Color.empty(),
    this.position = const Position.empty(),
  });

  factory Stem.fromXml(XmlElement xmlElement) {
    validateTextContent(xmlElement);

    StemValue? value = StemValue.fromString(xmlElement.innerText);

    if (value == null) {
      throw MusicXmlTypeException(
        message: "${xmlElement.innerText} is not valid steam value",
        xmlElement: xmlElement,
      );
    }

    return Stem(
      value: value,
      color: Color.fromXml(xmlElement),
      position: Position.fromXml(xmlElement),
    );
  }
}

/// Enum representing the different possible stem values in MusicXML notation.

enum StemValue {
  /// The stem is drawn from the notehead downward.
  down,

  /// The stem is drawn from the notehead upward.
  up,

  /// The note has two stems - drawn upward and downward from the notehead.
  double,

  /// The note has no stem.
  none;

  /// Converts a string to its corresponding [StemValue].
  ///
  /// If the string does not represent a valid [StemValue], this method returns null.
  ///
  /// ```dart
  /// var stemValue = StemValue.fromString('up');
  /// print(stemValue);  // Outputs: StemValue.up
  /// ```
  static StemValue? fromString(String value) =>
      StemValue.values.firstWhereOrNull((e) => e.name == value);

  @override
  String toString() => name;
}
