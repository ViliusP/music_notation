import 'package:xml/xml.dart';

/// An offset is represented in terms of divisions,
/// and indicates where the direction will appear relative to the current musical location.
///
/// The current musical location is always within the current measure,
/// even at the end of a measure.
///
/// The offset affects the visual appearance of the direction.
/// If the sound attribute is "yes",
/// then the offset affects playback and listening too.
///
/// If the sound attribute is "no",
/// then any sound or listening associated with the direction takes effect at the current location.
///
/// The sound attribute is "no" by default for compatibility with earlier versmat.
///
/// If an element within a direction includes a default-x attribute,
///  the offset value will be ignored when determining the appearance of that elementions of the MusicXML for.
class Offset {
  double value;

  /// The offset affects the visual appearance of the direction.
  ///
  /// If the sound attribute is yes, then the offset affects playback and listening too.
  ///
  /// If it is no, then any <sound> or <listening> associated with the <direction> takes effect at the current location.
  ///
  /// It is no if not specified for compatibility with earlier MusicXML versions.
  bool sound;

  Offset({
    required this.value,
    this.sound = false,
  });

  // TODO: implement
  factory Offset.fromXml(XmlElement xmlElement) {
    return Offset(value: 0, sound: false);
  }
}
