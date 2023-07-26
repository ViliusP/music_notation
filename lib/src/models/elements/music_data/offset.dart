import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

/// Represents the offset of a direction in terms of divisions.
/// It provides the information on where the direction will appear relative to
/// the current musical location, which is always within the current measure.
///
/// If an element within a direction includes a default-x attribute, the offset
/// value will be ignored when determining the appearance of that elementions
/// of the MusicXML for.
class Offset {
  /// The numeric value of the offset, represented in divisions.
  double value;

  /// Specifies whether the offset also affects the playback and listening of the direction.
  ///
  /// If this attribute is set to true, then the offset will influence both the
  /// visual appearance and the sound of the direction. If it is set to false,
  /// then any sound or listening associated with the direction takes effect
  /// at the current location. This attribute is set to false by default, for
  /// compatibility with earlier versions of MusicXML.
  bool sound;

  Offset({
    required this.value,
    this.sound = false,
  });

  /// Factory constructor that creates an instance of [Offset] from an [xmlElement].
  /// It validates the content of the provided XML element and throws a
  /// [MusicXmlFormatException] if the content is not a valid offset value.
  factory Offset.fromXml(XmlElement xmlElement) {
    validateTextContent(xmlElement);

    var offsetValue = double.tryParse(xmlElement.innerText);
    if (offsetValue == null) {
      throw MusicXmlFormatException(
        message: "'offset' content is not valid divisions",
        xmlElement: xmlElement,
        source: xmlElement.innerText,
      );
    }

    return Offset(
      value: offsetValue,
      sound: YesNo.fromXml(xmlElement, "sound") ?? false,
    );
  }
}
