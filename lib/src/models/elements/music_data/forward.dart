import 'package:music_notation/src/models/elements/editorial.dart';
import 'package:music_notation/src/models/elements/music_data/music_data.dart';
import 'package:xml/xml.dart';

/// The backup and forward elements are required to coordinate multiple voices in one part,
/// including music on multiple staves.
///
/// The forward element is generally used within voices and staves.
///
/// Duration values should always be positive,
/// and should not cross measure boundaries or mid-measure changes in the divisions value.
class Forward implements MusicDataElement {
  /// The duration element is defined within a group due to its uses within the note, figured-bass, backup, and forward elements.
  double duration;

  EditorialVoice editorialVoice;

  /// The staff element is defined within a group due to its use by both notes and direction elements.
  int staff;

  Forward({
    required this.duration,
    required this.staff,
    required this.editorialVoice,
  });

  factory Forward.fromXml(XmlElement xmlElement) {
    return Forward(
      duration: 1,
      staff: 1,
      editorialVoice: EditorialVoice.fromXml(xmlElement),
    );
  }

  @override
  XmlElement toXml() {
    // TODO: implement toXml
    throw UnimplementedError();
  }
}
