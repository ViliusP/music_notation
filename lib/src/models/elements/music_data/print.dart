import 'package:collection/collection.dart';
import 'package:music_notation/src/models/elements/layout.dart';
import 'package:music_notation/src/models/elements/score/name_display.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/utilities/case_transformers.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/elements/music_data/music_data.dart';

/// General printing parameters, including layout elements.
///
/// For more details go to
/// [The \<print\> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/print/).
class Print implements MusicDataElement {
  /// Layout only apply to the current page, system, or staff. Music that
  /// follows continues to take the default values from the layout determined
  /// by the defaults.
  Layout layout;

  /// The horizontal distance from the previous measure.
  /// This value is only used for systems where there is horizontal whitespace
  /// in the middle of a system, as in systems with codas.
  ///
  /// To specify the measure width, use the width attribute of the measure element.
  double? measureDistance;

  MeasureNumbering? measureNumbering;

  /// Changes how a part name is displayed over the course of a piece. It take
  /// effect when the current measure or a succeeding measure starts a new system.
  NameDisplay? partNameDisplay;

  /// Changes how a abbreviation is displayed over the course of a piece. It take
  /// effect when the current measure or a succeeding measure starts a new system.
  NameDisplay? partAbbreviationDisplay;

  PrintAttributes attributes;

  /// Specifies an ID that is unique to the entire document.
  String? id;

  Print({
    required this.layout,
    this.measureDistance,
    this.measureNumbering,
    this.partNameDisplay,
    this.partAbbreviationDisplay,
    required this.attributes,
    this.id,
  });

  // Field(s): quantifier
  static const Map<String, XmlQuantifier> _xmlExpectedOrder = {
    'page-layout': XmlQuantifier.optional,
    'system-layout': XmlQuantifier.optional,
    'staff-layout': XmlQuantifier.zeroOrMore,
    'measure-layout': XmlQuantifier.optional,
    'measure-numbering': XmlQuantifier.optional,
    'part-name-display': XmlQuantifier.optional,
    'part-abbreviation-display': XmlQuantifier.optional,
  };

  factory Print.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    var measureNumberingElement = xmlElement.getElement("measure-numbering");
    var partNameDisplayElement = xmlElement.getElement("part-name-display");

    var measureLayoutElement = xmlElement.getElement("measure-layout");
    var measureDistanceElement = measureLayoutElement?.getElement(
      "measure-distance",
    );
    validateTextContent(measureDistanceElement);

    var measureDistance = double.tryParse(
      measureDistanceElement?.innerText ?? "",
    );
    if (measureDistanceElement != null && measureDistance == null) {
      throw MusicXmlFormatException(
        message: "'measure-distance' content is not valid double value",
        xmlElement: xmlElement,
        source: measureDistanceElement.innerText,
      );
    }

    var partAbbreviationDisplayElement = xmlElement.getElement(
      "part-abbreviation-display",
    );

    return Print(
      layout: Layout.fromXml(xmlElement),
      measureDistance: measureDistance,
      measureNumbering: measureNumberingElement != null
          ? MeasureNumbering.fromXml(measureNumberingElement)
          : null,
      partNameDisplay: partNameDisplayElement != null
          ? NameDisplay.fromXml(partNameDisplayElement)
          : null,
      partAbbreviationDisplay: partAbbreviationDisplayElement != null
          ? NameDisplay.fromXml(partAbbreviationDisplayElement)
          : null,
      attributes: PrintAttributes.fromXml(xmlElement),
    );
  }

  @override
  XmlElement toXml() {
    // TODO: implement toXml
    throw UnimplementedError();
  }
}

/// Group that is used by the print element.
class PrintAttributes {
  /// Specifies spacing between multiple staves in tenths of staff space.
  ///
  /// Deprecated as of Version 1.1; the staff-layout element should be used instead.
  /// If both are present, the staff-layout values take priority.
  @Deprecated(
    "Deprecated as of Version 1.1; the staff-layout element should be used instead.",
  )
  double? staffSpacing;

  /// Indicates whether to force a system break,
  /// or to force the current music onto the same system as the preceding music.
  ///
  /// Normally this is the first music data within a measure. If used in
  /// multi-part music, the attributes should be placed in the same positions
  /// within each part, or the results are undefined.
  bool? newSystem;

  /// Indicates whether to force a page break,
  /// or to force the current music onto the same page as the preceding music.
  ///
  /// Normally this is the first music data within a measure.
  /// If used in multi-part music, the attributes should be placed in the same
  /// positions within each part, or the results are undefined.
  bool? newPage;

  /// The number of blank pages to insert before the current measure.
  ///
  /// It is ignored if [newPage] is not `true`(yes).
  ///
  /// These blank pages have no music, but may have text or images specified
  /// by the credit element. This is used to allow a combination of pages that
  /// are all text, or all text and images, together with pages of music.
  int? blankPage;

  /// Sets the number of a new page. It is ignored if [newPage] is not `true`(yes).
  int? pageNumber;

  PrintAttributes({
    this.staffSpacing,
    this.newSystem,
    this.newPage,
    this.blankPage,
    required this.pageNumber,
  });

  factory PrintAttributes.fromXml(XmlElement xmlElement) {
    var staffSpacingAttribute = xmlElement.getAttribute("staff-spacing");
    var staffSpacing = double.tryParse(
      staffSpacingAttribute ?? "",
    );
    if (staffSpacingAttribute != null && staffSpacing == null) {
      throw MusicXmlFormatException(
        message: "'staff-spacing' attribute is not valid double value",
        xmlElement: xmlElement,
        source: staffSpacingAttribute,
      );
    }

    var blankPageAttribute = xmlElement.getAttribute("blank-page");
    var blankPage = int.tryParse(blankPageAttribute ?? "");
    if (blankPageAttribute != null && (blankPage == null || blankPage < 1)) {
      throw MusicXmlFormatException(
        message: "'blank-page' attribute is not valid positive int value",
        xmlElement: xmlElement,
        source: staffSpacingAttribute,
      );
    }

    var pageNumberAttribute = xmlElement.getAttribute("page-number");
    var pageNumber = int.tryParse(blankPageAttribute ?? "");
    if (pageNumberAttribute != null && pageNumber == null) {
      throw MusicXmlFormatException(
        message: "'page-number' attribute is not valid int value",
        xmlElement: xmlElement,
        source: staffSpacingAttribute,
      );
    }

    return PrintAttributes(
      staffSpacing: staffSpacing,
      newSystem: YesNo.fromXml(xmlElement, "new-system"),
      newPage: YesNo.fromXml(xmlElement, "new-page"),
      blankPage: blankPage,
      pageNumber: pageNumber,
    );
  }
}

/// Describes how frequently measure numbers are displayed on this part.
///
/// The text attribute from the measure element is used for display,
/// or the number attribute if the text attribute is not present.
///
/// Measures with an implicit attribute set to true(yes) never display a measure number,
/// regardless of the [MeasureNumbering] setting.
///
/// For more details go to
/// [The \<measure-numbering\> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/measure-numbering/).
class MeasureNumbering {
  MeasureNumberingValue value;

  /// Specifies if measure numbers are associated with a system rather
  /// than the particular part where the [MeasureNumbering] element appears.
  SystemRelationNumber? system;

  /// Indicates staff numbers within a multi-staff part. Staves are numbered
  /// from top to bottom, with 1 being the top staff on a part. It indicates
  /// which staff is used as the reference point for vertical positioning.
  /// A value of 1 is assumed if not present.
  int staff;

  /// The [multipleRestAlways]  and [multipleRestRange] attributes describe
  /// how measure numbers are shown on multiple rests when the [value] is not set to none.
  ///
  /// The [multipleRestAlways] attribute is set to yes when the measure number
  /// should always be shown, even if the multiple rest starts midway
  /// through a system when measure numbering is set to system level.
  bool? multipleRestAlways;

  /// The [multipleRestAlways]  and [multipleRestRange] attributes describe
  /// how measure numbers are shown on multiple rests when the [value] is not set to none.
  ///
  /// The [multipleRestAlways] attribute is set to yes when measure numbers on
  /// multiple rests display the range of numbers for the first and last measure,
  /// rather than just the number of the first measure.
  bool? multipleRestRange;

  PrintStyleAlign printStyleAlign;

  MeasureNumbering({
    required this.value,
    this.system,
    this.staff = 1,
    this.multipleRestAlways,
    this.multipleRestRange,
    this.printStyleAlign = const PrintStyleAlign.empty(),
  });

  factory MeasureNumbering.fromXml(XmlElement xmlElement) {
    validateTextContent(xmlElement);

    var measureNumbering = MeasureNumberingValue.fromString(
      xmlElement.innerText,
    );

    if (measureNumbering == null) {
      throw MusicXmlTypeException(
        message: "Invalid measure numbering vlaue: ${xmlElement.innerText}",
        xmlElement: xmlElement,
      );
    }

    var staffAttribute = xmlElement.getAttribute("staff");
    var staff = int.tryParse(staffAttribute ?? "");
    if (staffAttribute != null && (staff == null || staff < 1)) {
      throw MusicXmlFormatException(
        message: "'staff' attribute is not valid positive int value",
        xmlElement: xmlElement,
        source: staffAttribute,
      );
    }

    var systemAttribute = xmlElement.getAttribute("system");
    var system = SystemRelationNumber.fromString(systemAttribute ?? "");
    if (systemAttribute != null && system == null) {
      throw MusicXmlTypeException(
        message: "'system' attribute is not valid system-relation-number value",
        xmlElement: xmlElement,
      );
    }

    return MeasureNumbering(
      value: measureNumbering,
      system: system,
      staff: staff ?? 1,
      multipleRestAlways: YesNo.fromXml(xmlElement, 'multiple-rest-always'),
      multipleRestRange: YesNo.fromXml(xmlElement, 'multiple-rest-range'),
      printStyleAlign: PrintStyleAlign.fromXml(xmlElement),
    );
  }
}

/// Describes how measure numbers are displayed on this part:
/// - no numbers;
/// - numbers every measure;
/// - numbers every system.
///
/// For more details go to
/// [measure-numbering-value | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/measure-numbering-value/).
enum MeasureNumberingValue {
  none,
  measure,
  system;

  static MeasureNumberingValue? fromString(String value) =>
      values.firstWhereOrNull((e) => e.name == value);
}

/// Distinguishes measure numbers that are associated with a system rather
/// than the particular part where the element appears.
///
/// For more details go to
/// [system-relation-number data type | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/system-relation-number/).
enum SystemRelationNumber {
  /// The number should appear only on the top part of the current system.
  onlyTop,

  /// The number should appear only on the bottom part of the current system.
  onlyBottom,

  /// The number should appear on both the current part and the top part of
  /// the current system. If these values appear in a score, when parts are
  /// created the number should only appear once in this part, not twice.
  alsoTop,

  /// The number should appear on both the current part and the bottom part of
  /// the current system. If these values appear in a score, when parts are
  /// created the number should only appear once in this part, not twice.
  alsoBottom,

  /// The number is associated only with the current part, not with the system.
  none;

  static SystemRelationNumber? fromString(String value) =>
      values.firstWhereOrNull((e) => e.name == hyphenToCamelCase(value));
}
