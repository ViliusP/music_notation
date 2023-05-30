import 'package:music_notation/models/score.dart';

/// The score-partwise element is the root element for a partwise MusicXML score.
/// It includes a score-header group followed by a series of parts with measures inside.
/// The document-attributes attribute group includes the version attribute.
class ScorePartwise {
  String? version;
  PartList? partList;
  Part? part;

  ScorePartwise({
    this.version,
    this.partList,
    this.part,
  });
}
