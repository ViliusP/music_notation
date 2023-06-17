import 'package:music_notation/src/models/generic.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/elements/text/text.dart';

/// The print-style-align attribute group adds the halign and valign attributes to the position, font, and color attributes.
class PrintStyleAlign {
  PrintStyle? printStlye;

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
  HorizontalAlignment? horizontalAlignment;

  VerticalAlignment? verticalAlignment;

  PrintStyleAlign({
    required this.printStlye,
    required this.horizontalAlignment,
    required this.verticalAlignment,
  });

  PrintStyleAlign.empty();

  factory PrintStyleAlign.fromXml(XmlElement xmlElement) {
    HorizontalAlignment? horizontalAlign;
    VerticalAlignment? verticalAlignment;

    var halign = xmlElement.getAttribute("halign");
    if (halign != null) {
      horizontalAlign = HorizontalAlignment.fromString(halign);
    }

    var valign = xmlElement.getAttribute("valign");
    if (valign != null) {
      verticalAlignment = VerticalAlignment.fromString(valign);
    }

    // TODO: check
    return PrintStyleAlign(
      printStlye: PrintStyle.fromXml(xmlElement),
      horizontalAlignment: horizontalAlign,
      verticalAlignment: verticalAlignment,
    );
  }
}

/// The print-style attribute group collects the most popular combination
/// of printing attributes: position, font, and color.
class PrintStyle {
  Position? position;
  Font? font;
  Color? color;

  PrintStyle({
    this.position,
    this.font,
    this.color,
  });

  factory PrintStyle.fromXml(XmlElement xmlElement) {
    return PrintStyle(
      position: Position.fromXml(xmlElement),
      font: Font.fromXml(xmlElement),
      color: Color.fromXml(xmlElement),
    );
  }
}

/// For most elements, any program will compute a default x and y position. The position attributes let this be changed two ways.
///
/// The default-x and default-y attributes change the computation of the default position.
///
/// For most elements, the origin is changed relative to the left-hand side of the note or the musical position within the bar (x) and the top line of the staff (y).
///
/// For the following elements, the default-x value changes the origin relative to the start of the current measure:
/// 	- note
/// 	- figured-bass
/// 	- harmony
/// 	- link
/// 	- directive
/// 	- measure-numbering
/// 	- all descendants of the part-list element
/// 	- all children of the direction-type element
///
/// This origin is from the start of the entire measure, at either the left barline or the start of the system.
///
/// When the default-x attribute is used within a child element of the
/// part-name-display, part-abbreviation-display, group-name-display,
/// or group-abbreviation-display elements,
/// it changes the origin relative to the start of the first measure on the system.
///
/// These values are used when the current measure or a succeeding measure starts a new system.
/// The same change of origin is used for the group-symbol element.
///
/// For the note, figured-bass, and harmony elements,
/// the default-x value is considered to have adjusted the musical position within the bar for its descendant elements.
///
/// Since the credit-words and credit-image elements are not related to a measure,
/// in these cases the default-x and default-y attributes adjust the origin relative to the bottom left-hand corner of the specified page.
///
/// The relative-x and relative-y attributes change the position relative to the default position, either as computed by the individual program, or as overridden by the default-x and default-y attributes.
///
/// Positive x is right, negative x is left; positive y is up, negative y is down. All units are in tenths of interline space. For stems, positive relative-y lengthens a stem while negative relative-y shortens it.
///
/// The default-x and default-y position attributes provide higher-resolution positioning data than related features such as the placement attribute and the offset element.
///
/// Applications reading a MusicXML file that can understand both features should generally rely on the default-x and default-y attributes for their greater accuracy.
/// For the relative-x and relative-y attributes, the offset element, placement attribute, and directive attribute provide context for the relative position information, so the two features should be interpreted together.
///
/// As elsewhere in the MusicXML format, tenths are the global tenths defined by the scaling element, not the local tenths of a staff resized by the staff-size element.
///
/// ### Tenths
///
/// Properties are tenths type and it is a number representing tenths of interline staff space (positive or negative).
///
/// Both integer and decimal values are allowed, such as 5 for a half space and 2.5 for a quarter space. Interline space is measured from the middle of a staff line.
/// Distances in a MusicXML file are measured in tenths of staff space.
///
/// Tenths are then scaled to millimeters within the scaling element, used in the defaults element at the start of a score.
///
/// Individual staves can apply a scaling factor to adjust staff size.
///
/// When a MusicXML element or attribute refers to tenths, it means the global tenths defined by the scaling element, not the local tenths as adjusted by the staff-size element.</xs:documentation>
class Position {
  double? defaultX;
  double? defaultY;
  double? relativeX;
  double? relativeY;

  Position({
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
  });

  factory Position.fromXml(XmlElement xmlElement) {
    return Position(
      defaultX: double.tryParse(xmlElement.getAttribute('default-x') ?? ''),
      defaultY: double.tryParse(xmlElement.getAttribute('default-y') ?? ''),
      relativeX: double.tryParse(xmlElement.getAttribute('relative-x') ?? ''),
      relativeY: double.tryParse(xmlElement.getAttribute('relative-y') ?? ''),
    );
  }
}

/// The empty-print-style-align-object type represents an empty element with print-object and print-style-align attribute groups.
class EmptyPrintObjectStyleAlign {
  /// The print-object attribute specifies whether or not to print an object (e.g. a note or a rest).
  /// It is yes (true) by default.
  bool printObject;
  PrintStyleAlign? printStyleAlign;

  EmptyPrintObjectStyleAlign({
    required this.printStyleAlign,
    this.printObject = true,
  });

  factory EmptyPrintObjectStyleAlign.fromXml(XmlElement xmlElement) {
    bool? printObject = YesNo.toBool(xmlElement.innerText);

    // Checks if provided value is "yes", "no" or nothing.
    // If it is something different, it throws error;
    if (xmlElement.innerText.isNotEmpty && printObject == null) {
      // TODO: correct attribute
      YesNo.generateValidationError(
        "xmlElement.innerText",
        xmlElement.innerText,
      );
    }

    return EmptyPrintObjectStyleAlign(
      printStyleAlign: null, // TODO
      printObject: printObject ?? true,
    );
  }

  XmlElement toXml() {
    var builder = XmlBuilder();
    builder.element('empty-print-object-style-align');
    return builder.buildDocument().rootElement;
  }
}
