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
    if (xmlElement.children.length != 1 ||
        xmlElement.children.first.nodeType != XmlNodeType.TEXT) {
      throw InvalidXmlElementException(
        message: "Group name element should contain only text",
        xmlElement: xmlElement,
      );
    }
    String content = xmlElement.children.first.value!;

    return TypedText(
      value: content,
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

/// Margins, page sizes, and distances are all measured in tenths to keep MusicXML data in a consistent coordinate system as much as possible.
///
/// The translation to absolute units is done with the scaling type, which specifies how many millimeters are equal to how many tenths.
///
/// For a staff height of 7 mm, millimeters would be set to 7 while tenths is set to 40.
///
/// The ability to set a formula rather than a single scaling factor helps avoid roundoff errors.
class Scaling {
  /// The millimeters type is a number representing millimeters.
  ///
  /// This is used in the scaling element to provide a default scaling from tenths to physical units.
  double millimeters;

  /// The tenths type is a number representing tenths of interline staff space (positive or negative).
  ///
  /// Both integer and decimal values are allowed, such as 5 for a half space and 2.5 for a quarter space.
  ///
  /// Interline space is measured from the middle of a staff line.
  ///
  /// Distances in a MusicXML file are measured in tenths of staff space.
  ///
  /// Tenths are then scaled to millimeters within the scaling element, used in the defaults element at the start of a score.
  ///
  /// Individual staves can apply a scaling factor to adjust staff size.
  /// When a MusicXML element or attribute refers to tenths,
  /// it means the global tenths defined by the scaling element,
  /// not the local tenths as adjusted by the staff-size element.
  double tenths;

  Scaling({
    required this.millimeters,
    required this.tenths,
  });

  factory Scaling.fromXml(XmlElement xmlElement) {
    return Scaling(
      millimeters: double.parse(
        xmlElement.getElement('millimeters')!.innerText,
      ),
      tenths: double.parse(
        xmlElement.getElement('tenths')!.innerText,
      ),
    );
  }

  XmlElement toXml() {
    var builder = XmlBuilder();
    builder.element('scaling', nest: () {
      builder.element('millimeters', nest: millimeters.toString());
      builder.element('tenths', nest: tenths.toString());
    });
    return builder.buildDocument().rootElement;
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
      throw InvalidMusicXmlType(
        message: generateValidationError(
          CommonAttributes.justify,
          rawXmlSpace,
        ),
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
