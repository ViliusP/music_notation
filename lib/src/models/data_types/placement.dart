import 'package:collection/collection.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/common_attributes.dart';
import 'package:xml/xml.dart';

/// Indicates whether one element appears above or below another element.
///
/// The [Placement] enum allows specifying the vertical positioning of music elements.
/// For instance, this could be used to describe whether a dynamic marking should be placed
/// above or below the staff.
///
/// For more details go to
/// [above-below data type | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/above-below/).
enum Placement {
  /// Element appears above the reference element.
  above,

  /// Element appears below the reference element.
  below;

  /// Converts a [String] to its corresponding [Placement] enum.
  ///
  /// If the [value] does not match any [Placement] values, `null` is returned.
  ///
  /// Example:
  /// ```dart
  /// var placement = Placement.fromString("above");
  /// print(placement);  // Prints: Placement.above
  /// ```
  static Placement? fromString(String value) =>
      values.firstWhereOrNull((v) => v.name == value);

  /// Parses an [XmlElement] to extract a [Placement] value.
  ///
  /// The [attribute] parameter allows specifying the attribute name to extract.
  /// By default, it uses `placement`.
  ///
  /// If the attribute's value does not correspond to a valid [Placement] enum,
  /// it throws a [MusicXmlTypeException].
  ///
  /// Example:
  /// ```dart
  /// var xmlElement = XmlElement(XmlName("element"), [XmlAttribute(XmlName("placement"), "below")], []);
  /// var placement = Placement.fromXml(xmlElement);
  /// print(placement);  // Prints: Placement.below
  /// ```
  static Placement? fromXml(
    XmlElement xmlElement, [
    String attribute = CommonAttributes.placement,
  ]) {
    var placementAttribute = xmlElement.getAttribute(attribute);
    if (placementAttribute == null) {
      return null;
    }

    var placement = fromString(placementAttribute);
    if (placement == null) {
      throw MusicXmlTypeException(
        message:
            "$attribute attribute in ${xmlElement.name.local} is not valid placement value",
        xmlElement: xmlElement,
      );
    }
    return placement;
  }
}
