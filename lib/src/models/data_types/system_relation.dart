import 'package:collection/collection.dart';
import 'package:music_notation/src/models/utilities/case_transformers.dart';
import 'package:xml/xml.dart';

/// Distinguishes elements that are associated with a system rather than the
/// particular part where the element appears.
///
/// For more details go to
/// [system-relation data type | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/system-relation/).
enum SystemRelation {
  /// The element should appear only on the top part of the current system.
  onlyTop,

  /// The element should appear on both the current part and the top part of the
  /// current system. If this value appears in a score, when parts are created
  /// the element should only appear once in this part, not twice.
  alsoTop,

  /// The element is associated only with the current part, not with the system.
  none;

  static SystemRelation? fromString(String value) => values.firstWhereOrNull(
        (element) => element.name == hyphenToCamelCase(value),
      );

  /// TODO: implement and test
  static SystemRelation? fromXml(XmlElement xmlElement) {
    return null;
  }
}
