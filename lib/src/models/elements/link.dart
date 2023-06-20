import 'package:music_notation/src/models/elements/music_data/music_data.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/printing.dart';

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

/// The [LinkAttributes] group includes all the simple XLink attributes supported in the MusicXML format.
///
/// It is also used to connect a MusicXML score with MusicXML parts or a MusicXML opus.
class LinkAttributes {
  /// The [href] attribute provides the data that allows an application
  /// to find a remote resource or resource fragment.
  ///
  /// See the definition in the [XML Linking Language recommendation](https://www.w3.org/TR/xlink11/#link-locators).
  final String href;

  final String? type;

  /// The [role] attribute indicates a property of the link.
  ///
  /// See the definition in the [XML Linking Language recommendation](https://www.w3.org/TR/xlink11/#link-semantics).
  final String? role;

  /// The title attribute describes the meaning of a link
  /// or resource in a human-readable fashion.
  ///
  /// See the definition in the [XML Linking Language recommendation](https://www.w3.org/TR/xlink11/#link-semantics).
  final String? title;

  /// The [show] attribute is used to communicate the desired presentation
  /// of the ending resource on traversal from the starting resource.
  ///
  /// The default value is replace.
  ///
  /// See the definition in the [XML Linking Language recommendation](https://www.w3.org/TR/xlink11/#link-behaviors).
  final String? show;

  /// The actuate attribute is used to communicate the desired timing
  /// of traversal from the starting resource to the ending resource.
  ///
  /// The default value is onRequest.
  ///
  /// See the definition in the [XML Linking Language recommendation](https://www.w3.org/TR/xlink11/#link-behaviors).
  final String? actuate;

  LinkAttributes({
    required this.href,
    this.type = 'simple',
    this.role,
    this.title,
    this.show = 'replace',
    this.actuate = 'onRequest',
  });

  factory LinkAttributes.fromXml(XmlElement xmlElement) {
    String? href = xmlElement.getAttribute('xlink:href');

    if (href == null || href.isEmpty) {
      throw XmlAttributeRequired(
        message: "xlink:href is required for xml for ${xmlElement.name.local}",
        xmlElement: xmlElement,
      );
    }

    if (!MusicXMLAnyURI.isValid(href)) {
      throw InvalidMusicXmlType(
        message: "xlink:href is not type of anyURI",
        xmlElement: xmlElement,
      );
    }

    return LinkAttributes(
      href: href,
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
