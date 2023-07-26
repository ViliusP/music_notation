import 'package:collection/collection.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:xml/xml.dart';

/// [DashedFormatting] is an attribute group class representing the length of
/// dashes and spaces in a dashed line in MusicXML.
///
/// Both the [dashLength] and [spaceLength] attributes are represented in tenths.
/// These attributes are ignored if the corresponding `line type` attribute is not dashed.
class DashedFormatting {
  /// The length of dashes in a dashed line.
  final double? dashLength;

  /// The length of spaces in a dashed line.
  final double? spaceLength;

  const DashedFormatting({
    this.dashLength,
    this.spaceLength,
  });

  const DashedFormatting.empty()
      : dashLength = null,
        spaceLength = null;

  /// Constructs a [DashedFormatting] instance from a [XmlElement].
  ///
  /// Example:
  /// ```dart
  /// var dashedFormatting = DashedFormatting.fromXml(parse('<line dash-length="4" space-length="2"/>'));
  /// print(dashedFormatting.dashLength);  // 4
  /// print(dashedFormatting.spaceLength); // 2
  /// ```
  factory DashedFormatting.fromXml(XmlElement xmlElement) {
    return DashedFormatting(
      dashLength: Decimal.fromXml(xmlElement, "dash-length", false),
      spaceLength: Decimal.fromXml(xmlElement, "space-length", false),
    );
  }
}

/// [LineType] is an enum that distinguishes between solid, dashed, dotted,
/// and wavy lines in a MusicXML document.
///
/// For more details go to
/// [line-type data type | MusicXML 4.0](https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/line-type/).
enum LineType {
  solid,
  dashed,
  dotted,
  wavy;

  /// Returns the corresponding [LineType] value for a given string.
  ///
  /// Example:
  /// ```dart
  /// var lineType = LineType.fromString('dashed');
  /// print(lineType == LineType.dashed);  // true
  /// ```
  static LineType? fromString(String value) =>
      values.firstWhereOrNull((element) => element.name == value);

  /// Constructs a [LineType] instance from a [XmlElement].
  ///
  /// If the provided [xmlElement] has a `line-type` attribute, it will be parsed
  /// and used to create the [LineType] instance.
  ///
  /// If the `line-type` attribute is absent, this method will return `null`.
  ///
  /// If the `line-type` attribute is present but does not match valid
  /// [LineType] value, this method will throw a [MusicXmlTypeException].
  static LineType? fromXml(XmlElement xmlElement) {
    var lineTypeAttribute = xmlElement.getAttribute("line-type");
    if (lineTypeAttribute == null) {
      return null;
    }
    var lineType = fromString(lineTypeAttribute);

    if (lineType == null) {
      throw MusicXmlTypeException(
        message:
            "'line-type' attribute in ${xmlElement.localName} is not valid line type",
        xmlElement: xmlElement,
      );
    }
    return lineType;
  }
}
