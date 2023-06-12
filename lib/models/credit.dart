// 	<xs:complexType name="credit">
// 		<xs:annotation>
// 			<xs:documentation>The credit type represents the appearance of the title, composer, arranger, lyricist, copyright, dedication, and other text, symbols, and graphics that commonly appear on the first page of a score. The credit-words, credit-symbol, and credit-image elements are similar to the words, symbol, and image elements for directions. However, since the credit is not part of a measure, the default-x and default-y attributes adjust the origin relative to the bottom left-hand corner of the page. The enclosure for credit-words and credit-symbol is none by default.

// By default, a series of credit-words and credit-symbol elements within a single credit element follow one another in sequence visually. Non-positional formatting attributes are carried over from the previous element by default.

// The page attribute for the credit element specifies the page number where the credit should appear. This is an integer value that starts with 1 for the first page. Its value is 1 by default. Since credits occur before the music, these page numbers do not refer to the page numbering specified by the print element's page-number attribute.

// The credit-type element indicates the purpose behind a credit. Multiple types of data may be combined in a single credit, so multiple elements may be used. Standard values include page number, title, subtitle, composer, arranger, lyricist, rights, and part name.
// </xs:documentation>
// 		</xs:annotation>
// 		<xs:sequence>
// 			<xs:element name="link" type="link" minOccurs="0" maxOccurs="unbounded"/>
// 			<xs:element name="bookmark" type="bookmark" minOccurs="0" maxOccurs="unbounded"/>
// 			<xs:choice>
// 				<xs:element name="credit-image" type="image"/>
// 				<xs:sequence>
// 					<xs:choice>
// 						<xs:element name="credit-words" type="formatted-text-id"/>
// 						<xs:element name="credit-symbol" type="formatted-symbol-id"/>
// 					</xs:choice>
// 					<xs:sequence minOccurs="0" maxOccurs="unbounded">
// 						<xs:element name="link" type="link" minOccurs="0" maxOccurs="unbounded"/>
// 						<xs:element name="bookmark" type="bookmark" minOccurs="0" maxOccurs="unbounded"/>
// 						<xs:choice>
// 							<xs:element name="credit-words" type="formatted-text-id"/>
// 							<xs:element name="credit-symbol" type="formatted-symbol-id"/>
// 						</xs:choice>
// 					</xs:sequence>
// 				</xs:sequence>
// 			</xs:choice>
// 		</xs:sequence>
// 		<xs:attribute name="page" type="xs:positiveInteger"/>
// 		<xs:attributeGroup ref="optional-unique-id"/>
// 	</xs:complexType>

import 'package:music_notation/models/elements/music_data/direction/image.dart';
import 'package:music_notation/models/text.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/models/printing.dart';
import 'package:music_notation/models/score_part.dart';

/// The credit type represents the appearance of the title, composer, arranger, lyricist, copyright, dedication, and other text, symbols, and graphics that commonly appear on the first page of a score.
///
/// The credit-words, credit-symbol, and credit-image elements are similar to the words, symbol, and image elements for directions.
///
/// However, since the credit is not part of a measure, the default-x and default-y attributes adjust the origin relative to the bottom left-hand corner of the page.
/// The enclosure for credit-words and credit-symbol is none by default.
///
/// By default, a series of credit-words and credit-symbol elements within a single credit element follow one another in sequence visually.
/// Non-positional formatting attributes are carried over from the previous element by default.
///
/// The page attribute for the credit element specifies the page number where the credit should appear.
///
/// This is an integer value that starts with 1 for the first page.
/// Its value is 1 by default. Since credits occur before the music,
/// these page numbers do not refer to the page numbering specified by the print element's page-number attribute.
///
/// The credit-type element indicates the purpose behind a credit.
/// Multiple types of data may be combined in a single credit, so multiple elements may be used.
///
/// Standard values include page number, title, subtitle, composer, arranger, lyricist, rights, and part name.
class Credit {
  final List<String> creditTypes;
  final List<Link> links;
  final List<Bookmark> bookmarks;
  final List<CreditContent> creditContents;

  // TODO:
  /// Positive integer
  final int page;

  /// Optional.
  final String? uniqueId;

  Credit({
    this.creditTypes = const [],
    this.links = const [],
    this.bookmarks = const [],
    this.creditContents = const [],
    required this.page,
    this.uniqueId,
  });

  factory Credit.fromXml(XmlElement xmlElement) {
    return Credit(
      creditTypes: xmlElement
          .findElements('credit-type')
          .map((element) => element.text)
          .toList(),
      links: xmlElement
          .findElements('link')
          .map((element) => Link.fromXml(element))
          .toList(),
      bookmarks: xmlElement
          .findElements('bookmark')
          .map((element) => Bookmark.fromXml(element))
          .toList(),
      creditContents: xmlElement.children
          .whereType<XmlElement>()
          .map((element) => CreditContent.fromXml(element))
          .toList(),
      page: int.parse(xmlElement.getAttribute('page') ?? '1'),
      uniqueId: xmlElement.getAttribute('optional-unique-id'),
    );
  }

  XmlElement toXml() {
    final xmlElement = XmlElement(XmlName('credit'));

    for (var type in creditTypes) {
      xmlElement.children
          .add(XmlElement(XmlName('credit-type'), [], [XmlText(type)]));
    }

    for (var link in links) {
      xmlElement.children.add(link.toXml());
    }

    for (var bookmark in bookmarks) {
      xmlElement.children.add(bookmark.toXml());
    }

    for (var content in creditContents) {
      xmlElement.children.add(content.toXml());
    }

    xmlElement.attributes.add(XmlAttribute(XmlName('page'), page.toString()));
    if (uniqueId != null) {
      xmlElement.attributes.add(XmlAttribute(
        XmlName('optional-unique-id'),
        uniqueId!,
      ));
    }

    return xmlElement;
  }
}

/// The link type serves as an outgoing simple XLink.
///
/// If a relative link is used within a document that is part of a compressed MusicXML file,
/// the link is relative to the root folder of the zip file.
class Link {
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

/// The bookmark type serves as a well-defined target for an incoming simple XLink.
class Bookmark {
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

class CreditContent {
  final Image? creditImage;
  final CreditSequence? creditSequence;

  CreditContent({
    this.creditImage,
    this.creditSequence,
  });

  factory CreditContent.fromXml(XmlElement xmlElement) {
    Image? creditImage;
    CreditSequence? creditSequence;

    if (xmlElement.name.local == 'credit-image') {
      creditImage = Image.fromXml(
        xmlElement,
      );
    } else {
      creditSequence = CreditSequence.fromXml(
        xmlElement,
      );
    }
    return CreditContent(
      creditImage: creditImage,
      creditSequence: creditSequence,
    );
  }

  XmlElement toXml() {
    if (creditImage != null) {
      return creditImage!
          .toXml(); // Assumes an existing Image class with a suitable toXml method.
    } else if (creditSequence != null) {
      return creditSequence!
          .toXml(); // Assumes an existing CreditSequence class with a suitable toXml method.
    } else {
      throw Exception(
          'Unexpected state for CreditContent'); // You may wish to handle this case differently.
    }
  }
}

class CreditSequence {
  final List<dynamic> sequence;

  CreditSequence({required this.sequence});

  factory CreditSequence.fromXml(XmlElement xmlElement) {
    var sequence = <dynamic>[];
    xmlElement.children.whereType<XmlElement>().forEach((childElement) {
      switch (childElement.name.local) {
        case 'link':
          sequence.add(Link.fromXml(
              childElement)); // Assuming Link has a suitable fromXml constructor
          break;
        case 'bookmark':
          sequence.add(Bookmark.fromXml(
              childElement)); // Assuming Bookmark has a suitable fromXml constructor
          break;
        case 'credit-words':
          sequence.add(FormattedTextId.fromXml(
              childElement)); // Assuming FormattedTextId has a suitable fromXml constructor
          break;
        case 'credit-symbol':
          sequence.add(FormattedSymbolId.fromXml(
              childElement)); // Assuming FormattedSymbolId has a suitable fromXml constructor
          break;
      }
    });
    return CreditSequence(sequence: sequence);
  }

  XmlElement toXml() {
    var sequenceElement = XmlElement(XmlName('sequence'));
    for (var item in sequence) {
      if (item is Link) {
        sequenceElement.children.add(item.toXml());
      } else if (item is Bookmark) {
        sequenceElement.children.add(item.toXml());
      } else if (item is FormattedTextId) {
        sequenceElement.children.add(item.toXml());
      } else if (item is FormattedSymbolId) {
        sequenceElement.children.add(item.toXml());
      } else {
        throw Exception('Unexpected item type in sequence');
      }
    }
    return sequenceElement;
  }
}

/// The image type is used to include graphical images in a score.
class Image {
  /// Optional.
  String? id;
  ImageAttributes attributes;

  Image({
    this.id,
    required this.attributes,
  });

  factory Image.fromXml(XmlElement xmlElement) {
    // TODO:
    return Image(
      attributes: ImageAttributes.fromXml(xmlElement),
    );
  }

  XmlElement toXml() {
    var element = XmlElement(XmlName('image-attributes'));
    // TODO: implement;
    return element;
  }
}

/// The image-attributes group is used to include graphical images in a score.
///
/// The required source attribute is the URL for the image file.
///
/// The required type attribute is the MIME type for the image file format.
///
/// Typical choices include application/postscript, image/gif, image/jpeg, image/png, and image/tiff.
///
/// The optional height and width attributes are used to size and scale an image.
///
/// The image should be scaled independently in X and Y if both height and width are specified.
///
/// If only one attribute is specified, the image should be scaled proportionally to fit in the specified dimension.
class ImageAttributes {
  String source;
  String type;
  double? height;
  double? width;
  Position position;
  HorizontalAlignment? horizontalAlignment;
  VerticalImageAlignment? verticalAlignment;

  ImageAttributes({
    required this.source,
    required this.type,
    this.height,
    this.width,
    required this.position,
    this.horizontalAlignment,
    this.verticalAlignment,
  });

  factory ImageAttributes.fromXml(XmlElement xmlElement) {
    return ImageAttributes(
      source: xmlElement.getAttribute('source')!,
      type: xmlElement.getAttribute('type')!,
      height: double.tryParse(xmlElement.getAttribute('height') ?? ''),
      width: double.tryParse(xmlElement.getAttribute('width') ?? ''),
      position: Position.fromXml(xmlElement),
      horizontalAlignment: HorizontalAlignment.fromString(
        xmlElement.getAttribute('halign') ?? "",
      ),
      verticalAlignment: VerticalImageAlignment.fromString(
        xmlElement.getAttribute('valign-image') ?? "",
      ),
    );
  }

  XmlElement toXml() {
    var element = XmlElement(XmlName('image-attributes'));

    element.attributes.add(XmlAttribute(XmlName('source'), source));
    element.attributes.add(XmlAttribute(XmlName('type'), type));

    if (height != null) {
      element.attributes.add(
        XmlAttribute(XmlName('height'), height.toString()),
      );
    }
    if (width != null) {
      element.attributes.add(
        XmlAttribute(XmlName('width'), width.toString()),
      );
    }
    // TODO position.toXml()
    if (horizontalAlignment != null) {
      element.attributes.add(
        XmlAttribute(XmlName('halign'), horizontalAlignment.toString()),
      ); // TODO check toString
    }
    if (verticalAlignment != null) {
      element.attributes.add(
        XmlAttribute(XmlName('valign-image'), verticalAlignment.toString()),
      ); // TODO check toString
    }

    return element;
  }
}
