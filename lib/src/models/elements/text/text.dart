import 'package:collection/collection.dart';
import 'package:music_notation/src/models/data_types/accidental_value.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/generic.dart';
import 'package:music_notation/src/models/utilities/common_attributes.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/printing.dart';

abstract class TextElementBase {}

/// The [FormattedText] type represents a text element with [TextFormatting] attributes.
class FormattedText extends TextElementBase {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  String value;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// For definition, look at [TextFormatting].
  TextFormatting formatting;

  FormattedText({
    required this.value,
    required this.formatting,
  });

  factory FormattedText.fromXml(XmlElement xmlElement) {
    // Content parsing:
    if (xmlElement.children.length != 1 ||
        xmlElement.children.first.nodeType != XmlNodeType.TEXT) {
      throw InvalidXmlElementException(
        message:
            "Formatted text element should contain only one children - text",
        xmlElement: xmlElement,
      );
    }

    return FormattedText(
      value: xmlElement.children.first.value!,
      formatting: TextFormatting.fromXml(xmlElement),
    );
  }
}

/// The [AccidentalText] type represents an element with an accidental value and [TextFormatting] attributes.
class AccidentalText extends TextElementBase {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  AccidentalValue value;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Specifies the exact Standard Music Font Layout (SMuFL) accidental character,
  /// using its SMuFL canonical glyph name.
  String? smufl;

  /// For definition, look at [TextFormatting].
  TextFormatting formatting;

  AccidentalText({
    required this.value,
    required this.smufl,
    required this.formatting,
  });

  factory AccidentalText.fromXml(XmlElement xmlElement) {
    return AccidentalText(
      value: AccidentalValue.fromXml(xmlElement),
      smufl: AccidentalSmuflGlyphName.fromXml(xmlElement),
      formatting: TextFormatting.fromXml(xmlElement),
    );
  }
}

/// The [TextFormatting] collects the common formatting attributes for text elements.
/// Default values may differ across the elements that use this group.
class TextFormatting {
  /// The justify attribute is used to indicate left, center, or right justification.
  ///
  /// The default value varies for different elements.
  ///
  /// For elements where the justify attribute is present but the halign attribute is not,
  /// the justify attribute indicates horizontal alignment as well as justification.
  HorizontalAlignment? justify;

  /// For definition, look at: [PrintStyleAlign].
  PrintStyleAlign? printStyleAlign;

  /// For definition, look at: [TextDecoration].
  TextDecoration? textDecoration;

  /// Used to rotate text around the alignment point specified by the halign and valign attributes.
  ///
  /// Positive values are clockwise rotations, while negative values are counter-clockwise rotations.
  double? textRotation;

  /// The letter-spacing attribute specifies text tracking.
  ///
  /// Values are either "normal" or a number representing the number of ems to add between each letter.
  ///
  /// The number may be negative in order to subtract space.
  ///
  /// The default is normal, which allows flexibility of letter-spacing for purposes of text justification.
  ///
  /// Null value means normal.
  double? letterSpacing;

  /// The line-height attribute specifies text leading.
  ///
  /// Values are either "normal" or a number representing the percentage of the current font height to use for leading.
  ///
  /// The default is "normal".
  ///
  /// The exact normal value is implementation-dependent, but values between 100 and 120 are recommended.
  ///
  /// Null value means normal.
  double? lineHeight;

  /// Specifies the language used in the element content.
  ///
  /// It is Italian ("it") if not specified.
  String? lang;

  ///Indicates whether white space should be preserved by applications.
  XmlSpace? space;

  /// The text-direction attribute is used to adjust and
  /// override the Unicode bidirectional text algorithm,
  /// similar to the Directionality data category in the
  /// [W3C Internationalization Tag Set recommendation](https://www.w3.org/TR/2007/REC-its-20070403/#directionality).
  ///
  /// The default value is ltr. This attribute is typically used by applications
  /// that store text in left-to-right visual order rather than logical order.
  ///
  /// Such applications can use the lro value to better communicate
  /// with other applications that more fully support bidirectional text.
  TextDirection? textDirection;

  /// The enclosure attribute group is used to specify
  /// the formatting of an enclosure around text or symbols.
  EnclosureShape? enclosure;

  TextFormatting({
    this.justify,
    this.printStyleAlign,
    this.textDecoration,
    this.textRotation,
    this.letterSpacing,
    this.lineHeight,
    this.lang = "it",
    this.space,
    this.textDirection = TextDirection.ltr,
    this.enclosure,
  });

  factory TextFormatting.fromXml(XmlElement xmlElement) {
    return TextFormatting(
      justify: HorizontalAlignment.fromXml(xmlElement),
      printStyleAlign: PrintStyleAlign.fromXml(xmlElement),
      textDecoration: TextDecoration.fromXml(xmlElement),
      textRotation: RotationDegrees.fromXml(xmlElement),
      letterSpacing: NumberOrNormal.fromXml(
        xmlElement,
        CommonAttributes.letterSpacing,
      ),
      lineHeight: NumberOrNormal.fromXml(
        xmlElement,
        CommonAttributes.lineHeight,
      ),
      lang: xmlElement.getAttribute('xml:lang'),
      space: XmlSpace.fromXml(xmlElement),
      textDirection: TextDirection.fromXml(xmlElement),
      enclosure: EnclosureShape.fromXml(xmlElement),
    );
  }

  Iterable<XmlAttribute> toXml() {
    return [];
  }
}

/// The text-direction type is used to adjust and override the Unicode bidirectional text algorithm, similar to the Directionality data category in the W3C Internationalization Tag Set recommendation.
/// Values:
///   - ltr (left-to-right embed);
///   - rtl (right-to-left embed);
///   - lro (left-to-right bidi-override);
///   - rlo (right-to-left bidi-override).
///
/// The default value is ltr.
///
/// This type is typically used by applications that store text in left-to-right visual order rather than logical order.
///
/// Such applications can use the lro value to better communicate with other applications that more fully support bidirectional text.
enum TextDirection {
  ltr,
  rtl,
  lro,
  rlo;

  static TextDirection? fromString(String value) {
    return TextDirection.values.firstWhereOrNull(
      (element) => element.name == value,
    );
  }

  static TextDirection? fromXml(XmlElement xmlElement) {
    String? rawValue = xmlElement.getAttribute(CommonAttributes.textDirection);
    TextDirection? value = fromString(
      rawValue ?? "",
    );
    if (rawValue != null && value == null) {
      throw InvalidMusicXmlType(
        message: generateValidationError(
          CommonAttributes.justify,
          rawValue,
        ),
        xmlElement: xmlElement,
      );
    }
    return value;
  }

  static String generateValidationError(String attributeName, String value) =>
      "Attribute '$attributeName' is not a text-direction value: $value";
}

/// The number-of-lines type is used to specify the number of lines in text decoration attributes.
enum NumberOfLines {
  none(0),
  one(1),
  two(2),
  three(3);

  const NumberOfLines(this.value);

  final int value;

  static NumberOfLines fromInt(int value) {
    switch (value) {
      case 0:
        return NumberOfLines.none;
      case 1:
        return NumberOfLines.one;
      case 2:
        return NumberOfLines.two;
      case 3:
        return NumberOfLines.three;
      default:
        // TODO: better exception
        throw "Invalid number of lines: $value";
    }
  }
}

/// The text-decoration attribute group is based on the similar feature in XHTML and CSS.
///
/// It allows for text to be underlined, overlined, or struck-through.
///
/// It extends the CSS version by allow double or triple lines instead of just being on or off.
class TextDecoration {
  NumberOfLines? underline;
  NumberOfLines? overline;
  NumberOfLines? lineThrough;

  TextDecoration({
    this.underline,
    this.overline,
    this.lineThrough,
  });

  factory TextDecoration.fromXml(XmlElement xmlElement) {
    var underline =
        int.tryParse(xmlElement.getAttribute('underline') ?? "0") ?? 0;
    var overline =
        int.tryParse(xmlElement.getAttribute('overline') ?? "0") ?? 0;
    var lineThrough =
        int.tryParse(xmlElement.getAttribute('line-through') ?? "0") ?? 0;

    return TextDecoration(
      underline: NumberOfLines.fromInt(underline),
      overline: NumberOfLines.fromInt(overline),
      lineThrough: NumberOfLines.fromInt(lineThrough),
    );
  }
}

/// The left-center-right type is used to define horizontal alignment and text justification.
enum HorizontalAlignment {
  left,
  center,
  right;

  static HorizontalAlignment? fromString(String value) {
    return HorizontalAlignment.values.singleWhereOrNull(
      (element) => element.name == value,
    );
  }

  static HorizontalAlignment? fromXml(XmlElement xmlElement) {
    String? rawJustify = xmlElement.getAttribute(CommonAttributes.justify);
    HorizontalAlignment? justify = HorizontalAlignment.fromString(
      rawJustify ?? "",
    );
    if (rawJustify != null && justify == null) {
      throw InvalidMusicXmlType(
        message: generateValidationError(
          CommonAttributes.justify,
          rawJustify,
        ),
        xmlElement: xmlElement,
      );
    }
    return justify;
  }

  /// Generates a validation error message for an invalid [HorizontalAlignment] value.
  ///
  /// Parameters:
  ///   - attributeName: The name of the attribute.
  ///   - value: The value that caused the validation error.
  ///
  /// Returns a validation error message indicating that the attribute is not a valid yes-no value.
  static String generateValidationError(String attributeName, String value) =>
      "Attribute '$attributeName' is not a horizontal-alignment value: $value";
}

/// The enclosure-shape type describes the shape and
/// presence/absence of an enclosure around text or symbols.
///
/// A bracket enclosure is similar to a rectangle
/// with the bottom line missing, as is common in jazz notation.
///
/// An inverted-bracket enclosure is similar to a rectangle with the top line missing.
enum EnclosureShape {
  rectangle,
  square,
  oval,
  circle,
  bracket,
  invertedBracket,
  triangle,
  diamond,
  pentagon,
  hexagon,
  heptagon,
  octagon,
  nonagon,
  decagon,
  none;

  static EnclosureShape? fromString(String value) {
    return EnclosureShape.values.firstWhereOrNull(
      (e) => e.name.toString() == value,
    );
  }

  static EnclosureShape? fromXml(XmlElement xmlElement) {
    String? rawValue = xmlElement.getAttribute(CommonAttributes.enclosureShape);
    EnclosureShape? value = fromString(
      rawValue ?? "",
    );
    if (rawValue != null && value == null) {
      throw InvalidMusicXmlType(
        message: generateValidationError(
          CommonAttributes.enclosureShape,
          rawValue,
        ),
        xmlElement: xmlElement,
      );
    }
    return value;
  }

  static String generateValidationError(String attributeName, String value) =>
      "Attribute '$attributeName' is not a enclosure-shape value: $value";
}

/// The valign type is used to indicate vertical alignment to the top, middle, bottom, or baseline of the text.
///
/// If the text is on multiple lines, baseline alignment refers to the baseline of the lowest line of text.
///
/// Defaults are implementation-dependent.
enum VerticalAlignment {
  top,
  middle,
  bottom,
  baseline;

  static VerticalAlignment fromString(String value) {
    for (var element in VerticalAlignment.values) {
      if (element.name.contains(value)) return element;
    }
    // TODO: better exception
    throw "Invalid VerticalAlignment value: $value";
  }
}

/// The font attribute group gathers together attributes for determining the font within a credit or direction.
///
/// They are based on the text styles for Cascading Style Sheets.
///
/// The font-family is a comma-separated list of font names.The font-style can be normal or italic.
///
/// The font-size can be one of the CSS sizes or a numeric point size.
///
/// The font-weight can be normal or bold.
///
/// The default is application-dependent, but is a text font vs. a music font.
class Font {
  /// The font-family is a comma-separated list of font names.
  ///
  /// These can be specific font styles such as Maestro or Opus, or one of several generic font styles: music, engraved, handwritten, text, serif, sans-serif, handwritten, cursive, fantasy, and monospace.
  ///
  /// The music, engraved, and handwritten values refer to music fonts; the rest refer to text fonts.
  ///
  /// The fantasy style refers to decorative text such as found in older German-style printing.
  ///
  // TODO: nullable or not?
  // TOOD: Remove "font" word from properties.
  final String? family;

  /// Normal or italic style.
  final FontStyle? style;

  /// One of the CSS sizes or a numeric point size.
  final FontSize? size;

  /// Normal or bold weight.
  final FontWeight? weight;

  Font({
    this.style,
    this.size,
    this.weight,
    this.family,
  });

  const Font.empty()
      : family = null,
        style = null,
        size = null,
        weight = null;

  factory Font.fromXml(XmlElement xmlElement) {
    // TODO: fully parse
    return Font(
      family: xmlElement.getAttribute('font-family'),
    );
  }

  toXml() {
    // TODO
  }
}

/// The font-style type represents a simplified version of the CSS font-style property.
enum FontStyle {
  normal,
  italic;
}

/// The font-weight type represents a simplified version of the CSS font-weight property.
enum FontWeight {
  normal,
  bold;
}

/// The css-font-size type includes the CSS font sizes used as an alternative to a numeric point size.
enum CssFontSize {
  xxSmall,
  xSmall,
  small,
  medium,
  large,
  xLarge,
  xxLarge;
}

/// The font-size can be one of the CSS font sizes (xx-small, x-small, small, medium, large, x-large, xx-large) or a numeric point size.
class FontSize {
  final double? numericValue;
  final CssFontSize? cssFontValue;

  dynamic get getValue => numericValue ?? cssFontValue;

  FontSize.fromDouble({this.numericValue}) : cssFontValue = null;
  FontSize.fromEnum({this.cssFontValue}) : numericValue = null;

  factory FontSize.dynamic({
    double? numericValue,
    CssFontSize? cssFontValue,
  }) {
    if (numericValue == null && cssFontValue == null) {
      // TOOD
      throw "Bla";
    }
    if (numericValue != null && cssFontValue != null) {
      // TODO
      throw "Bla";
    }
    if (numericValue != null) {
      return FontSize.fromEnum(cssFontValue: cssFontValue);
    }
    return FontSize.fromDouble(numericValue: numericValue);
  }
}
// <xs:simpleType name="font-size">
// 	<xs:annotation>
// 		<xs:documentation>The font-size can be one of the CSS font sizes (xx-small, x-small, small, medium, large, x-large, xx-large) or a numeric point size.</xs:documentation>
// 	</xs:annotation>
// 	<xs:union memberTypes="xs:decimal css-font-size"/>
// </xs:simpleType>

/// The color type indicates the color of an element.
///
/// Color may be represented as hexadecimal RGB triples, as in HTML, or as hexadecimal ARGB tuples, with the A indicating alpha of transparency.
/// An alpha value of 00 is totally transparent; FF is totally opaque.
/// If RGB is used, the A value is assumed to be FF.
///
/// For instance, the RGB value "#800080" represents purple. An ARGB value of "#40800080" would be a transparent purple.

/// As in SVG 1.1, colors are defined in terms of the sRGB color space (IEC 61966).
class Color {
  final String? value;

  Color({this.value});

  const Color.empty() : value = null;

  factory Color.fromXml(XmlElement xmlElement) {
    String? colorValue = xmlElement.getAttribute('color');
    if (colorValue != null) {
      // Verify the color value format with a regex pattern
      bool isValid =
          RegExp(r'^#[\dA-F]{6}([\dA-F][\dA-F])?$').hasMatch(colorValue);
      if (!isValid) {
        /// TODO exception
        throw Exception("Invalid color value: $colorValue");
      }
    }
    return Color(value: colorValue);
  }
}

/// The lyric-font type specifies the default font for a particular name and number of lyric.
class LyricsFont {
  // type="xs:NMTOKEN"
  String? number;
  String? name;
  Font? font;

  LyricsFont({
    required this.number,
    required this.name,
    required this.font,
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

    XmlElement? fontElement = element.getElement("font")?.firstElementChild;

    return LyricsFont(
      number: element.getAttribute('number'),
      name: element.getAttribute('name'),
      font: fontElement != null ? Font.fromXml(fontElement) : null,
    );
  }

  XmlElement toXml() {
    final builder = XmlBuilder();
    builder.element('lyric-font', attributes: {
      if (number != null) 'number': number!,
      if (name != null) 'name': name!,
      'font': font?.toXml()
    });
    return builder.buildDocument().rootElement;
  }
}

/// The lyric-language type specifies the default language for a particular name and number of lyric.
class LyricLanguage {
  // type="xs:NMTOKEN"
  final String? number;
  final String? name;
  final String lang;

  LyricLanguage({this.number, this.name, required this.lang});

  factory LyricLanguage.fromXml(XmlElement element) {
    if (element.name.local != 'lyric-language') {
      throw FormatException("Unexpected element name: ${element.name.local}");
    }

    final lang = element.getAttribute('xml:lang');
    if (lang == null) {
      throw FormatException('Missing required attribute "xml:lang"');
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

/// The formatted-text-id type represents a text element with text-formatting and id attributes.
class FormattedTextId {
  final String content;
  final TextFormatting textFormatting;
  final String? id;

  FormattedTextId({
    required this.content,
    required this.textFormatting,
    required this.id,
  });

  factory FormattedTextId.fromXml(XmlElement xmlElement) {
    return FormattedTextId(
      content: xmlElement.value ?? "",
      textFormatting: TextFormatting.fromXml(xmlElement),
      id: xmlElement.getAttribute('id'),
    );
  }

  XmlElement toXml() {
    List<XmlAttribute> attributes = [];

    attributes.addAll(textFormatting.toXml());

    if (id != null) {
      attributes.add(XmlAttribute(XmlName('optional-unique-id'), id!));
    }

    return XmlElement(
      XmlName('formatted-text-id'),
      attributes,
      [XmlText(content)],
    );
  }
}

/// The formatted-symbol-id type represents a SMuFL musical symbol element with formatting and id attributes.
class FormattedSymbolId {
  /// Type="xs:NMTOKEN"
  /// TODO: validate
  final String content;
  final String symbolFormatting;
  final String id;

  FormattedSymbolId({
    required this.content,
    required this.symbolFormatting,
    required this.id,
  });

  factory FormattedSymbolId.fromXml(XmlElement xmlElement) {
    return FormattedSymbolId(
      content: xmlElement.text,
      symbolFormatting: xmlElement.getAttribute('symbol-formatting') ?? '',
      id: xmlElement.getAttribute('optional-unique-id') ?? '',
    );
  }

  XmlElement toXml() {
    return XmlElement(
      XmlName('formatted-symbol-id'),
      [
        XmlAttribute(XmlName('symbol-formatting'), symbolFormatting),
        XmlAttribute(XmlName('id'), id),
      ],
      [XmlText(content)],
    );
  }
}
