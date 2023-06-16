import 'package:music_notation/models/elements/music_data/music_data.dart';
import 'package:xml/xml.dart';

/// The bookmark type serves as a well-defined target for an incoming simple XLink.
class Bookmark implements MusicDataElement {
  String id;
  int? elementPosition;
  String? elementName;

  Bookmark({
    required this.id,
    this.elementPosition,
    this.elementName,
  });

  factory Bookmark.fromXml(XmlElement xmlElement) {
    // TODO
    return Bookmark(id: "");
  }

  XmlElement toXml() {
    var element = XmlElement(XmlName('bookmark'));

    return element;
  }
}
