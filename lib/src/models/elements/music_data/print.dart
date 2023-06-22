import 'package:music_notation/src/models/elements/score/name_display.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/data_types/system_relation.dart';
import 'package:music_notation/src/models/elements/score/defaults.dart';
import 'package:music_notation/src/models/elements/music_data/music_data.dart';

/// Contains general printing parameters, including layout elements.
///
/// The part-name-display and part-abbreviation-display elements
/// may also be used here to change how a part name or abbreviation is displayed over the course of a piece.
///
/// They take effect when the current measure or a succeeding measure starts a new system.
///
/// Layout group elements in a print element only apply to the current page, system, or staff.
///
/// Music that follows continues to take the default values from the layout determined by the defaults element.
class Print implements MusicDataElement {
  Layout layout;

  /// The measure-distance element specifies the horizontal distance from the previous measure.
  ///
  /// This value is only used for systems where there is horizontal whitespace
  /// in the middle of a system, as in systems with codas.
  ///
  /// To specify the measure width, use the width attribute of the measure element.
  double? measureDistance;

  MeasureNumbering? measureNumbering;

  NameDisplay? partNameDisplay;

  NameDisplay? partAbbreviationDisplay;

  PrintAttributes attributes;

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

  factory Print.fromXml(XmlElement xmlElement) {
    return Print(
      layout: Layout.fromXml(xmlElement),
      measureDistance: double.tryParse(
        xmlElement.getAttribute("measure-distance") ?? "",
      ),
      measureNumbering: MeasureNumbering.fromXml(xmlElement),
      attributes: PrintAttributes.fromXml(xmlElement),
    );
  }
}

/// Group that is used by the print element.
///
/// The new-system and new-page attributes indicate whether to force a system or page break,
/// or to force the current music onto the same system or page as the preceding music.
///
/// Normally this is the first music data within a measure.
/// If used in multi-part music, they should be placed in the same positions within each part,
/// or the results are undefined.
///
/// The page-number attribute sets the number of a new page;
/// it is ignored if new-page is not "yes". Version 2.0 adds a blank-page attribute.
/// This is a positive integer value that specifies the number of blank pages to insert before the current measure.
///
/// It is ignored if new-page is not "yes". These blank pages have no music,
/// but may have text or images specified by the credit element.
/// This is used to allow a combination of pages that are all text, or all text and images, together with pages of music.
///
/// The staff-spacing attribute specifies spacing between multiple staves in tenths of staff space.
/// This is deprecated as of Version 1.1; the staff-layout element should be used instead.
/// If both are present, the staff-layout values take priority.
class PrintAttributes {
  /// Specifies spacing between multiple staves in tenths of staff space.
  ///
  /// Deprecated as of Version 1.1; the staff-layout element should be used instead.
  ///
  /// If both are present, the staff-layout values take priority.
  @Deprecated(
    "Deprecated as of Version 1.1; the staff-layout element should be used instead.",
  )
  double? staffSpacing;

  /// Indicates whether to force a system break,
  /// or to force the current music onto the same system as the preceding music.
  ///
  /// Normally this is the first music data within a measure.
  ///
  /// If used in multi-part music,
  /// the attributes should be placed in the same positions within each part,
  /// or the results are undefined.
  bool? newSystem;

  /// Indicates whether to force a page break,
  /// or to force the current music onto the same page as the preceding music.
  ///
  /// Normally this is the first music data within a measure.
  /// If used in multi-part music, the attributes should be placed in the same positions within each part,
  /// or the results are undefined.
  bool? newPage;

  /// The number of blank pages to insert before the current measure.
  ///
  /// It is ignored if new-page is not "yes".
  ///
  /// These blank pages have no music, but may have text or images specified by the credit element.
  ///
  /// This is used to allow a combination of pages that are all text, or all text and images,
  /// together with pages of music.
  int? blankPage;

  /// Sets the number of a new page. It is ignored if new-page is not "yes".
  int? pageNumber;

  PrintAttributes({
    this.staffSpacing,
    this.newSystem,
    this.newPage,
    this.blankPage,
    required this.pageNumber,
  });

  factory PrintAttributes.fromXml(XmlElement xmlElement) {
    return PrintAttributes(
      staffSpacing: double.tryParse(
        xmlElement.getAttribute("staff-spacing") ?? "",
      ),
      newSystem: YesNo.toBool(
        xmlElement.getAttribute("new-system") ?? "",
      ),
      newPage: YesNo.toBool(
        xmlElement.getAttribute("new-page") ?? "",
      ),
      blankPage: int.tryParse(
        xmlElement.getAttribute("blank-page") ?? "",
      ),
      pageNumber: int.tryParse(
        xmlElement.getAttribute("page-number") ?? "",
      ),
    );
  }
}

/// Describes how frequently measure numbers are displayed on this part.
///
/// The text attribute from the measure element is used for display,
/// or the number attribute if the text attribute is not present.
///
/// Measures with an implicit attribute set to "yes" never display a measure number,
/// regardless of the measure-numbering setting.
///
/// The optional staff attribute refers to staff numbers within the part,
/// from top to bottom on the system.
///
/// It indicates which staff is used as the reference point for vertical positioning.
/// A value of 1 is assumed if not present.
///
/// The optional multiple-rest-always and multiple-rest-range attributes
/// describe how measure numbers are shown on multiple rests
/// when the measure-numbering value is not set to none.
///
/// The multiple-rest-always attribute is set to yes when the measure number
/// should always be shown, even if the multiple rest starts midway
/// through a system when measure numbering is set to system level.
/// The multiple-rest-range attribute is set to yes
/// when measure numbers on multiple rests display the range of numbers
/// for the first and last measure, rather than just the number of the first measure.
class MeasureNumbering {
  MeasureNumberingValue value;

  /// Specifies if measure numbers are associated with a system rather
  /// than the particular part where the [MeasureNumbering] element appears.
  SystemRelationNumber? system;

  /// The staff-number type indicates staff numbers within a multi-staff part.
  ///
  /// Staves are numbered from top to bottom, with 1 being the top staff on a part.
  double staff;

  /// The [multipleRestAlways]  and [multipleRestRange] attributes describe
  /// how measure numbers are shown on multiple rests when the [value] is not set to none.
  ///
  /// The [multipleRestAlways] attribute is set to yes
  /// when the measure number should always be shown,
  /// even if the multiple rest starts midway
  /// through a system when measure numbering is set to system level.
  bool multipleRestAlways;

  /// The [multipleRestAlways]  and [multipleRestRange] attributes describe
  /// how measure numbers are shown on multiple rests when the [value] is not set to none.
  ///
  /// The [multipleRestAlways] attribute is set to yes
  /// when measure numbers on multiple rests display the range of
  /// numbers for the first and last measure,
  /// rather than just the number of the first measure.
  bool multipleRestRange;

  PrintStyleAlign printStyleAlign;

  MeasureNumbering({
    required this.value,
    this.system,
    this.staff = 1,
    this.multipleRestAlways = false,
    this.multipleRestRange = false,
    required this.printStyleAlign,
  });

  factory MeasureNumbering.fromXml(XmlElement xmlElement) {
    return MeasureNumbering(
      value: MeasureNumberingValue.fromString(xmlElement.value ?? "") ??
          MeasureNumberingValue.measure,
      printStyleAlign: PrintStyleAlign.fromXml(xmlElement),
    );
  }
}

/// Fescribes how measure numbers are displayed on this part:
/// - no numbers;
/// - numbers every measure;
/// - numbers every system.
enum MeasureNumberingValue {
  none,
  measure,
  system;

  static MeasureNumberingValue? fromString(String value) {
    throw UnimplementedError();
  }
}
