import 'package:music_notation/models/text.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/models/generic.dart';
import 'package:music_notation/models/printing.dart';

/// The defaults type specifies score-wide defaults for scaling;
/// whether or not the file is a concert score;
/// layout; and default values for the music font, word font, lyric font, and lyric language.
///
/// Except for the concert-score element, if any defaults are missing, the choice of what to use is determined by the application.
class Defaults {
  final Scaling? scaling;

  /// The presence of a concert-score element indicates that a score is displayed in concert pitch.
  /// It is used for scores that contain parts for transposing instruments.
  ///
  /// A document with a concert-score element may not contain any transpose elements that have non-zero values for either the diatonic or chromatic elements.
  ///
  /// Concert scores may include octave transpositions, so transpose elements with a double element or a non-zero octave-change element value are permitted.
  ///
  /// The concert-score element, being of type empty, behaves like a boolean in XML: it indicates 'true' when present and 'false' when absent, hence it's represented as bool in Dart.
  final bool concertScore;
  final Layout? layout;
  final Appearance? appearance;
  final Font? musicFont;
  final Font? wordFont;
  final List<Font>? lyricFonts;
  final List<LyricLanguage>? lyricLanguages;

  Defaults({
    this.scaling,
    this.concertScore = false,
    this.layout,
    this.appearance,
    this.musicFont,
    this.wordFont,
    this.lyricFonts,
    this.lyricLanguages,
  });

  factory Defaults.fromXml(XmlElement xmlElement) {
    return Defaults(
      scaling: Scaling.fromXml(xmlElement.findElements('scaling').first),
      concertScore: xmlElement.findElements('concert-score').isNotEmpty,
      layout: Layout.fromXml(xmlElement.findElements('layout').first),
      appearance: Appearance.fromXml(
        xmlElement.findElements('appearance').first,
      ),
      musicFont: Font.fromXml(xmlElement.findElements('music-font').first),
      wordFont: Font.fromXml(xmlElement.findElements('word-font').first),
      lyricFonts: xmlElement
          .findElements('lyric-font')
          .map((e) => Font.fromXml(e))
          .toList(),
      lyricLanguages: xmlElement
          .findElements('lyric-language')
          .map((e) => LyricLanguage.fromXml(e))
          .toList(),
    );
  }

  XmlElement toXml() {
    final builder = XmlBuilder();
    builder.element('defaults', nest: () {
      if (scaling != null) builder.element('scaling', nest: scaling!.toXml());
      if (concertScore) builder.element('concert-score');
      if (layout != null) builder.element('layout', nest: layout!.toXml());
      if (appearance != null) {
        builder.element('appearance', nest: appearance!.toXml());
      }
      if (musicFont != null) {
        builder.element('music-font', nest: musicFont!.toXml());
      }
      if (wordFont != null) {
        builder.element('word-font', nest: wordFont!.toXml());
      }
      lyricFonts
          ?.forEach((lf) => builder.element('lyric-font', nest: lf.toXml()));
      lyricLanguages?.forEach(
          (ll) => builder.element('lyric-language', nest: ll.toXml()));
    });
    return builder.buildDocument().rootElement;
  }
}

/// The layout group specifies the sequence of page, system, and staff layout elements that is common to both the defaults and print elements.
class Layout {
  PageLayout? pageLayout;
  SystemLayout? systemLayout;
  List<StaffLayout> staffLayouts;

  Layout({
    this.pageLayout,
    this.systemLayout,
    this.staffLayouts = const [],
  });

  factory Layout.fromXml(XmlElement xmlElement) {
    return Layout(
      pageLayout: xmlElement.getElement('page-layout') != null
          ? PageLayout.fromXml(xmlElement.getElement('page-layout')!)
          : null,
      systemLayout: xmlElement.getElement('system-layout') != null
          ? SystemLayout.fromXml(xmlElement.getElement('system-layout')!)
          : null,
      staffLayouts: xmlElement
          .findElements('staff-layout')
          .map((element) => StaffLayout.fromXml(element))
          .toList(),
    );
  }

  XmlElement toXml() {
    var builder = XmlBuilder();
    builder.element('layout', nest: () {
      if (pageLayout != null) {
        builder.element('page-layout', nest: pageLayout!.toXml());
      }
      if (systemLayout != null) {
        builder.element('system-layout', nest: systemLayout!.toXml());
      }
      for (var staffLayout in staffLayouts) {
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

// <xs:group name="layout">
// 	<xs:annotation>
// 		<xs:documentation></xs:documentation>
// 	</xs:annotation>
// 	<xs:sequence>
// 		<xs:element name="page-layout" type="page-layout" minOccurs="0"/>
// 		<xs:element name="system-layout" type="system-layout" minOccurs="0"/>
// 		<xs:element name="staff-layout" type="staff-layout" minOccurs="0" maxOccurs="unbounded"/>
// 	</xs:sequence>
// </xs:group>

// 	<xs:complexType name="defaults">
// 		<xs:sequence>
// 			<xs:group ref="layout"/>
// 			<xs:element name="appearance" type="appearance" minOccurs="0"/>
// 			<xs:element name="music-font" type="empty-font" minOccurs="0"/>
// 			<xs:element name="word-font" type="empty-font" minOccurs="0"/>
// 			<xs:element name="lyric-font" type="lyric-font" minOccurs="0" maxOccurs="unbounded"/>
// 			<xs:element name="lyric-language" type="lyric-language" minOccurs="0" maxOccurs="unbounded"/>
// 		</xs:sequence>
// 	</xs:complexType>

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
  /// System margins are relative to the page margins. Positive values indent and negative values reduce the margin size.
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

/// The appearance type controls general graphical settings for the music's final form appearance on a printed page of display.
///
/// This includes support for line widths, definitions for note sizes, and standard distances between notation elements, plus an extension element for other aspects of appearance.
class Appearance {
  List<LineWidth> lineWidths;
  List<NoteSize> noteSizes;
  List<Distance> distances;
  List<Glyph> glyphs;
  List<OtherAppearance> otherAppearances;

  Appearance({
    required this.lineWidths,
    required this.noteSizes,
    required this.distances,
    required this.glyphs,
    required this.otherAppearances,
  });

  factory Appearance.fromXml(XmlElement xmlElement) {
    return Appearance(
      lineWidths: xmlElement
          .findElements('line-width')
          .map((element) => LineWidth.fromXml(element))
          .toList(),
      noteSizes: xmlElement
          .findElements('note-size')
          .map((element) => NoteSize.fromXml(element))
          .toList(),
      distances: xmlElement
          .findElements('distance')
          .map((element) => Distance.fromXml(element))
          .toList(),
      glyphs: xmlElement
          .findElements('glyph')
          .map((element) => Glyph.fromXml(element))
          .toList(),
      otherAppearances: xmlElement
          .findElements('other-appearance')
          .map((element) => OtherAppearance.fromXml(element))
          .toList(),
    );
  }

  XmlElement toXml() {
    var builder = XmlBuilder();
    builder.element('appearance', nest: () {
      for (var lineWidth in lineWidths) {
        builder.element('line-width', nest: lineWidth.toXml());
      }
      for (var noteSize in noteSizes) {
        builder.element('note-size', nest: noteSize.toXml());
      }
      for (var distance in distances) {
        builder.element('distance', nest: distance.toXml());
      }
      for (var glyph in glyphs) {
        builder.element('glyph', nest: glyph.toXml());
      }
      for (var otherAppearance in otherAppearances) {
        builder.element('other-appearance', nest: otherAppearance.toXml());
      }
    });
    return builder.buildDocument().rootElement;
  }
}

// <xs:complexType name="appearance">
// 	<xs:annotation>
// 		<xs:documentation>The appearance type controls general graphical settings for the music's final form appearance on a printed page of display. This includes support for line widths, definitions for note sizes, and standard distances between notation elements, plus an extension element for other aspects of appearance.</xs:documentation>
// 	</xs:annotation>
// 	<xs:sequence>
// 		<xs:element name="line-width" type="line-width" minOccurs="0" maxOccurs="unbounded"/>
// 		<xs:element name="note-size" type="note-size" minOccurs="0" maxOccurs="unbounded"/>
// 		<xs:element name="distance" type="distance" minOccurs="0" maxOccurs="unbounded"/>
// 		<xs:element name="glyph" type="glyph" minOccurs="0" maxOccurs="unbounded"/>
// 		<xs:element name="other-appearance" type="other-appearance" minOccurs="0" maxOccurs="unbounded"/>
// 	</xs:sequence>
// </xs:complexType>

/// The line-width type indicates the width of a line type in tenths.
///
/// The type attribute defines what type of line is being defined. Values include beam, bracket, dashes, enclosure, ending, extend, heavy barline, leger, light barline, octave shift, pedal, slur middle, slur tip, staff, stem, tie middle, tie tip, tuplet bracket, and wedge.
///
/// The text content is expressed in tenths.
class LineWidth {
  // enum LineWidthType {
//   beam,
//   bracket,
//   dashes,
//   enclosure,
//   ending,
//   extend,
//   heavyBarline,
//   leger,
//   lightBarline,
//   octaveShift,
//   pedal,
//   slurMiddle,
//   slurTip,
//   staff,
//   stem,
//   tieMiddle,
//   tieTip,
//   tupletBracket,
//   wedge,
// }

  String type;

  double value;

  LineWidth({
    required this.type,
    required this.value,
  });

  factory LineWidth.fromXml(XmlElement element) {
    return LineWidth(
      value: double.parse(element.text),
      type: element.getAttribute("type") ?? "",
    );
  }

  XmlElement toXml() {
    XmlBuilder builder = XmlBuilder();
    builder.element(
      'line-width',
      attributes: {
        'type': type,
      },
      nest: value.toString(),
    );
    // TODO make
    return builder.buildDocument().rootElement;
  }
}

/// The note-size type indicates the percentage of the regular note size to use for notes with a cue and large size as defined in the type element.
///
/// The grace type is used for notes of cue size that that include a grace element.
///
/// The cue type is used for all other notes with cue size, whether defined explicitly or implicitly via a cue element.
/// The large type is used for notes of large size. The text content represent the numeric percentage.
///
/// A value of 100 would be identical to the size of a regular note as defined by the music font.
class NoteSize {
  final double size;
  final NoteSizeType type;

  NoteSize({required this.size, required this.type});

  /// Converts an instance of NoteSize to an XML node
  XmlNode toXml() {
    final builder = XmlBuilder();
    builder.element(
      'note-size',
      attributes: {'type': type.name}, // Check type
      nest: size.toString(),
    );
    return builder.buildDocument().rootElement;
  }

  // Create an instance of NoteSize from an XML node
  static NoteSize fromXml(XmlElement node) {
    return NoteSize(
      size: double.parse(node.text),
      type: NoteSizeType.fromString(node.getAttribute('type') ?? ''),
    );
  }
}

enum NoteSizeType {
  cue,
  grace,
  graceCue,
  large;

  static NoteSizeType fromString(String value) {
    return NoteSizeType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError('"$value" is not a valid NoteSizeType'),
    );
  }
}

/// The distance element represents standard distances between notation elements in tenths.
/// The type attribute defines what type of distance is being defined.
///
/// Valid values include hyphen (for hyphens in lyrics) and beam.
class Distance {
  double value;

  /// type="disntace-type"
  String type;

  Distance({
    required this.value,
    required this.type,
  });

  // Convert an instance of Distance to an XML node
  XmlNode toXml() {
    final builder = XmlBuilder();
    // builder.element('note-size',
    //     attributes: {'type': enumToString(type)}, nest: size.toString());
    // TODO
    return builder.buildDocument().rootElement;
  }

  // Create an instance of NoteSize from an XML node
  static Distance fromXml(XmlElement node) {
    return Distance(
      value: double.parse(node.text),
      type: "", // TODO
    );
  }
}

/// The glyph element represents what SMuFL glyph should be used for different variations of symbols that are semantically identical.
///
/// The type attribute specifies what type of glyph is being defined.
/// The element value specifies what SMuFL glyph to use, including recommended stylistic alternates.
///
/// The SMuFL glyph name should match the type. For instance, a type of quarter-rest would use values restQuarter, restQuarterOld, or restQuarterZ.
///
/// A type of g-clef-ottava-bassa would use values gClef8vb, gClef8vbOld, or gClef8vbCClef.
///
/// A type of octave-shift-up-8 would use values ottava, ottavaBassa, ottavaBassaBa, ottavaBassaVb, or octaveBassa.
class Glyph {
  /// The smufl-glyph-name type is used for attributes that reference a specific Standard Music Font Layout (SMuFL) character.
  ///
  /// The value is a SMuFL canonical glyph name, not a code point.
  /// For instance, the value for a standard piano pedal mark would be keyboardPedalPed, not U+E650.
  ///
  /// Type="smufl-glyph-name"
  String name;

  /// The glyph-type defines what type of glyph is being defined in a glyph element.
  ///
  /// Values include quarter-rest, g-clef-ottava-bassa, c-clef, f-clef, percussion-clef, octave-shift-up-8, octave-shift-down-8, octave-shift-continue-8, octave-shift-down-15, octave-shift-up-15, octave-shift-continue-15, octave-shift-down-22, octave-shift-up-22, and octave-shift-continue-22.
  ///
  /// This is left as a string so that other application-specific types can be defined, but it is made a separate type so that it can be redefined more strictly.
  ///
  /// A quarter-rest type specifies the glyph to use when a note has a rest element and a type value of quarter.
  ///
  /// The c-clef, f-clef, and percussion-clef types specify the glyph to use when a clef sign element value is C, F, or percussion respectively.
  ///
  /// The g-clef-ottava-bassa type specifies the glyph to use when a clef sign element value is G and the clef-octave-change element value is -1.
  ///
  /// The octave-shift types specify the glyph to use when an octave-shift type attribute value is up, down, or continue and the octave-shift size attribute value is 8, 15, or 22.
  String type;

  Glyph({
    required this.name,
    required this.type,
  });

  // Convert an instance of Distance to an XML node
  XmlNode toXml() {
    final builder = XmlBuilder();
    // builder.element('note-size',
    //     attributes: {'type': enumToString(type)}, nest: size.toString());
    // TODO
    return builder.buildDocument().rootElement;
  }

  // Create an instance of NoteSize from an XML node
  factory Glyph.fromXml(XmlElement node) {
    return Glyph(
      name: node.text,
      type: "", // TODO
    );
  }
}

/// The other-appearance type is used to define any graphical settings not yet in the current version of the MusicXML format.
///
/// This allows extended representation, though without application interoperability.
class OtherAppearance {
  final String value;
  final String type;

  OtherAppearance({required this.value, required this.type});

  factory OtherAppearance.fromXml(XmlElement element) {
    if (element.name.local != 'other-appearance') {
      throw FormatException("Unexpected element name: ${element.name.local}");
    }

    final type = element.getAttribute('type');
    if (type == null) {
      throw FormatException('Missing required attribute "type"');
    }

    return OtherAppearance(value: element.text, type: type);
  }

  XmlElement toXml() {
    final builder = XmlBuilder();
    builder.element('other-appearance',
        attributes: {'type': type}, nest: value);
    return builder.buildDocument().rootElement;
  }

  @override
  String toString() => 'OtherAppearance(value: $value, type: $type)';
}
