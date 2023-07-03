import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/common_attributes.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';

/// Specifies the sequence of page, system, and staff layout elements
/// that is common to both the defaults and print elements.
class Layout {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  final PageLayout? page;
  final SystemLayout? system;
  final List<StaffLayout> staffs;

  Layout({
    this.page,
    this.system,
    this.staffs = const [],
  });

  const Layout.empty()
      : page = null,
        system = null,
        staffs = const [];

  factory Layout.fromXml(XmlElement xmlElement) {
    XmlElement? pageLayoutElement = xmlElement.getElement('page-layout');

    XmlElement? systemLayoutElement = xmlElement.getElement('system-layout');

    return Layout(
      page: pageLayoutElement != null
          ? PageLayout.fromXml(pageLayoutElement)
          : null,
      system: systemLayoutElement != null
          ? SystemLayout.fromXml(systemLayoutElement)
          : null,
      staffs: xmlElement
          .findElements('staff-layout')
          .map((element) => StaffLayout.fromXml(element))
          .toList(),
    );
  }

  XmlElement toXml() {
    var builder = XmlBuilder();
    builder.element('layout', nest: () {
      if (page != null) {
        builder.element('page-layout', nest: page!.toXml());
      }
      if (system != null) {
        builder.element('system-layout', nest: system!.toXml());
      }
      for (var staffLayout in staffs) {
        builder.element('staff-layout', nest: staffLayout.toXml());
      }
    });
    return builder.buildDocument().rootElement;
  }
}

/// Page layout can be defined both in score-wide defaults and in the print element.
///
/// Page margins are specified either for both even and odd pages,
/// or via separate odd and even page number values.
///
/// The type is not needed when used as part of a print element.
/// If omitted when used in the defaults element, "both" is the default.
///
/// If no page-layout element is present in the defaults element, default page layout values are chosen by the application.
///
/// When used in the print element, the page-layout element affects the appearance of the current page only.
///
/// All other pages use the default values as determined by the defaults element.
/// If any child elements are missing from the page-layout element in a print element,
/// the values determined by the defaults element are used there as well.
///
/// For more details go to
/// [The \<page-layout\> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/page-layout/).
class PageLayout {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// Specifies the height and width in tenths.
  ({double height, double width})? size;

  List<PageMargins> margins;

  PageLayout({
    this.size,
    this.margins = const [],
  });

  // Field(s): quantifier
  static const Map<dynamic, XmlQuantifier> _xmlExpectedOrder = {
    {
      'page-height': XmlQuantifier.required,
      'page-width': XmlQuantifier.required,
    }: XmlQuantifier.optional,
    'page-margins': XmlQuantifier.zeroToTwo,
  };

  factory PageLayout.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    XmlElement? heightElement = xmlElement.getElement('page-height');
    if (heightElement != null &&
        heightElement.firstChild?.nodeType != XmlNodeType.TEXT) {
      throw XmlElementContentException(
        message: "'page-height' must have text content ",
        xmlElement: xmlElement,
      );
    }

    XmlElement? widthElement = xmlElement.getElement('page-width');
    if (widthElement != null &&
        widthElement.firstChild?.nodeType != XmlNodeType.TEXT) {
      throw XmlElementContentException(
        message: "'page-width' must have text content ",
        xmlElement: xmlElement,
      );
    }

    double? height =
        heightElement != null ? double.tryParse(heightElement.innerText) : null;
    if (heightElement != null && height == null) {
      throw MusicXmlFormatException(
        message: "'height' element must have 'double' type content",
        xmlElement: xmlElement,
      );
    }

    double? width =
        widthElement != null ? double.tryParse(widthElement.innerText) : null;
    if (widthElement != null && width == null) {
      throw MusicXmlFormatException(
        message: "'width' element must have 'double' type content",
        xmlElement: xmlElement,
      );
    }

    return PageLayout(
      size: height == null && width == null
          ? null
          : (height: height!, width: width!),
      margins: xmlElement
          .findElements('page-margins')
          .map((element) => PageMargins.fromXml(element, false))
          .toList(),
    );
  }

  XmlElement toXml() {
    var builder = XmlBuilder();
    builder.element('page-layout', nest: () {
      if (size?.height != null) {
        builder.element('page-height', nest: size?.height.toString());
      }
      if (size?.width != null) {
        builder.element('page-width', nest: size?.width.toString());
      }
      for (var pageMargin in margins) {
        builder.element('page-margins', nest: pageMargin.toXml());
      }
    });
    return builder.buildDocument().rootElement;
  }
}

/// Specifies whether margins apply to even page, odd pages, or both.
///
/// For more details go to
/// [margin-type data type | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/margin-type/).
enum MarginType {
  /// Margins apply to odd pages only.
  odd,

  /// Margins apply to even pages only.
  even,

  /// Margins apply to both even and odd pages.
  both;

  static MarginType? fromString(String value) {
    switch (value) {
      case 'odd':
        return MarginType.odd;
      case 'even':
        return MarginType.even;
      case 'both':
        return MarginType.both;
      default:
        return null;
    }
  }
}

class HorizontalMargins {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// The left margin for the parent element in tenths.
  double left;

  /// The right margin for the parent element in tenths.
  double right;

  HorizontalMargins({
    required this.left,
    required this.right,
  });

  factory HorizontalMargins.fromXml(XmlElement xmlElement) {
    XmlElement? leftMarginElement = xmlElement.getElement('left-margin');
    if (leftMarginElement?.childElements.isNotEmpty == true) {
      throw XmlElementContentException(
        message: "'left-margin' element content must be double",
        xmlElement: xmlElement,
      );
    }
    double? left = double.tryParse(leftMarginElement?.innerText ?? '');
    if (left == null) {
      throw MusicXmlFormatException(
        message: "'left-margin' element content cannot be parsed to double",
        xmlElement: xmlElement,
        source: leftMarginElement?.innerText,
      );
    }

    XmlElement? rightMarginElement = xmlElement.getElement('right-margin');
    if (rightMarginElement?.childElements.isNotEmpty == true) {
      throw XmlElementContentException(
        message: "'right-margin' element content must be double",
        xmlElement: xmlElement,
      );
    }
    double? right = double.tryParse(rightMarginElement?.innerText ?? '');
    if (right == null) {
      throw MusicXmlFormatException(
        message: "'right-margin' element content cannot be parsed to double",
        xmlElement: xmlElement,
        source: rightMarginElement?.innerText,
      );
    }

    return HorizontalMargins(
      left: left,
      right: right,
    );
  }
}

class Margins implements HorizontalMargins {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// The left margin for the parent element in tenths.
  @override
  double left;

  /// The right margin for the parent element in tenths.
  @override
  double right;

  /// The top page margin in tenths.
  double top;

  /// The bottom page margin in tenths.
  double bottom;

  Margins({
    required this.left,
    required this.right,
    required this.top,
    required this.bottom,
  });

  factory Margins.fromXml(XmlElement xmlElement) {
    HorizontalMargins horizontalMargins = HorizontalMargins.fromXml(xmlElement);

    XmlElement? topMarginElement = xmlElement.getElement('top-margin');
    if (topMarginElement?.childElements.isNotEmpty == true) {
      throw XmlElementContentException(
        message: "'top-margin' element content must be double",
        xmlElement: xmlElement,
      );
    }
    double? top = double.tryParse(topMarginElement?.innerText ?? '');
    if (top == null) {
      throw MusicXmlFormatException(
        message: "'top-margin' element content cannot be parsed to double",
        xmlElement: xmlElement,
        source: topMarginElement?.innerText,
      );
    }

    final XmlElement? bottomMarginElement = xmlElement.getElement(
      'bottom-margin',
    );
    if (bottomMarginElement?.childElements.isNotEmpty == true) {
      throw XmlElementContentException(
        message: "'bottom-margin' element content must be double",
        xmlElement: xmlElement,
      );
    }
    final double? bottom = double.tryParse(
      bottomMarginElement?.innerText ?? '',
    );
    if (bottom == null) {
      throw MusicXmlFormatException(
        message: "'bottom-margin' element content cannot be parsed to double",
        xmlElement: xmlElement,
        source: bottomMarginElement?.innerText,
      );
    }

    return Margins(
      left: horizontalMargins.left,
      right: horizontalMargins.right,
      top: top,
      bottom: bottom,
    );
  }

  XmlElement toXml() {
    var builder = XmlBuilder();
    builder.element('all-margins', nest: () {
      // TODO:
      // leftRightMargins.toXml(builder);

      builder.element('left-margin', nest: left);
      builder.element('right-margin', nest: right);
      builder.element('top-margin', nest: top);
      builder.element('bottom-margin', nest: bottom);
    });
    return builder.buildDocument().rootElement;
  }
}

/// Page margins are specified either for both even and odd pages,
/// or via separate odd and even page number values.
///
/// The type attribute is not needed when used as part of a print element.
///
/// If omitted when the page-margins type is used in the defaults element, "both" is the default value.
///
/// For more details go to
/// [The \<page-margins\> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/page-margins/).
class PageMargins {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  final Margins margins;

  /// Specifies whether the margins apply to even pages, odd pages, or both.
  /// This attribute is not needed when used as part of a <print> element.
  /// The value is both if omitted when used in the <defaults> element.
  final MarginType? type;

  final bool _isPrint;

  PageMargins({
    required this.margins,
    required this.type,
    required bool isPrint,
  }) : _isPrint = isPrint;

  // Field(s): quantifier
  static const Map<String, XmlQuantifier> _xmlExpectedOrder = {
    'left-margin': XmlQuantifier.required,
    'right-margin': XmlQuantifier.required,
    'top-margin': XmlQuantifier.required,
    'bottom-margin': XmlQuantifier.required,
  };

  factory PageMargins.fromXml(XmlElement xmlElement, [bool isPrint = true]) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    String? typeAttribute = xmlElement.getAttribute('type');

    MarginType? type;

    if (typeAttribute != null && !isPrint) {
      type = MarginType.fromString(typeAttribute);
      if (type == null) {
        throw MusicXmlTypeException(
          message: "'type' is not valid margin-type: '$typeAttribute'",
          xmlElement: xmlElement,
        );
      }
    }
    if (typeAttribute == null && !isPrint) {
      type = MarginType.both;
    }

    return PageMargins(
      margins: Margins.fromXml(xmlElement),
      type: type,
      isPrint: isPrint,
    );
  }

  XmlElement toXml() {
    var builder = XmlBuilder();

    Map<String, String> attributes = {};

    if (!_isPrint) {
      attributes = {
        'type': type?.name ?? MarginType.both.name,
      };
    }

    builder.element(
      'page-margins',
      attributes: attributes,
      nest: margins.toXml(),
    );
    return builder.buildDocument().rootElement;
  }
}

/// Vertical distance from the bottom line of the previous staff
/// in this system to the top line of the staff specified by the number attribute.
///
/// The optional number attribute refers to staff numbers within the part,
/// from top to bottom on the system.
/// A value of 1 is used if not present.
///
/// When used in the defaults element, the values apply to all systems in all parts.
/// When used in the print element, the values apply to the current system only.
/// This value is ignored for the first staff in a system.
///
/// For more details go to
/// [The \<staff-layout\> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/staff-layout/).
class StaffLayout {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// Represents the vertical distance from the bottom line of the previous
  /// staff in this system to the top line of the current staff.
  double? distance;

  /// Indicates staff numbers within a multi-staff part.
  /// Staves are numbered from top to bottom, with 1 being the top staff on a part.
  ///
  /// Must be bigger than 1. Also, tt must not exceed the total number of staves
  /// in the part it refers to. For example, if a part has two staves,
  /// the staff-number can be either 1 or 2, but not 3.
  int number;

  StaffLayout({
    this.distance,
    this.number = 1,
  });

  factory StaffLayout.fromXml(XmlElement xmlElement) {
    XmlElement? staffDistanceElement = xmlElement.getElement('staff-distance');
    if (staffDistanceElement?.childElements.isNotEmpty == true) {
      throw XmlElementContentException(
        message: "'staff-distance' element must have only tenths type content",
        xmlElement: xmlElement,
      );
    }
    double? staffDistance = double.tryParse(
      staffDistanceElement?.innerText ?? "",
    );
    if (staffDistanceElement != null && staffDistance == null) {
      throw MusicXmlFormatException(
        message: "'staff-distance' must be type of tenths",
        xmlElement: xmlElement,
        source: staffDistanceElement.innerText,
      );
    }

    String numberAttribute = xmlElement.getAttribute('number') ?? '1';
    int? number = int.tryParse(numberAttribute);

    if (number == null || number < 1) {
      throw MusicXmlFormatException(
        message:
            "'number' attribute in 'staff-layout' must be type of 'staff-number'",
        xmlElement: xmlElement,
        source: numberAttribute,
      );
    }

    return StaffLayout(
      distance: staffDistance,
      number: number,
    );
  }

  XmlElement toXml() {
    var builder = XmlBuilder();
    builder.element('staff-layout', attributes: {'number': '$number'},
        nest: () {
      if (distance != null) {
        builder.element('staff-distance', nest: distance);
      }
    });
    return builder.buildDocument().rootElement;
  }
}

/// Group of staves that are read and played simultaneously.
///
/// System layout includes left and right margins and the vertical distance from the previous system.
///
/// The system distance is measured from the bottom line of the previous system to the top line of the current system.
/// It is ignored for the first system on a page.
/// The top system distance is measured from the page's top margin to the top line of the first system.
/// It is ignored for all but the first system on a page.
///
/// Sometimes the sum of measure widths in a system may not equal the system
/// width specified by the layout elements due to roundoff or other errors.
/// The behavior when reading MusicXML files in these cases is application-dependent.
/// For instance, applications may find that the system layout data is more
/// reliable than the sum of the measure widths, and adjust the measure widths accordingly.
///
/// When used in the defaults element, the [SystemLayout] element defines
/// a default appearance for all systems in the score.
/// If no [SystemLayout] element is present in the defaults element,
/// default system layout values are chosen by the application.
///
/// When used in the print element, the [SystemLayout] element
/// affects the appearance of the current system only.
/// All other systems use the default values as determined by the defaults element.
/// If any child elements are missing from the system-layout element in a print element,
/// the values determined by the defaults element are used there as well.
/// This type of system-layout element need only be read from or written
/// to the first visible part in the score.
///
/// For more details go to
/// [The \<system-layout\> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/system-layout/).
class SystemLayout {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// System margins are relative to the page margins.
  /// Positive values indent and negative values reduce the margin size.
  HorizontalMargins? margins;

  /// Distance that is measured from the bottom line of the previous system to
  /// the top line of the current system.
  ///
  /// It is ignored for the first system on a page.
  double? distance;

  /// Distance that is measured from the page's top margin to the top line of the first system.
  ///
  /// It is ignored for all but the first system on a page.
  double? topDistance;

  /// Indicates the presence or absence of system dividers.
  SystemDividers? dividers;

  SystemLayout({
    this.margins,
    this.distance,
    this.topDistance,
    this.dividers,
  });

  // Field(s): quantifier
  static const Map<String, XmlQuantifier> _xmlExpectedOrder = {
    'system-margins': XmlQuantifier.optional,
    'system-distance': XmlQuantifier.optional,
    'top-system-distance': XmlQuantifier.optional,
    'system-dividers': XmlQuantifier.optional,
  };

  factory SystemLayout.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    final XmlElement? systemMarginsElement = xmlElement.getElement(
      'system-margins',
    );

    final XmlElement? systemDistanceElement = xmlElement.getElement(
      'system-distance',
    );
    if (systemDistanceElement?.childElements.isNotEmpty == true) {
      throw XmlElementContentException(
        message: "'system-distance' must have tenths type content",
        xmlElement: xmlElement,
      );
    }
    final double? systemDistance = double.tryParse(
      systemDistanceElement?.innerText ?? "",
    );
    if (systemDistanceElement != null && systemDistance == null) {
      throw MusicXmlFormatException(
        message: "'system-distance' must be tenths type",
        xmlElement: xmlElement,
        source: systemDistanceElement.innerText,
      );
    }

    final XmlElement? topSystemDistanceElement = xmlElement.getElement(
      'top-system-distance',
    );
    if (topSystemDistanceElement?.childElements.isNotEmpty == true) {
      throw XmlElementContentException(
        message: "'top-system-distance' must have tenths type content",
        xmlElement: xmlElement,
      );
    }
    final double? systemTopDistance = double.tryParse(
      topSystemDistanceElement?.innerText ?? "",
    );
    if (topSystemDistanceElement != null && systemTopDistance == null) {
      throw MusicXmlFormatException(
        message: "'top-system-distance' must be tenths type",
        xmlElement: xmlElement,
        source: topSystemDistanceElement.innerText,
      );
    }

    final XmlElement? systemDividersElement = xmlElement.getElement(
      'system-dividers',
    );

    return SystemLayout(
      margins: systemMarginsElement != null
          ? HorizontalMargins.fromXml(systemMarginsElement)
          : null,
      distance: systemDistance,
      topDistance: systemTopDistance,
      dividers: systemDividersElement != null
          ? SystemDividers.fromXml(systemDividersElement)
          : null,
    );
  }

  XmlElement toXml() {
    var builder = XmlBuilder();
    builder.element('system-layout', nest: () {
      // if (systemMargins != null) {
      //   builder.element('system-margins', nest: systemMargins!.toXml());
      // }
      if (distance != null) {
        builder.element('system-distance', nest: distance);
      }
      if (topDistance != null) {
        builder.element('top-system-distance', nest: topDistance);
      }
      if (dividers != null) {
        builder.element('system-dividers', nest: dividers!.toXml());
      }
    });
    return builder.buildDocument().rootElement;
  }
}

/// Indicates the presence or absence ofsystem dividers (also known as system separation marks)
/// between systems displayed on the same page.
///
/// Dividers on the left and right side of the page are controlled
/// by the [left] and [right] elements respectively.
///
/// The default vertical position is half the system-distance
/// value from the top of the system that is below the divider.
///
/// The default horizontal position is the left and right system margin, respectively.
///
/// When used in the print element, the system-dividers element affects
/// the dividers that would appear between the current system and the previous system.
///
/// For more details go to
/// [The \<system-dividers\> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/system-dividers/).
class SystemDividers {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// Indicates the presence or absence of a system divider
  /// (also known as a system separation mark) displayed on the left side of the page.
  ///
  /// The default vertical position is half the system distance
  /// value from the top of the system that is below the divider.
  ///
  /// The default horizontal position is the left system margin.
  final DividerPrintStyle left;

  /// Indicates the presence or absence of a system divider
  /// (also known as a system separation mark) displayed on the right side of the page.
  ///
  /// The default vertical position is right the system distance
  /// value from the top of the system that is below the divider.
  ///
  /// The default horizontal position is the right system margin.
  final DividerPrintStyle right;

  SystemDividers({
    required this.left,
    required this.right,
  });

  // Field(s): quantifier
  static const Map<String, XmlQuantifier> _xmlExpectedOrder = {
    'left-divider': XmlQuantifier.required,
    'right-divider': XmlQuantifier.required,
  };

  factory SystemDividers.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    return SystemDividers(
      left: DividerPrintStyle.fromXml(
        xmlElement.getElement('left-divider')!,
      ),
      right: DividerPrintStyle.fromXml(
        xmlElement.getElement('right-divider')!,
      ),
    );
  }

  XmlElement toXml() {
    var builder = XmlBuilder();
    builder.element('system-dividers', nest: () {
      builder.element('left-divider', nest: left.toXml());
      builder.element('right-divider', nest: right.toXml());
    });
    return builder.buildDocument().rootElement;
  }
}

/// Represents an empty element with [printObject] and [PrintStyleAlign] attribute groups.
///
/// For more details go to
/// [The \<right-divider\> element | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/right-divider/).
class DividerPrintStyle extends PrintStyleAlign {
  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Specifies whether or not to print an object (e.g. a note or a rest).
  ///
  /// It is true (yes) by default.
  bool printObject;

  DividerPrintStyle({
    this.printObject = true,
    required super.horizontalAlignment,
    required super.verticalAlignment,
    required super.position,
    required super.font,
    required super.color,
  });

  factory DividerPrintStyle.fromXml(XmlElement xmlElement) {
    bool? printObject = YesNo.fromXml(xmlElement, CommonAttributes.printObject);

    PrintStyleAlign printStyleAlign = PrintStyleAlign.fromXml(xmlElement);

    return DividerPrintStyle(
      printObject: printObject ?? true,
      color: printStyleAlign.color,
      font: printStyleAlign.font,
      horizontalAlignment: printStyleAlign.horizontalAlignment,
      position: printStyleAlign.position,
      verticalAlignment: printStyleAlign.verticalAlignment,
    );
  }

  XmlElement toXml() {
    var builder = XmlBuilder();
    builder.element('empty-print-object-style-align');
    return builder.buildDocument().rootElement;
  }
}
