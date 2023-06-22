import 'package:music_notation/src/models/elements/music_data/music_data.dart';
import 'package:xml/xml.dart';

/// The bookmark type serves as a well-defined target for an incoming simple XLink.
class Bookmark implements MusicDataElement {
  /// The identifier for this bookmark, unique within this document.
  String id;

  /// The name for this bookmark.
  String? name;

  /// The position attribute specifies the position of the
  /// descendant element specified by the element attribute,
  /// where the first position is 1.
  /// The position attribute is ignored if the element attribute is not present.
  ///
  /// For instance, an element value of "beam" and a position value of "2"
  /// defines the <link> or <bookmark> to refer to the second beam descendant
  /// of the next sibling element that is not a <link> or <bookmark> element.
  /// This is equivalent to an XPath test of [.//beam[2]] done in the context of the sibling element.
  int? elementPosition;

  /// The element attribute specifies an element type for a descendant
  /// of the next sibling element that is not a <link> or <bookmark> element.
  ///
  /// When not present, the <bookmark> or <link> element
  /// refers to the next sibling element in the MusicXML file.
  String? element;

  Bookmark({
    required this.id,
    this.name,
    this.elementPosition,
    this.element,
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
