import 'package:collection/collection.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/src/models/data_types/accidental_value.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/generic.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/utilities/common_attributes.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';

abstract class TextElementBase {}

/// Represents a text element with [TextFormatting] attributes.
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
      throw XmlElementContentException(
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

/// Represents an element with an accidental value and [TextFormatting] attributes.
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

/// The common formatting attributes for text elements.
/// Default values may differ across the elements that use this group.
class TextFormatting extends PrintStyleAlign {
  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Indicates left, center, or right justification.
  ///
  /// The default value varies for different elements.
  ///
  /// For elements where the justify attribute is present but the halign attribute is not,
  /// the justify attribute indicates horizontal alignment as well as justification.
  HorizontalAlignment? justify;

  /// For definition, look at: [TextDecoration].
  TextDecoration textDecoration;

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

  /// Attribute that is used to adjust and override the Unicode bidirectional text algorithm,
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
    // this.printStyleAlign,
    required this.textDecoration,
    this.textRotation,
    this.letterSpacing,
    this.lineHeight,
    this.lang = "it",
    this.space,
    this.textDirection = TextDirection.ltr,
    this.enclosure,
    required super.horizontalAlignment,
    required super.verticalAlignment,
    required super.position,
    required super.font,
    required super.color,
  });

  factory TextFormatting.fromXml(XmlElement xmlElement) {
    PrintStyleAlign printStyleAlign = PrintStyleAlign.fromXml(xmlElement);

    return TextFormatting(
      justify: HorizontalAlignment.fromXml(xmlElement),
      horizontalAlignment: printStyleAlign.horizontalAlignment,
      verticalAlignment: printStyleAlign.verticalAlignment,
      position: printStyleAlign.position,
      font: printStyleAlign.font,
      color: printStyleAlign.color,
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

/// Type that is used to adjust and override the Unicode bidirectional text
/// algorithm, similar to the Directionality data category in the W3C
/// Internationalization Tag Set recommendation.
///
/// The default value is ltr.
///
/// This type is typically used by applications that store text in left-to-right
/// visual order rather than logical order. Such applications can use the lro
/// value to better communicate with other applications that more fully support\
/// bidirectional text.
enum TextDirection {
  /// left-to-right embed.
  ltr,

  /// right-to-left embed.
  rtl,

  /// left-to-right bidi-override
  lro,

  /// right-to-left bidi-override
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
      throw MusicXmlFormatException(
        message: generateValidationError(
          CommonAttributes.justify,
          rawValue,
        ),
        xmlElement: xmlElement,
        source: rawValue,
      );
    }
    return value;
  }

  static String generateValidationError(String attributeName, String value) =>
      "Attribute '$attributeName' is not a text-direction value: $value";
}

/// Represents the number of lines used for text decoration in MusicXML.
///
/// It allows for up to three lines of text decoration, or none at all.
enum NumberOfLines {
  none(0),
  one(1),
  two(2),
  three(3);

  const NumberOfLines(this.value);

  final int value;

  /// Converts provided string value to [NumberOfLines].
  /// Returns `null` if the value is not a valid representation of [NumberOfLines].
  static NumberOfLines? fromString(String value) {
    switch (value) {
      case "0":
        return NumberOfLines.none;
      case "1":
        return NumberOfLines.one;
      case "2":
        return NumberOfLines.two;
      case "3":
        return NumberOfLines.three;
      default:
        return null;
    }
  }

  /// Constructs a [NumberOfLines] from a [XmlElement] and an [attribute].
  /// If the attribute is not a valid representation of [NumberOfLines],
  /// a [MusicXmlTypeException] is thrown.
  static NumberOfLines fromXml(XmlElement xmlElement, String attribute) {
    var rawNumberOfLines = xmlElement.getAttribute(attribute);
    if (rawNumberOfLines == null) {
      return NumberOfLines.none;
    }

    var numberOfLines = NumberOfLines.fromString(rawNumberOfLines);
    if (numberOfLines == null) {
      throw MusicXmlTypeException(
        message: "$attribute attribute is not valid number of lines",
        xmlElement: xmlElement,
      );
    }
    return numberOfLines;
  }
}

/// The number of lines in text decoration attributes.
///
/// A TextDecoration element is used to decorate text by underlining, overlining,
/// or striking through. It can use single, double, or triple lines, extending
/// the capabilities of similar features found in XHTML and CSS.
///
/// Example:
///
/// ```dart
/// TextDecoration(
///   underline: NumberOfLines.two,
///   overline: NumberOfLines.none,
///   lineThrough: NumberOfLines.one,
/// );
/// ```
class TextDecoration {
  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// The number of lines to use when underlining text.
  /// This is represented by a [NumberOfLines] instance.
  /// Defaults to [NumberOfLines.none] if not specified.
  final NumberOfLines underline;

  /// The number of lines to use when overlining text.
  /// This is represented by a [NumberOfLines] instance.
  /// Defaults to [NumberOfLines.none] if not specified.
  final NumberOfLines overline;

  /// The number of lines to use when striking through text.
  /// This is represented by a [NumberOfLines] instance.
  /// Defaults to [NumberOfLines.none] if not specified.
  final NumberOfLines lineThrough;

  const TextDecoration({
    this.underline = NumberOfLines.none,
    this.overline = NumberOfLines.none,
    this.lineThrough = NumberOfLines.none,
  });

  const TextDecoration.empty()
      : underline = NumberOfLines.none,
        overline = NumberOfLines.none,
        lineThrough = NumberOfLines.none;

  /// Builds the [TextDecoration] class instance from the provided [XmlElement]
  /// attributes. It will throw a [MusicXmlTypeException] if invalid content is provided.
  factory TextDecoration.fromXml(XmlElement xmlElement) {
    return TextDecoration(
      underline: NumberOfLines.fromXml(
        xmlElement,
        CommonAttributes.underline,
      ),
      overline: NumberOfLines.fromXml(
        xmlElement,
        CommonAttributes.overline,
      ),
      lineThrough: NumberOfLines.fromXml(
        xmlElement,
        CommonAttributes.lineThrough,
      ),
    );
  }

  TextDecoration copyWith({
    NumberOfLines? underline,
    NumberOfLines? overline,
    NumberOfLines? lineThrough,
  }) {
    return TextDecoration(
      underline: underline ?? this.underline,
      overline: overline ?? this.overline,
      lineThrough: lineThrough ?? this.lineThrough,
    );
  }
}

/// Type that is used to define horizontal alignment and text justification.
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
      throw MusicXmlFormatException(
        message: generateValidationError(
          CommonAttributes.justify,
          rawJustify,
        ),
        xmlElement: xmlElement,
        source: rawJustify,
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

/// Type that describes the shape and presence/absence of an enclosure around text or symbols.
///
/// A [bracket] enclosure is similar to a [rectangle]
/// with the bottom line missing, as is common in jazz notation.
///
/// An [invertedBracket] enclosure is similar to a [rectangle] with the top line missing.
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
      throw MusicXmlFormatException(
        message: generateValidationError(
          CommonAttributes.enclosureShape,
          rawValue,
        ),
        xmlElement: xmlElement,
        source: rawValue,
      );
    }
    return value;
  }

  static String generateValidationError(String attributeName, String value) =>
      "Attribute '$attributeName' is not a enclosure-shape value: $value";
}

/// Type that is used to indicate vertical alignment to the top, middle, bottom, or baseline of the text.
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

/// Group that gathers together attributes for determining the font within a credit or direction.
///
/// They are based on the text styles for Cascading Style Sheets.
///
/// The default is application-dependent, but is a text font vs. a music font.
class Font {
  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// The font-family is a comma-separated list of font names.
  ///
  /// These can be specific font styles such as Maestro or Opus,
  /// or one of several generic font styles: music, engraved, handwritten,
  /// text, serif, sans-serif, handwritten, cursive, fantasy, and monospace.
  ///
  /// The music, engraved, and handwritten values refer to music fonts; the rest refer to text fonts.
  /// The fantasy style refers to decorative text such as found in older German-style printing.
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
    String? rawSize = xmlElement.getAttribute('font-size');
    FontSize? fontSize;
    if (rawSize != null) {
      try {
        fontSize = FontSize.fromString(rawSize);
      } catch (e) {
        throw MusicXmlFormatException(
          message: "Font size must be double or CssFontSize",
          xmlElement: xmlElement,
          source: rawSize,
        );
      }
    }

    String? rawFontStyle = xmlElement.getAttribute('font-style');
    FontStyle? fontStyle = FontStyle.fromString(rawFontStyle ?? '');
    if (rawFontStyle != null && fontStyle == null) {
      throw MusicXmlFormatException(
        message: "Font style must be normal or italic",
        xmlElement: xmlElement,
        source: rawFontStyle,
      );
    }

    String? rawFontWeight = xmlElement.getAttribute('font-weight');
    FontWeight? fontWeight = FontWeight.fromString(rawFontWeight ?? '');
    if (rawFontWeight != null && fontWeight == null) {
      throw MusicXmlFormatException(
        message: "Font weight must be normal or bold",
        xmlElement: xmlElement,
        source: rawFontWeight,
      );
    }
    return Font(
      // TODO validate if it comma-seperated-text.
      family: xmlElement.getAttribute('font-family'),
      size: fontSize,
      style: fontStyle,
      weight: fontWeight,
    );
  }

  /// TODO: finish and test
  toXml() {}
}

/// Type that represents a simplified version of the CSS font-style property.
enum FontStyle {
  normal,
  italic;

  /// Parses a string and returns the corresponding [FontStyle] value.
  ///
  /// Returns null if the string does not match any of the valid [FontStyle] values.
  static FontStyle? fromString(String value) {
    switch (value) {
      case 'normal':
        return FontStyle.normal;
      case 'italic':
        return FontStyle.italic;
      default:
        return null;
    }
  }
}

/// Type that represents a simplified version of the CSS font-weight property.
enum FontWeight {
  normal,
  bold;

  /// Parses a string and returns the corresponding [FontWeight] value.
  ///
  /// Returns null if the string does not match any of the valid [FontWeight] values.
  static FontWeight? fromString(String value) {
    switch (value) {
      case 'normal':
        return FontWeight.normal;
      case 'bold':
        return FontWeight.bold;
      default:
        return null;
    }
  }
}

/// Type that includes the CSS font sizes used as an alternative to a numeric point size.
enum CssFontSize {
  xxSmall,
  xSmall,
  small,
  medium,
  large,
  xLarge,
  xxLarge;

  /// Parses a string and returns the corresponding [CssFontSize] value.
  ///
  /// Returns null if the string does not match any of the valid [CssFontSize] values.
  static CssFontSize? fromString(String value) {
    switch (value) {
      case 'xx-small':
        return CssFontSize.xxSmall;
      case 'x-small':
        return CssFontSize.xSmall;
      case 'small':
        return CssFontSize.small;
      case 'medium':
        return CssFontSize.medium;
      case 'large':
        return CssFontSize.large;
      case 'x-large':
        return CssFontSize.xLarge;
      case 'xx-large':
        return CssFontSize.xxLarge;
      default:
        return null;
    }
  }
}

/// Type that can be one of the CSS font sizes (xx-small, x-small, small, medium, large, x-large, xx-large)
/// or a numeric point size.
class FontSize {
  final double? numericValue;
  final CssFontSize? cssFontValue;

  dynamic get getValue => numericValue ?? cssFontValue;

  FontSize.fromDouble(this.numericValue) : cssFontValue = null;
  FontSize.fromCssSize(this.cssFontValue) : numericValue = null;

  factory FontSize.fromString(String value) {
    double? maybeNumeric = double.tryParse(value);

    if (maybeNumeric != null) {
      return FontSize.fromDouble(maybeNumeric);
    }

    CssFontSize? maybeCssSize = CssFontSize.fromString(value);

    if (maybeCssSize != null) {
      return FontSize.fromCssSize(maybeCssSize);
    }
    throw ArgumentError("Provided argument must be double or CssFontSize");
  }
}

/// Indicates the color of an element.
///
/// Color may be represented as hexadecimal RGB triples, as in HTML,
/// or as hexadecimal ARGB tuples, with the A indicating alpha of transparency.
/// An alpha value of 00 is totally transparent; FF is totally opaque.
/// If RGB is used, the A value is assumed to be FF.
///
/// For instance, the RGB value "#800080" represents purple. An ARGB value of "#40800080" would be a transparent purple.
///
/// As in SVG 1.1, colors are defined in terms of the sRGB color space (IEC 61966).
class Color {
  final String? value;

  static const _colorRegex = r'^#[\dA-F]{6}([\dA-F][\dA-F])?$';

  Color({this.value});

  const Color.empty() : value = null;

  factory Color.fromXml(XmlElement xmlElement) {
    String? colorValue = xmlElement.getAttribute('color');
    // Verify the color value format with a regex pattern
    if (colorValue != null && !RegExp(_colorRegex).hasMatch(colorValue)) {
      throw MusicXmlFormatException(
        message: "Invalid color value: $colorValue",
        xmlElement: xmlElement,
        source: colorValue,
      );
    }
    return Color(value: colorValue);
  }
}

/// Represents a text element with [formatting] and [id] attributes.
class FormattedTextId extends FormattedText {
  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Specifies an ID that is unique to the entire document.
  final String? id;

  FormattedTextId({
    required super.value,
    required super.formatting,
    required this.id,
  });

  factory FormattedTextId.fromXml(XmlElement xmlElement) {
    FormattedText formattedText = FormattedText.fromXml(xmlElement);

    return FormattedTextId(
      value: formattedText.value,
      formatting: formattedText.formatting,
      id: xmlElement.getAttribute('id'),
    );
  }

  XmlElement toXml() {
    List<XmlAttribute> attributes = [];

    attributes.addAll(formatting.toXml());

    if (id != null) {
      attributes.add(XmlAttribute(XmlName('optional-unique-id'), id!));
    }

    return XmlElement(
      XmlName('formatted-text-id'),
      attributes,
      [XmlText(value)],
    );
  }
}

/// Represents a SMuFL musical symbol element with [formatting] and [id] attributes.
class FormattedSymbolId {
  // smufl-glyph-name
  final String value;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  final SymbolFormatting formatting;
  final String id;

  FormattedSymbolId({
    required this.value,
    required this.formatting,
    required this.id,
  });

  factory FormattedSymbolId.fromXml(XmlElement xmlElement) {
    return FormattedSymbolId(
      value: xmlElement.text,
      formatting: SymbolFormatting.fromXml(xmlElement),
      id: xmlElement.getAttribute('optional-unique-id') ?? '',
    );
  }

  XmlElement toXml() {
    return XmlElement(
      XmlName('formatted-symbol-id'),
      [
        XmlAttribute(XmlName('symbol-formatting'), formatting.toXml()),
        XmlAttribute(XmlName('id'), id),
      ],
      [XmlText(value)],
    );
  }
}

/// attribute group collects the common formatting attributes for musical symbols.
///
/// Default values may differ across the elements that use this group.
class SymbolFormatting extends PrintStyleAlign {
  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// Indicates left, center, or right justification.
  ///
  /// The default value varies for different elements.
  ///
  /// For elements where the justify attribute is present but the halign attribute is not,
  /// the justify attribute indicates horizontal alignment as well as justification.
  final HorizontalAlignment? justify;

  /// For definition, look at: [TextDecoration].
  final TextDecoration textDecoration;

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

  /// Attribute that is used to adjust and override the Unicode bidirectional text algorithm,
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

  SymbolFormatting({
    this.justify,
    this.textDecoration = const TextDecoration.empty(),
    this.textRotation,
    this.letterSpacing,
    this.lineHeight,
    this.textDirection,
    this.enclosure,
    required super.horizontalAlignment,
    required super.verticalAlignment,
    required super.position,
    required super.font,
    required super.color,
  });

  String toXml() {
    throw UnimplementedError();
  }

  factory SymbolFormatting.fromXml(XmlElement xmlElement) {
    PrintStyleAlign printStyleAlign = PrintStyleAlign.fromXml(xmlElement);

    return SymbolFormatting(
      justify: HorizontalAlignment.fromXml(xmlElement),
      textRotation: RotationDegrees.fromXml(xmlElement),
      textDecoration: TextDecoration.fromXml(xmlElement),
      letterSpacing: NumberOrNormal.fromXml(
        xmlElement,
        CommonAttributes.letterSpacing,
      ),
      lineHeight: NumberOrNormal.fromXml(
        xmlElement,
        CommonAttributes.lineHeight,
      ),
      textDirection: TextDirection.fromXml(xmlElement),
      enclosure: EnclosureShape.fromXml(xmlElement),
      horizontalAlignment: printStyleAlign.horizontalAlignment,
      verticalAlignment: printStyleAlign.verticalAlignment,
      position: printStyleAlign.position,
      font: printStyleAlign.font,
      color: printStyleAlign.color,
    );
  }
}
