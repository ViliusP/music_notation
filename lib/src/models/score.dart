import 'package:music_notation/src/models/elements/score/part.dart';
import 'package:music_notation/src/models/elements/score/score_header.dart';
import 'package:xml/xml.dart';

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

  factory ScorePartwise.fromXml(XmlDocument xmlDocument) {
    return ScorePartwise(
      scoreHeader: ScoreHeader.fromXml(xmlDocument.rootElement),
      parts: [],
    );
  }
}

/// The score-timewise element is the root element for a timewise MusicXML score.
/// It includes a score-header group followed by a series of measures with parts inside.
/// The document-attributes attribute group includes the version attribute.
class ScoreTimewise {
  final ScoreHeader scoreHeader;
  // final List<Part> parts; TODO

  final String version;

  ScoreTimewise({
    required this.scoreHeader,
    // required this.parts,
    this.version = "1.0",
  });
}