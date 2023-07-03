import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/common_attributes.dart';
import 'package:xml/xml.dart';

/// The [TypedText] type represents a text element with a type attribute.
class TypedText {
  final String value;
  final String? type;

  TypedText({
    required this.value,
    required this.type,
  });

  factory TypedText.fromXml(XmlElement xmlElement) {
    // Content parsing:
    if (xmlElement.childElements.isNotEmpty) {
      throw XmlElementContentException(
        message: "'typed-text' element should contain only text",
        xmlElement: xmlElement,
      );
    }

    return TypedText(
      value: xmlElement.innerText,
      type: xmlElement.getAttribute('type'),
    );
  }
}

class Empty {
  const Empty();
}

/// The element and position attributes are new as of Version 2.0.
/// They allow for bookmarks and links to be positioned at higher resolution
/// than the level of music-data elements.
///
/// When no element and position attributes are present,
/// the bookmark or link element refers to the next sibling element in the MusicXML file.
///
/// The element attribute specifies an element type for a descendant
/// of the next sibling element that is not a link or bookmark.
///
/// The position attribute specifies the position of this descendant element,
/// where the first position is 1.
///
/// The position attribute is ignored if the element attribute is not present.
///
/// For instance, an element value of "beam" and a position value of "2" defines
/// the link or bookmark to refer to the second beam descendant
/// of the next sibling element that is not a link or bookmark.
///
/// This is equivalent to an XPath test of [.//beam[2]] done in the context of the sibling element.<
class ElementPosition {
  String? element;

  int? position;

  ElementPosition({
    this.element,
    this.position,
  });

  factory ElementPosition.fromXml(XmlElement xmlElement) {
    return ElementPosition();
  }
}

/// The xml:space attribute in XML signals whether or not the parser
/// should remove or preserve white spaces.
enum XmlSpace {
  /// The value [vDefault] signals that the application's
  /// default white-space processing modes are acceptable for this element.
  ///
  /// In XML, it is 'default', but in Dart the 'default' keyword is reserved,
  /// so it has been changed to 'vDefault'.
  vDefault,

  /// The value [preserve] indicates the intent for applications to preserve all the white space.
  preserve;

  static const _mapping = {
    "default": vDefault,
    "preserve": preserve,
  };

  static XmlSpace? fromString(String value) {
    return _mapping[value];
  }

  static XmlSpace? fromXml(XmlElement xmlElement) {
    String? rawXmlSpace = xmlElement.getAttribute(CommonAttributes.xmlSpace);
    XmlSpace? xmlSpace = fromString(rawXmlSpace ?? "");
    if (rawXmlSpace != null && xmlSpace == null) {
      throw MusicXmlFormatException(
        message: generateValidationError(
          CommonAttributes.justify,
          rawXmlSpace,
        ),
        source: rawXmlSpace,
        xmlElement: xmlElement,
      );
    }
    return xmlSpace;
  }

  /// Generates a validation error message for an invalid [HorizontalAlignment] value.
  ///
  /// Parameters:
  ///   - attributeName: The name of the attribute.
  ///   - value: The value that caused the validation error.
  ///
  /// Returns a validation error message indicating that the attribute is not a valid yes-no value.
  static String generateValidationError(String attributeName, String value) =>
      "Attribute '$attributeName' is not a xml:space value: $value";
}
