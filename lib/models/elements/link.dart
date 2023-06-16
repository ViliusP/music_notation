import 'package:music_notation/models/elements/music_data/music_data.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/models/printing.dart';

/// The link type serves as an outgoing simple XLink.
///
/// If a relative link is used within a document that is part of a compressed MusicXML file,
/// the link is relative to the root folder of the zip file.
class Link implements MusicDataElement {
  LinkAttributes attributes;
  int? elementPosition;
  String? name;
  Position position;

  Link({
    required this.attributes,
    this.elementPosition,
    this.name,
    required this.position,
  });

  factory Link.fromXml(XmlElement xmlElement) {
    return Link(
      name: xmlElement.getAttribute('name'),
      position: Position.fromXml(xmlElement),
      attributes: LinkAttributes.fromXml(xmlElement),
      elementPosition: int.tryParse(xmlElement.getAttribute('element') ?? ''),
    );
  }

  XmlElement toXml() {
    var element = XmlElement(XmlName('link'));

    if (elementPosition != null) {
      element.attributes.add(
        XmlAttribute(XmlName('element'), elementPosition.toString()),
      );
    }
    // TODO

    return element;
  }
}

/// The link-attributes group includes all the simple XLink attributes supported in the MusicXML format.
///
/// It is also used to connect a MusicXML score with MusicXML parts or a MusicXML opus.
class LinkAttributes {
  final String href;
  final String type;
  final String? role;
  final String? title;
  final String show;
  final String actuate;

  LinkAttributes({
    required this.href,
    this.type = 'simple',
    this.role,
    this.title,
    this.show = 'replace',
    this.actuate = 'onRequest',
  });

  factory LinkAttributes.fromXml(XmlElement xmlElement) {
    return LinkAttributes(
      href: xmlElement.getAttribute('xlink:href')!,
      type: xmlElement.getAttribute('xlink:type') ?? 'simple',
      role: xmlElement.getAttribute('xlink:role'),
      title: xmlElement.getAttribute('xlink:title'),
      show: xmlElement.getAttribute('xlink:show') ?? 'replace',
      actuate: xmlElement.getAttribute('xlink:actuate') ?? 'onRequest',
    );
  }

  Map<String, String?> toXml() {
    return {
      'xlink:href': href,
      'xlink:type': type,
      'xlink:role': role,
      'xlink:title': title,
      'xlink:show': show,
      'xlink:actuate': actuate,
    };
  }
}
