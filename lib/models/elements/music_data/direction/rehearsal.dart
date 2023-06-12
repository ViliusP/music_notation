import 'package:music_notation/models/elements/music_data/direction/direction_type.dart';
import 'package:music_notation/models/text.dart';
import 'package:xml/xml.dart';

/// The rehearsal element specifies letters, numbers, and section names that are notated in the score for reference during rehearsal.
///
/// The enclosure is square if not specified.
///
/// The language is Italian ("it") if not specified.
///
/// Left justification is used if not specified.
class Rehearsal extends FormattedTextId implements DirectionType {
  Rehearsal({
    required super.content,
    required super.textFormatting,
    required super.id,
  });

  factory Rehearsal.fromXml(XmlElement xmlElement) {
    return FormattedText.fromXml(xmlElement)
        as Rehearsal; // TODO test this "as Rehearsal"
  }
}
