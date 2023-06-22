import 'package:music_notation/src/models/printing.dart';
import 'package:xml/xml.dart';

/// Specifies the sequence of page, system, and staff layout elements
/// that is common to both the defaults and print elements.
class Layout {
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
/// Page margins are specified either for both even and odd pages, or via separate odd and even page number values.
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
class PageLayout {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  double? pageHeight;
  double? pageWidth;
  List<PageMargins> pageMargins;

  PageLayout({
    this.pageHeight,
    this.pageWidth,
    this.pageMargins = const [],
  });

  factory PageLayout.fromXml(XmlElement xmlElement) {
    return PageLayout(
      pageHeight: xmlElement.getElement('page-height') != null
          ? double.parse(xmlElement.getElement('page-height')!.text)
          : null,
      pageWidth: xmlElement.getElement('page-width') != null
          ? double.parse(xmlElement.getElement('page-width')!.text)
          : null,
      pageMargins: xmlElement
          .findElements('page-margins')
          .map((element) => PageMargins.fromXml(element))
          .toList(),
    );
  }

  XmlElement toXml() {
    var builder = XmlBuilder();
    builder.element('page-layout', nest: () {
      if (pageHeight != null) {
        builder.element('page-height', nest: pageHeight.toString());
      }
      if (pageWidth != null) {
        builder.element('page-width', nest: pageWidth.toString());
      }
      for (var pageMargin in pageMargins) {
        builder.element('page-margins', nest: pageMargin.toXml());
      }
    });
    return builder.buildDocument().rootElement;
  }
}

/// The margin-type type specifies whether margins apply to even page, odd pages, or both.
enum MarginType {
  odd,
  even,
  both,
}

/// Page margins are specified either for both even and odd pages, or via separate odd and even page number values.
///
/// The type attribute is not needed when used as part of a print element.
///
/// If omitted when the page-margins type is used in the defaults element, "both" is the default value.
class PageMargins {
  AllMargins allMargins;
  MarginType type;

  PageMargins({
    required this.allMargins,
    required this.type,
  });

  factory PageMargins.fromXml(XmlElement xmlElement) {
    return PageMargins(
      allMargins: AllMargins.fromXml(xmlElement),
      type: _parseMarginType(xmlElement.getAttribute('type')),
    );
  }

  XmlElement toXml() {
    var builder = XmlBuilder();
    builder.element('page-margins',
        attributes: {
          'type': _marginTypeToString(type),
        },
        nest: allMargins.toXml());
    return builder.buildDocument().rootElement;
  }

  // TODO move to enum
  static MarginType _parseMarginType(String? value) {
    switch (value) {
      case 'odd':
        return MarginType.odd;
      case 'even':
        return MarginType.even;
      case 'both':
      default:
        return MarginType.both;
    }
  }

  // TODO move to enum\
  static String _marginTypeToString(MarginType value) {
    switch (value) {
      case MarginType.odd:
        return 'odd';
      case MarginType.even:
        return 'even';
      case MarginType.both:
      default:
        return 'both';
    }
  }
}

/// The all-margins group specifies both horizontal and vertical margins in tenths.
class AllMargins {
  /// Type: tenths/decimal.
  double left;

  /// Type: tenths/decimal.
  double right;

  /// Type: tenths/decimal.
  double top;

  /// Type: tenths/decimal.
  double bottom;

  AllMargins({
    required this.left,
    required this.right,
    required this.top,
    required this.bottom,
  });

  factory AllMargins.fromXml(XmlElement xmlElement) {
    // TODO:
    // The left-right-margins group specifies horizontal margins in tenths.
    // leftRightMargins: LeftRightMargins.fromXml(
    //     xmlElement.findElements('left-right-margins').first),
    return AllMargins(
      left: double.parse(xmlElement.findElements('left-margin').first.text),
      right: double.parse(xmlElement.findElements('right-margin').first.text),
      top: double.parse(xmlElement.findElements('top-margin').first.text),
      bottom: double.parse(xmlElement.findElements('bottom-margin').first.text),
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

/// Staff layout includes the vertical distance from the bottom line of the previous staff
/// in this system to the top line of the staff specified by the number attribute.
///
/// The optional number attribute refers to staff numbers within the part, from top to bottom on the system.
/// A value of 1 is used if not present.
///
/// When used in the defaults element, the values apply to all systems in all parts.
/// When used in the print element, the values apply to the current system only.
/// This value is ignored for the first staff in a system.
class StaffLayout {
  double? staffDistance;

  /// The staff-number type indicates staff numbers within a multi-staff part.
  /// Staves are numbered from top to bottom, with 1 being the top staff on a part.
  ///
  /// Should be positive integer.
  int? number;

  StaffLayout({
    this.staffDistance,
    this.number,
  });

  factory StaffLayout.fromXml(XmlElement xmlElement) {
    return StaffLayout(
      staffDistance: xmlElement.getElement('staff-distance') != null
          ? double.parse(xmlElement.getElement('staff-distance')!.text)
          : null,
      number: int.parse(xmlElement.getAttribute('number') ?? '0'),
    );
  }

  XmlElement toXml() {
    var builder = XmlBuilder();
    builder.element('staff-layout', attributes: {'number': '$number'},
        nest: () {
      if (staffDistance != null) {
        builder.element('staff-distance', nest: staffDistance);
      }
    });
    return builder.buildDocument().rootElement;
  }
}

/// A system is a group of staves that are read and played simultaneously.
///
/// System layout includes left and right margins and the vertical distance from the previous system.
///
/// The system distance is measured from the bottom line of the previous system to the top line of the current system.
/// It is ignored for the first system on a page.
/// The top system distance is measured from the page's top margin to the top line of the first system.
/// It is ignored for all but the first system on a page.
///
/// Sometimes the sum of measure widths in a system may not equal the system width specified by the layout elements due to roundoff or other errors.
/// The behavior when reading MusicXML files in these cases is application-dependent.
/// For instance, applications may find that the system layout data is more reliable than the sum of the measure widths, and adjust the measure widths accordingly.
///
/// When used in the defaults element, the system-layout element defines a default appearance for all systems in the score.
/// If no system-layout element is present in the defaults element, default system layout values are chosen by the application.
///
/// When used in the print element, the system-layout element affects the appearance of the current system only.
/// All other systems use the default values as determined by the defaults element.
/// If any child elements are missing from the system-layout element in a print element,
/// the values determined by the defaults element are used there as well.
///
/// This type of system-layout element need only be read from or written to the first visible part in the score.
class SystemLayout {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// System margins are relative to the page margins.
  /// Positive values indent and negative values reduce the margin size.
  double leftMargin;
  double rightMargin;
  // SystemMargins? systemMargins; // Assuming SystemMargins class exists
  double? systemDistance;
  double? topSystemDistance;
  SystemDividers? systemDividers; // Assuming SystemDividers class exists

  SystemLayout({
    this.leftMargin = 0, // TODO
    this.rightMargin = 0, // TODO
    this.systemDistance,
    this.topSystemDistance,
    this.systemDividers,
  });

  factory SystemLayout.fromXml(XmlElement xmlElement) {
    return SystemLayout(
      // systemMargins: xmlElement.getElement('system-margins') != null
      //     ? SystemMargins.fromXml(xmlElement.getElement('system-margins')!)
      //     : null,
      systemDistance: xmlElement.getElement('system-distance') != null
          ? double.parse(xmlElement.getElement('system-distance')!.text)
          : null,
      topSystemDistance: xmlElement.getElement('top-system-distance') != null
          ? double.parse(xmlElement.getElement('top-system-distance')!.text)
          : null,
      // systemDividers: xmlElement.getElement('system-dividers') != null
      //     ? SystemDividers.fromXml(xmlElement.getElement('system-dividers')!)
      //     : null,
    );
  }

  XmlElement toXml() {
    var builder = XmlBuilder();
    builder.element('system-layout', nest: () {
      // if (systemMargins != null) {
      //   builder.element('system-margins', nest: systemMargins!.toXml());
      // }
      if (systemDistance != null) {
        builder.element('system-distance', nest: systemDistance);
      }
      if (topSystemDistance != null) {
        builder.element('top-system-distance', nest: topSystemDistance);
      }
      if (systemDividers != null) {
        builder.element('system-dividers', nest: systemDividers!.toXml());
      }
    });
    return builder.buildDocument().rootElement;
  }
}

/// The system-dividers element indicates the presence or absence of system dividers (also known as system separation marks) between systems displayed on the same page.
///
/// Dividers on the left and right side of the page are controlled by the left-divider and right-divider elements respectively.
///
/// The default vertical position is half the system-distance value from the top of the system that is below the divider.
///
/// The default horizontal position is the left and right system margin, respectively.
///
/// When used in the print element, the system-dividers element affects the dividers that would appear between the current system and the previous system.
class SystemDividers {
  EmptyPrintObjectStyleAlign leftDivider;
  EmptyPrintObjectStyleAlign rightDivider;

  SystemDividers({
    required this.leftDivider,
    required this.rightDivider,
  });

  factory SystemDividers.fromXml(XmlElement xmlElement) {
    return SystemDividers(
      leftDivider: EmptyPrintObjectStyleAlign.fromXml(
          xmlElement.getElement('left-divider')!),
      rightDivider: EmptyPrintObjectStyleAlign.fromXml(
          xmlElement.getElement('right-divider')!),
    );
  }

  XmlElement toXml() {
    var builder = XmlBuilder();
    builder.element('system-dividers', nest: () {
      builder.element('left-divider', nest: leftDivider.toXml());
      builder.element('right-divider', nest: rightDivider.toXml());
    });
    return builder.buildDocument().rootElement;
  }
}
