import 'package:music_notation/models/part.dart';
import 'package:music_notation/models/score_header.dart';

/// The score-partwise element is the root element for a partwise MusicXML score.
/// It includes a score-header group followed by a series of parts with measures inside.
/// The document-attributes attribute group includes the version attribute.
class ScorePartwise {
  final ScoreHeader scoreHeader;
  final List<Part> parts;

  final String version;

  ScorePartwise({
    required this.scoreHeader,
    required this.parts,
    this.version = "1.0",
  });
}
