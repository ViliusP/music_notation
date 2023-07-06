import 'package:music_notation/src/models/data_types/placement.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/elements/text/text.dart';

/// The print-style-align attribute group adds the halign and valign attributes to the position, font, and color attributes.
class PrintStyleAlign extends PrintStyle {
  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// In cases where text extends over more than one line, horizontal alignment and justify values can be different. The most typical case is for credits, such as:
  ///
  /// 	Words and music by
  /// 	  Pat Songwriter
  ///
  /// Typically this type of credit is aligned to the right, so that the position information refers to the right-most part of the text.
  /// But in this example, the text is center-justified, not right-justified.
  ///
  /// The halign attribute is used in these situations.
  /// If it is not present, its value is the same as for the justify attribute.
  ///
  /// For elements where a justify attribute is not allowed, the default is implementation-dependent.
  final HorizontalAlignment? horizontalAlignment;

  final VerticalAlignment? verticalAlignment;

  PrintStyleAlign({
    this.horizontalAlignment,
    this.verticalAlignment,
    required super.position,
    required super.font,
    required super.color,
  });

  const PrintStyleAlign.empty({
    super.position = const Position.empty(),
    super.color = const Color.empty(),
    super.font = const Font.empty(),
  })  : horizontalAlignment = null,
        verticalAlignment = null;

  factory PrintStyleAlign.fromXml(XmlElement xmlElement) {
    HorizontalAlignment? horizontalAlign;
    VerticalAlignment? verticalAlignment;

    var halign = xmlElement.getAttribute("halign");
    if (halign != null) {
      // TODO: throw if it is null;
      horizontalAlign = HorizontalAlignment.fromString(halign);
    }

    var valign = xmlElement.getAttribute("valign");
    if (valign != null) {
      // TODO: throw if it is null;
      verticalAlignment = VerticalAlignment.fromString(valign);
    }

    final PrintStyle printStyle = PrintStyle.fromXml(xmlElement);

    return PrintStyleAlign(
      position: printStyle.position,
      font: printStyle.font,
      color: printStyle.color,
      horizontalAlignment: horizontalAlign,
      verticalAlignment: verticalAlignment,
    );
  }
}

/// Attribute group that collects the most popular combination
/// of printing attributes: position, font, and color.
class PrintStyle {
  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  final Position position;
  final Font font;
  final Color color;

  const PrintStyle({
    required this.position,
    required this.font,
    required this.color,
  });

  factory PrintStyle.fromXml(XmlElement xmlElement) {
    return PrintStyle(
      position: Position.fromXml(xmlElement),
      font: Font.fromXml(xmlElement),
      color: Color.fromXml(xmlElement),
    );
  }

  const PrintStyle.empty()
      : position = const Position.empty(),
        font = const Font.empty(),
        color = const Color.empty();
}

/// Represents an empty element with print-style and placement attributes.
class EmptyPlacement extends PrintStyle {
  /// The placement attribute indicates whether something is above
  /// or below another element, such as a note or a notation.
  Placement? placement;

  EmptyPlacement({
    this.placement,
    required super.position,
    required super.font,
    required super.color,
  });
}

/// For most elements, any program will compute a default x and y position.
/// The position attributes let this be changed two ways. The [defaultX] and
/// [defaultY] change the computation of the default position. For most elements,
/// the origin is changed relative to the left-hand side of the note or the
/// musical position within the bar (x) and the top line of the staff (y).
///
/// For the following elements, the [defaultX] value changes the origin relative
/// to the start of the current measure:
/// - `note`;
/// - `figured bass`;
/// - `harmony`;
/// - `link`;
/// - `directive`;
/// - `measure numbering`;
/// - all descendants of the `part list` element;
/// - all children of the `direction` type element.
///
/// This origin is from the start of the entire measure, at either the left
/// barline or the start of the system.
///
/// When the [defaultX] attribute is used within a child element of the
/// `part name display`, `part abbreviation display`, `group name display`,
/// or `group abbreviation display`, it changes the origin relative to the start
/// of the first measure on the system.
///
/// These values are used when the current measure or a succeeding measure starts
/// a new system. The same change of origin is used for the group symbol element.
///
/// For the `note`, `figured bass`, and `harmony`, the [defaultX] value is considered
/// to have adjusted the musical position within the bar for its descendant elements.
///
/// Since the `credit words` and `credit image` are not related to a measure,
/// in these cases the [defaultX] and [defaultY] adjust the origin relative to
/// the bottom left-hand corner of the specified page.
///
/// The [relativeX] and [relativeY] change the position relative to the default
/// position, either as computed by the individual program, or as overridden by
/// the [defaultX] and [defaultY].
///
/// Positive x is right, negative x is left; positive y is up, negative y is down.
/// All units are in tenths of interline space. For stems, positive [relativeY]
/// lengthens a stem while negative [relativeY] shortens it.
///
/// The [defaultX] and [defaultY] position attributes provide higher-resolution
/// positioning data than related features such as the placement attribute and
/// the offset element.
///
/// Applications reading a MusicXML file that can understand both features should
/// generally rely on the [defaultX] and [defaultY] attributes for their greater
/// accuracy. For the [relativeX] and [relativeY] attributes, the offset element,
/// placement attribute, and directive attribute provide context for the relative
/// position information, so the two features should be interpreted together.
///
/// As elsewhere in the MusicXML format, tenths are the global tenths defined by
/// the scaling element, not the local tenths of a staff resized by the staff size element.
///
/// ### Tenths
///
/// Properties are tenths type and it is a number representing tenths of
/// interline staff space (positive or negative).
///
/// Both integer and decimal values are allowed, such as 5 for a half space and
/// 2.5 for a quarter space. Interline space is measured from the middle of a staff line.
/// Distances in a MusicXML file are measured in tenths of staff space.
///
/// Tenths are then scaled to millimeters within the scaling element, used in
/// the defaults element at the start of a score.
///
/// Individual staves can apply a scaling factor to adjust staff size.
///
/// When a MusicXML element or attribute refers to tenths, it means the global
/// tenths defined by the scaling element, not the local tenths as adjusted by
/// the staff-size element.
///
/// For more details go to
/// [tenths data type | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/tenths/).
class Position {
  final double? defaultX;
  final double? defaultY;
  final double? relativeX;
  final double? relativeY;

  const Position({
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
  });

  const Position.empty()
      : defaultX = null,
        defaultY = null,
        relativeX = null,
        relativeY = null;

  factory Position.fromXml(XmlElement xmlElement) {
    return Position(
      defaultX: _positionAttributeFromXml(xmlElement, 'default-x'),
      defaultY: _positionAttributeFromXml(xmlElement, 'default-y'),
      relativeX: _positionAttributeFromXml(xmlElement, 'relative-x'),
      relativeY: _positionAttributeFromXml(xmlElement, 'relative-y'),
    );
  }

  static double? _positionAttributeFromXml(
    XmlElement xmlElement,
    String attribute,
  ) {
    var positionElementAttribute = xmlElement.getAttribute(attribute);
    if (positionElementAttribute == null) {
      return null;
    }
    var positionElement = double.tryParse(positionElementAttribute);
    if (positionElement == null) {
      throw MusicXmlFormatException(
        message: "$attribute attribute value is not valid double",
        xmlElement: xmlElement,
        source: positionElementAttribute,
      );
    }
    return positionElement;
  }
}
