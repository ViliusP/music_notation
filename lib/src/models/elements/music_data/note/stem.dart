import 'package:collection/collection.dart';
import 'package:music_notation/src/models/invalid_xml_element_exception.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/text.dart';
import 'package:xml/xml.dart';

/// Stems can be down, up, none, or double.
///
/// For down and up stems, the position attributes can be used to specify stem length.
///
/// The relative values specify the end of the stem relative to the program default.
///
/// Default values specify an absolute end stem position.
///
/// Negative values of relative-y that would flip a stem instead of shortening it are ignored.
///
/// A stem element associated with a rest refers to a stemlet.
class Stem {
  StemValue value;
  Color color;
  Position position;

  Stem({
    required this.value,
    required this.color,
    required this.position,
  });

  factory Stem.fromXml(XmlElement xmlElement) {
    StemValue? value = StemValue.fromString(xmlElement.innerText ?? "");

    if (value == null) {
      throw XmlElementRequired("Steam value is missing");
    }

    return Stem(
      value: value,
      color: Color.fromXml(xmlElement),
      position: Position.fromXml(xmlElement),
    );
  }
/*  */
}

/// The stem-value type represents the notated stem direction.
enum StemValue {
  down,
  up,
  double,
  none;

  /// Converts provided string value to [StemValue].
  ///
  /// Returns null if that name does not exists.
  static StemValue? fromString(String value) {
    return StemValue.values.firstWhereOrNull(
      (e) => e.name == value,
    );
  }

  @override
  String toString() => name;
}
