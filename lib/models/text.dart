import 'package:music_notation/models/generic.dart';
import 'package:music_notation/models/printing.dart';
import 'package:xml/xml.dart';

import 'package:music_notation/models/invalid_xml_element_exception.dart';

/// The formatted-text type represents a text element with text-formatting attributes
class FormattedText {
  String value;
  TextFormatting formatting;

  FormattedText({
    required this.value,
    required this.formatting,
  });

  factory FormattedText.fromXml(XmlElement xmlElement) {
    return FormattedText(
      value: xmlElement.text,
      formatting: TextFormatting.fromXml(xmlElement),
    );
  }
}

/// The text-formatting  collects the common formatting attributes for text elements.
/// Default values may differ across the elements that use this group.
class TextFormatting {
  /// The justify attribute is used to indicate left, center, or right justification.
  ///
  /// The default value varies for different elements.
  ///
  /// For elements where the justify attribute is present but the halign attribute is not, the justify attribute indicates horizontal alignment as well as justification.
  LeftCenterRight? justify;
  PrintStyleAlign? printStyleAlign;
  TextDecoration? textDecoration;
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
  // TODO: Check if null value is possible
  double? lineHeight;
  String? lang;
  String? space;
  TextDirection? textDirection;

  /// The enclosure attribute group is used to specify the formatting of an enclosure around text or symbols.
  EnclosureShape? enclosure;

  TextFormatting({
    this.justify,
    this.printStyleAlign,
    this.textDecoration,
    this.textRotation,
    this.letterSpacing,
    this.lineHeight,
    this.lang,
    this.space,
    this.textDirection,
    this.enclosure,
  });

  factory TextFormatting.fromXml(XmlElement xmlElement) {
    var rotation = double.tryParse(
      xmlElement.findElements('text-rotation').first.innerText,
    );

    var letterSpacing = double.tryParse(
      xmlElement.findElements('letter-spacing').first.innerText,
    );

    var lineHeight = double.tryParse(
      xmlElement.findElements('letter-spacing').first.innerText,
    );

    if (rotation == null || !RotationDegrees.validate(rotation)) {
      // adasdasdasdas
      throw "bad rotation";
    }

    return TextFormatting(
      justify: LeftCenterRight.fromString(xmlElement.text),
      printStyleAlign: PrintStyleAlign.fromXml(xmlElement),
      textDecoration: TextDecoration.fromXml(xmlElement),
      textRotation: rotation,
      letterSpacing: letterSpacing,
      lineHeight: lineHeight,
      lang: xmlElement.getAttribute('xml:lang'),
      space: xmlElement.getAttribute('xml:space'),
      textDirection: TextDirection.fromXml(xmlElement),
      enclosure: EnclosureShape.fromString(xmlElement.text),
    );
  }
}

// <xs:attributeGroup name="letter-spacing">
// 	<xs:annotation>
// 		<xs:documentation>The letter-spacing attribute specifies text tracking. Values are either "normal" or a number representing the number of ems to add between each letter. The number may be negative in order to subtract space. The default is normal, which allows flexibility of letter-spacing for purposes of text justification.</xs:documentation>
// 	</xs:annotation>
// 	<xs:attribute name="letter-spacing" type="number-or-normal"/>
// </xs:attributeGroup>

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

  static TextDirection fromXml(XmlElement xmlElement) {
    // TODO:
    throw InvalidXmlElementException(
      "Attribute 'text-direction' is not a valid",
      xmlElement,
    );
  }
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
  NumberOfLines underline;
  NumberOfLines overline;
  NumberOfLines lineThrough;

  TextDecoration({
    required this.underline,
    required this.overline,
    required this.lineThrough,
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
enum LeftCenterRight {
  left,
  center,
  right;

  static LeftCenterRight fromString(String value) {
    for (var element in LeftCenterRight.values) {
      if (element.name.contains(value)) return element;
    }
    // TODO: better exception
    throw "Invalid LeftCenterRight value: $value";
  }
}

/// The enclosure-shape type describes the shape and presence/absence of an enclosure around text or symbols.
///
/// A bracket enclosure is similar to a rectangle with the bottom line missing, as is common in jazz notation.
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

  static EnclosureShape fromString(String value) {
    return EnclosureShape.values.firstWhere((e) => e.name.toString() == value,
        // TODO: better exception
        orElse: () => throw 'Invalid EnclosureShape value: $value');
  }
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
  String? fontFamily;
  FontStyle? fontStyle;
  FontSize? fontSize;
  FontWeight? fontWeight;

  Font({this.fontFamily});

  factory Font.fromXml(XmlElement xmlElement) {
    return Font(
      fontFamily: xmlElement.getAttribute('font-family'),
    );
  }
}

// <xs:attributeGroup name="font">
// 	<xs:annotation>
// 		<xs:documentation>The font attribute group gathers together attributes for determining the font within a credit or direction. They are based on the text styles for Cascading Style Sheets. The font-family is a comma-separated list of font names.The font-style can be normal or italic. The font-size can be one of the CSS sizes or a numeric point size. The font-weight can be normal or bold. The default is application-dependent, but is a text font vs. a music font.</xs:documentation>
// 	</xs:annotation>
// 	<xs:attribute name="font-family" type="font-family"/>
// 	<xs:attribute name="font-style" type="font-style"/>
// 	<xs:attribute name="font-size" type="font-size"/>
// 	<xs:attribute name="font-weight" type="font-weight"/>
// </xs:attributeGroup>

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
  String? value;

  Color({this.value});

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
