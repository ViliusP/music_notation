import 'package:music_notation/src/models/elements/editorial.dart';
import 'package:music_notation/src/models/elements/music_data/music_data.dart';
import 'package:xml/xml.dart';

/// Represents a forward movement in musical time without specifying the actual note
/// or rest content. This can denote the duration of music that isn't notated and can
/// be useful in specific musical contexts or applications.
///
/// For example, consider a MusicXML document depicting only a specific voice
/// or part from a larger score. If that voice has silent gaps, the [Forward]
/// class can be used to indicate the duration of those gaps, ensuring accurate timing
/// relative to the complete piece.
///
/// The [duration] value must always be positive and shouldn't exceed measure
/// boundaries or adjust with mid-measure changes in the divisions value.
class Forward implements MusicDataElement {
  /// Defines the duration, which is used within multiple musical elements such as
  /// notes, figured-bass, backup, and forward.
  final double duration;

  final EditorialVoice editorialVoice;

  /// Staff assignment is required only for music notated on multiple staves.
  /// Staff values are integers, where 1 refers to the top-most staff in a part.
  final int? staff;

  const Forward({
    required this.duration,
    this.staff,
    this.editorialVoice = const EditorialVoice.empty(),
  });

  /// Constructs a [Forward] instance from the given XML element.
  factory Forward.fromXml(XmlElement xmlElement) {
    return Forward(
      duration: 1, // TODO: Update with correct parsing logic from xmlElement
      staff: null, // TODO: Update with correct parsing logic from xmlElement
      editorialVoice: EditorialVoice.fromXml(xmlElement),
    );
  }

  @override
  XmlElement toXml() {
    // TODO: Implement the conversion to XML
    throw UnimplementedError();
  }
}
