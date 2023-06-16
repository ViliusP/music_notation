import 'package:music_notation/src/models/elements/music_data/note/note_type.dart';
import 'package:music_notation/src/models/invalid_xml_element_exception.dart';
import 'package:xml/xml.dart';

/// Time modification indicates tuplets, double-note tremolos, and other durational changes.
///
/// A <time-modification> element shows how the cumulative, sounding effect of tuplets and
/// double-note tremolos compare to the written note type represented by the <type> and <dot> elements.
///
/// Nested tuplets and other notations that use more detailed information need both the <time-modification> and <tuplet> elements to be represented accurately.
class TimeModification {
  /// The actual-notes element describes how many notes are played in the time usually occupied by the number in the normal-notes element.
  ///
  /// nonNegativeInteger data type.
  ///
  /// Required.
  int actualNotes;

  /// The normal-notes element describes how many notes are usually played in the time occupied by the number in the actual-notes element.
  ///
  /// nonNegativeInteger data type.
  ///
  /// Required.
  int normalNotes;

  /// If the type associated with the number in the normal-notes element is different than the current note type (e.g., a quarter note within an eighth note triplet),
  /// then the normal-notes type (e.g. eighth) is specified in the normal-type and normal-dot elements.
  NoteTypeValue? normalType;

  /// The normal-dot element is used to specify dotted normal tuplet types.
  ///
  /// This property cannot exists without [normalType].
  int? normalDots;

  TimeModification({
    required this.actualNotes,
    required this.normalNotes,
    this.normalType,
    this.normalDots,
  });

  factory TimeModification.fromXml(XmlElement xmlElement) {
    int? actualNotes = int.tryParse(
      xmlElement.getElement("actual-notes")?.innerText ?? "",
    );

    if (actualNotes == null) {
      throw XmlElementRequired("actual-notes value is missing");
    }

    int? normalNotes = int.tryParse(
      xmlElement.getElement("normal-notes")?.innerText ?? "",
    );

    if (normalNotes == null) {
      throw XmlElementRequired("normal-notes value is missing");
    }

    NoteTypeValue? maybeNormalType = NoteTypeValue.fromString(
      xmlElement.getElement("normal-type")?.innerText ?? "",
    );

    int? normalDots;

    if (maybeNormalType != null) {
      normalDots = _calculateDots(xmlElement);
    }

    return TimeModification(
      actualNotes: actualNotes,
      normalNotes: normalNotes,
      normalType: maybeNormalType,
      normalDots: normalDots,
    );
  }

  static int _calculateDots(XmlElement xmlElement) {
    final normalType = xmlElement.getElement("normal-type");
    var sibling = normalType?.nextElementSibling;
    var count = 0;
    while (sibling != null && sibling.name.local == 'normal-dot') {
      count++;
      sibling = sibling.nextElementSibling;
    }
    return count;
  }
}
