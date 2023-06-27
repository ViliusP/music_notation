import 'package:music_notation/src/models/elements/layout.dart';
import 'package:music_notation/src/models/elements/text/text.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/generic.dart';

/// Specifies score-wide defaults for scaling; whether or not the file is a concert score;
/// layout; and default values for the music font, word font, lyric font, and lyric language.
///
/// Except for the [concertScore], if any defaults are missing,
/// the choice of what to use is determined by the application.
class Defaults {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  final Scaling? scaling;

  /// The presence of a [concertScore] element indicates that a score is displayed in concert pitch.
  /// It is used for scores that contain parts for transposing instruments.
  ///
  /// A document with a [concertScore] may not contain any transpose elements
  /// that have non-zero values for either the diatonic or chromatic elements.
  ///
  /// Concert scores may include octave transpositions, so transpose elements
  /// with a double element or a non-zero octave-change element value are permitted.
  final Empty? concertScore;

  /// Sequence of page, system, and staff layout defaults.
  final Layout layout;

  /// General graphical settings for the music's final form appearance.
  final Appearance? appearance;

  /// Default values for the music font in the score.
  final Font? musicFont;

  /// Default values for the word font in the score.
  final Font? wordFont;

  /// Default fonts for lyrics.
  final List<LyricsFont> lyricFonts;

  /// Default languages for lyrics.
  final List<LyricLanguage> lyricLanguages;

  Defaults({
    this.scaling,
    this.concertScore,
    this.layout = const Layout.empty(),
    this.appearance,
    this.musicFont,
    this.wordFont,
    this.lyricFonts = const [],
    this.lyricLanguages = const [],
  });

  // Field(s): quantifier
  static const Map<String, XmlQuantifier> _xmlExpectedOrder = {
    'scaling': XmlQuantifier.optional,
    'concert-score': XmlQuantifier.optional,
    'page-layout': XmlQuantifier.optional,
    'system-layout': XmlQuantifier.optional,
    'staff-layout': XmlQuantifier.zeroOrMore,
    'appearance': XmlQuantifier.optional,
    'music-font': XmlQuantifier.optional,
    'word-font': XmlQuantifier.optional,
    'lyric-font': XmlQuantifier.zeroOrMore,
    'lyric-language': XmlQuantifier.zeroOrMore,
  };

  factory Defaults.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    XmlElement? scalingElement = xmlElement.getElement('scaling');

    XmlElement? appearanceElement = xmlElement.getElement('appearance');

    XmlElement? musicFontElement = xmlElement.getElement('music-font');

    XmlElement? wordFontElement = xmlElement.getElement('word-font');

    XmlElement? concertScoreElement = xmlElement.getElement('concert-score');

    return Defaults(
      scaling: scalingElement != null ? Scaling.fromXml(scalingElement) : null,
      concertScore: concertScoreElement != null ? const Empty() : null,
      layout: Layout.fromXml(xmlElement),
      appearance: appearanceElement != null
          ? Appearance.fromXml(appearanceElement)
          : null,
      musicFont: musicFontElement != null
          ? Font.fromXml(
              musicFontElement,
            )
          : null,
      wordFont: wordFontElement != null ? Font.fromXml(wordFontElement) : null,
      lyricFonts: xmlElement
          .findElements('lyric-font')
          .map((e) => LyricsFont.fromXml(e))
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
      if (concertScore != null) builder.element('concert-score');
      builder.element('layout', nest: layout.toXml());
      if (appearance != null) {
        builder.element('appearance', nest: appearance!.toXml());
      }
      if (musicFont != null) {
        builder.element('music-font', nest: musicFont!.toXml());
      }
      if (wordFont != null) {
        builder.element('word-font', nest: wordFont!.toXml());
      }
      for (var lyricFont in lyricFonts) {
        builder.element('lyric-font', nest: lyricFont.toXml());
      }
      for (var lyricLanguage in lyricLanguages) {
        builder.element('lyric-language', nest: lyricLanguage.toXml());
      }
    });
    return builder.buildDocument().rootElement;
  }
}

/// General graphical settings for the music's final form appearance on a printed page of display.
///
/// This includes support for line widths, definitions for note sizes,
/// and standard distances between notation elements,
/// plus an extension element for other aspects of appearance.
class Appearance {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

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

/// The line-width type indicates the width of a line type in tenths.
///
/// The type attribute defines what type of line is being defined.
/// Values include beam, bracket, dashes, enclosure, ending, extend,
/// heavy barline, leger, light barline, octave shift, pedal, slur middle,
/// slur tip, staff, stem, tie middle, tie tip, tuplet bracket, and wedge.
class LineWidth {
  /// The type of line whose width is being defined.
  String type;

  /// Converted type to enum. If [standardType] is null,
  /// that means it is other application-specific type.
  LineWidthType? get standardType => LineWidthType.fromString(type);

  /// Width of a specific line type in tenths
  double value;

  LineWidth({
    required this.type,
    required this.value,
  });

  factory LineWidth.fromXml(XmlElement xmlElement) {
    if (xmlElement.childElements.isNotEmpty) {
      throw XmlElementContentException(
        message: "'line-width' element must have tenths type content",
        xmlElement: xmlElement,
      );
    }

    double? value = double.tryParse(xmlElement.innerText);
    if (value == null) {
      throw MusicXmlFormatException(
        message: "'line-width' value is not tenths type",
        xmlElement: xmlElement,
        source: xmlElement.innerText,
      );
    }

    String? typeAttribute = xmlElement.getAttribute("type");

    if (typeAttribute == null) {
      throw MissingXmlAttribute(
        message: "'type' attribute is required for 'line-width' element",
        xmlElement: xmlElement,
      );
    }

    return LineWidth(
      value: value,
      type: typeAttribute,
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

enum LineWidthType {
  beam,
  bracket,
  dashes,
  enclosure,
  ending,
  extend,
  heavyBarline,
  leger,
  lightBarline,
  octaveShift,
  pedal,
  slurMiddle,
  slurTip,
  staff,
  stem,
  tieMiddle,
  tieTip,
  tupletBracket,
  wedge;

  static LineWidthType? fromString(String value) {
    return LineWidthType.values.firstWhereOrNull(
      (v) => v.name == sentenceCaseToCamelCase(value),
    );
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

/// Margins, page sizes, and distances are all measured in tenths to keep MusicXML data in a consistent coordinate system as much as possible.
///
/// The translation to absolute units is done with the scaling type, which specifies how many millimeters are equal to how many tenths.
///
/// For a staff height of 7 mm, millimeters would be set to 7 while tenths is set to 40.
///
/// The ability to set a formula rather than a single scaling factor helps avoid roundoff errors.
class Scaling {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

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

  static const Map<String, XmlQuantifier> _xmlExpectedOrder = {
    'millimeters': XmlQuantifier.required,
    'tenths': XmlQuantifier.required,
  };

  factory Scaling.fromXml(XmlElement xmlElement) {
    validateSequence(xmlElement, _xmlExpectedOrder);

    XmlElement? millimetersElement = xmlElement.getElement('millimeters');
    if (millimetersElement == null ||
        millimetersElement.childElements.isNotEmpty) {
      throw XmlElementContentException(
        message:
            "'scaling' element must have 'millimeters' element with decimal type value content",
        xmlElement: xmlElement,
      );
    }
    String? rawMillimeters = millimetersElement.innerText;
    double? millimeters = double.tryParse(rawMillimeters);
    if (millimeters == null) {
      throw MusicXmlFormatException(
        message: "$rawMillimeters is not 'millimeters' type",
        xmlElement: xmlElement,
        source: rawMillimeters,
      );
    }

    XmlElement? tenthsElement = xmlElement.getElement('tenths');
    if (tenthsElement == null || tenthsElement.childElements.isNotEmpty) {
      throw XmlElementContentException(
        message: "'tenths' element must have tenths type content",
        xmlElement: xmlElement,
      );
    }
    String? rawTenths = tenthsElement.innerText;
    double? tenths = double.tryParse(rawTenths);
    if (tenths == null) {
      throw MusicXmlFormatException(
        message: "$rawTenths is not 'tenths' type",
        xmlElement: xmlElement,
        source: rawTenths,
      );
    }

    return Scaling(
      millimeters: millimeters,
      tenths: tenths,
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

/// Specifies the default font for a particular name and number of lyric.
class LyricsFont extends Font {
  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// The lyric name for which this is the default, corresponding
  /// to the name attribute in the <lyric> element.
  String? number;

  /// The lyric number for which this is the default,
  /// corresponding to the number attribute in the <lyric> element.
  String? name;

  LyricsFont({
    super.style,
    super.size,
    super.weight,
    super.family,
    required this.number,
    required this.name,
  });

  factory LyricsFont.fromXml(XmlElement element) {
    // TODO check
    if (element.name.local != 'lyric-font') {
      throw FormatException("Unexpected element name: ${element.name.local}");
    }

    final lang = element.getAttribute('xml:lang');
    if (lang == null) {
      throw const FormatException('Missing required attribute "xml:lang"');
    }

    Font? font = Font.fromXml(element);

    return LyricsFont(
      number: element.getAttribute('number'),
      name: element.getAttribute('name'),
      style: font.style,
      size: font.size,
      weight: font.weight,
      family: font.family,
    );
  }

  XmlElement toXml() {
    final builder = XmlBuilder();
    builder.element('lyric-font', attributes: {
      if (number != null) 'number': number!,
      if (name != null) 'name': name!,
      // 'font': font?.toXml()
    });
    return builder.buildDocument().rootElement;
  }
}

/// Specifies the default language for a particular name and number of lyric.
class LyricLanguage {
  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// The default language for the specified lyric name and number.
  final String lang;

  /// The lyric name for which this is the default,
  /// corresponding to the name attribute in the <lyric> element
  final String? name;

  /// The lyric number for which this is the default,
  /// corresponding to the number attribute in the <lyric> element.
  final String? number;

  LyricLanguage({
    this.number,
    this.name,
    required this.lang,
  });

  factory LyricLanguage.fromXml(XmlElement element) {
    if (element.name.local != 'lyric-language') {
      throw XmlElementContentException(
        message: "Unexpected element name: ${element.name.local}",
        xmlElement: element,
      );
    }

    final lang = element.getAttribute('xml:lang');
    if (lang == null) {
      throw MissingXmlAttribute(
        message: 'Missing required attribute "xml:lang"',
        xmlElement: element,
      );
    }

    return LyricLanguage(
      number: element.getAttribute('number'),
      name: element.getAttribute('name'),
      lang: lang,
    );
  }

  XmlElement toXml() {
    final builder = XmlBuilder();
    builder.element('lyric-language', attributes: {
      if (number != null) 'number': number!,
      if (name != null) 'name': name!,
      'xml:lang': lang
    });
    return builder.buildDocument().rootElement;
  }

  @override
  String toString() =>
      'LyricLanguage(number: $number, name: $name, lang: $lang)';
}
