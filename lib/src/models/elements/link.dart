import 'package:collection/collection.dart';
import 'package:music_notation/src/models/elements/music_data/music_data.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/printing.dart';

/// Serves as an outgoing simple XLink.
/// If a relative link is used within a document that is part of a compressed MusicXML file,
/// the link is relative to the root folder of the zip file.
///
/// More information at [The \<link\> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/link/)
class Link implements MusicDataElement {
  /// Group that includes all the simple XLink attributes supported in the MusicXML format.
  LinkAttributes attributes;

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

  /// The name of this link.
  String? name;

  /// For defintion, look at [Position].
  Position position;

  Link({
    required this.attributes,
    this.element,
    this.elementPosition,
    this.name,
    this.position = const Position.empty(),
  });

  factory Link.fromXml(XmlElement xmlElement) {
    String? rawElementPosition = xmlElement.getAttribute("position");

    int? elementPosition = int.tryParse(rawElementPosition ?? "");

    if (rawElementPosition != null &&
        (elementPosition == null || elementPosition < 1)) {
      throw InvalidMusicXmlType(
        message: "position in 'link' must be positive integer",
        xmlElement: xmlElement,
      );
    }

    return Link(
      attributes: LinkAttributes.fromXml(xmlElement),
      element: xmlElement.getAttribute('element'),
      elementPosition: elementPosition,
      name: xmlElement.getAttribute('name'),
      position: Position.fromXml(xmlElement),
    );
  }

  // TODO: implement and test
  XmlElement toXml() {
    var element = XmlElement(XmlName('link'));

    if (elementPosition != null) {
      element.attributes.add(
        XmlAttribute(XmlName('element'), elementPosition.toString()),
      );
    }
    // fixed attribute xmlns:xlink="http://www.w3.org/1999/xlink"
    return element;
  }
}

/// Includes all the simple XLink attributes supported in the MusicXML format.
///
/// It is also used to connect a MusicXML score with MusicXML parts or a MusicXML opus.
class LinkAttributes {
  /// The [href] attribute provides the data that allows an application
  /// to find a remote resource or resource fragment.
  ///
  /// See the definition in the [XML Linking Language recommendation](https://www.w3.org/TR/xlink11/#link-locators).
  final String href;

  /// Identifies XLink element types. In MusicXML, the value is always simple.
  ///
  /// See the definition in the [XML Linking Language recommendation](https://www.w3.org/TR/xlink11/#link-locators).
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
  /// The default value is [XLinkShow.replace].
  ///
  /// See the definition in the [XML Linking Language recommendation](https://www.w3.org/TR/xlink11/#link-behaviors).
  final XLinkShow? show;

  /// The actuate attribute is used to communicate the desired timing
  /// of traversal from the starting resource to the ending resource.
  ///
  /// The default value is [XLinkActuate.onRequest].
  ///
  /// See the definition in the [XML Linking Language recommendation](https://www.w3.org/TR/xlink11/#link-behaviors).
  final XLinkActuate? actuate;

  LinkAttributes({
    required this.href,
    this.type = 'simple',
    this.role,
    this.title,
    this.show = XLinkShow.replace,
    this.actuate = XLinkActuate.onRequest,
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

    String rawShow = xmlElement.getAttribute('xlink:show') ?? 'replace';
    XLinkShow? show = XLinkShow.parse(rawShow);

    if (show == null) {
      throw InvalidMusicXmlType(
        message: "'xlink:show' attribute is a wrong type",
        xmlElement: xmlElement,
      );
    }

    String rawActuate = xmlElement.getAttribute('xlink:actuate') ?? 'onRequest';
    XLinkActuate? actuate = XLinkActuate.parse(rawActuate);

    if (actuate == null) {
      throw InvalidMusicXmlType(
        message: "'xlink:actuate' attribute is a wrong type",
        xmlElement: xmlElement,
      );
    }

    return LinkAttributes(
      href: href,
      type: xmlElement.getAttribute('xlink:type') ?? 'simple',
      role: xmlElement.getAttribute('xlink:role'),
      title: xmlElement.getAttribute('xlink:title'),
      show: show,
      actuate: actuate,
    );
  }

  Map<String, String> toXml() {
    return {
      'xlink:href': href,
      // TODO
      // 'xlink:type': type,
      // 'xlink:role': role,
      // 'xlink:title': title,
      'xlink:show': show.toString(),
      'xlink:actuate': actuate.toString(),
    };
  }
}

/// See the definition in the [XML Linking Language recommendation](https://www.w3.org/TR/xlink11/#link-behaviors).
///
/// More information at [xlink:show data type | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/xlink-show/).
enum XLinkShow {
  /// An application traversing to the ending resource should load it in a new window,
  /// frame, pane, or other relevant presentation context.
  ///
  /// Officially this type is named 'new', but it is reserverd keyword in dart.
  new_,

  /// An application traversing to the ending resource should load the resource
  /// in the same window, frame, pane, or other relevant presentation
  /// context in which the starting resource was loaded. This is the default value.
  replace,

  /// An application traversing to the ending resource should load its presentation
  /// in place of the presentation of the starting resource.
  embed,

  /// The behavior of an application traversing to the ending resource
  /// is unconstrained by this specification.
  /// The application should lookfor other markup present in the link to
  /// determine the appropriate behavior
  other,

  /// The behavior of an application traversing to the ending resource is
  /// unconstrained by this specification.
  /// No other markup is present to help the application determine the appropriate behavior.
  none;

  static XLinkShow? parse(String value) {
    switch (value) {
      case 'new':
        return XLinkShow.new_;
      case 'replace':
        return XLinkShow.replace;
      case 'embed':
        return XLinkShow.embed;
      case 'other':
        return XLinkShow.other;
      case 'none':
        return XLinkShow.none;
      default:
        return null;
    }
  }

  static bool isValid(String value) {
    return XLinkShow.values.any(
      (element) => element.name == value,
    );
  }
}

/// See the definition in the [XML Linking Language recommendation](https://www.w3.org/TR/xlink11/#link-behaviors).
///
/// More information at [xlink:actuate data type | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/xlink-actuate/)
enum XLinkActuate {
  /// An application should traverse from the starting resource to the
  /// ending resource only on a post-loading event triggered for the purpose of traversal.
  ///
  /// This is the default value.
  onRequest,

  /// An application should traverse to the ending resource immediately on
  /// loading the starting resource.
  onLoad,

  /// The behavior of an application traversing to the ending resource is unconstrained
  /// by this specification. The application should look for
  /// other markup present in the link to determine the appropriate behavior.
  other,

  /// The behavior of an application traversing to the ending resource is unconstrained by this specification.
  /// No other markup is present to help the application determine the appropriate behavior.
  none;

  static XLinkActuate? parse(String value) {
    return XLinkActuate.values.firstWhereOrNull(
      (element) => element.name == value,
    );
  }

  static bool isValid(String value) {
    return XLinkActuate.values.any(
      (element) => element.name == value,
    );
  }
}
