import 'package:xml/xml.dart';

/// Attribute group.
///
/// The dashed-formatting entity represents the length of dashes and spaces in a
/// dashed line. Both the [dashlength] and [spacelength] attributes are
/// represented in tenths.
///
/// These attributes are ignored if the corresponding `line type` attribute is
/// not dashed.
class DashedFormatting {
  /// The length of dashes in a dashed line.
  final int? dashLength;

  /// The length of spaces in a dashed line.
  final int? spaceLength;

  const DashedFormatting({
    this.dashLength,
    this.spaceLength,
  });

  const DashedFormatting.empty()
      : dashLength = null,
        spaceLength = null;

  factory DashedFormatting.fromXml(XmlElement xmlElement) {
    return const DashedFormatting();
  }
}

/// The line-type type distinguishes between solid, dashed, dotted, and wavy lines.
enum LineType {
  solid,
  dashed,
  dotted,
  wavy;
}
