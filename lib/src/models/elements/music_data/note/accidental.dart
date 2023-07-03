import 'package:music_notation/src/models/data_types/accidental_value.dart';
import 'package:music_notation/src/models/elements/editorial.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:xml/xml.dart';

/// Represents a notated accidental in MusicXML.
///
/// It has attributes determining whether it is cautionary or editorial,
/// its level display, print style, and a SMuFL accidental glyph reference.
class Accidental {
  // ------------------------- //
  // ------   Content   ------ //
  // ------------------------- //

  /// The value of the accidental as specified in the MusicXML document.
  AccidentalValue value;

  // ------------------------- //
  // ------ Attributes ------- //
  // ------------------------- //

  /// If `true`('yes' in xml), indicates that this is a cautionary accidental.
  /// The value is `false`('no' in xml) if not present.
  bool cautionary;

  /// If `true`, this accidental is a cautionary accidental.
  ///
  /// Defaults to `false` if not specified in the XML.
  bool editorial;

  /// Specifies the display level of the accidental.
  ///
  /// Uses [LevelDisplay.empty] as a default value.
  LevelDisplay levelDisplay;

  /// Specifies the print style of the accidental.
  ///
  /// Uses [PrintStyle.empty] as a default value.
  PrintStyle printStyle;

  /// Specifies a specific Standard Music Font Layout (SMuFL) glyph for the accidental.
  ///
  /// Used for disambiguating cases where a single MusicXML accidental value
  /// could be represented by multiple SMuFL glyphs.
  String? smufl;

  /// Constructs a new [Accidental].
  ///
  /// All parameters except [value] are optional and have default values.
  Accidental({
    required this.value,
    this.cautionary = false,
    this.editorial = false,
    this.levelDisplay = const LevelDisplay.empty(),
    this.printStyle = const PrintStyle.empty(),
    this.smufl,
  });

  /// Constructs a new [Accidental] instance from an [XmlElement].
  ///
  /// Uses 'yes', 'no', and `null` to determine the boolean value of the
  /// [cautionary] and [editorial] attributes.
  /// If the attribute value is not valid, it will throw a [MusicXmlTypeException].
  factory Accidental.fromXml(XmlElement xmlElement) {
    return Accidental(
      value: AccidentalValue.fromXml(xmlElement),
      editorial: YesNo.fromXml(xmlElement, 'editorial') ?? false,
      cautionary: YesNo.fromXml(xmlElement, 'cautionary') ?? false,
      levelDisplay: LevelDisplay.fromXml(xmlElement),
      printStyle: PrintStyle.fromXml(xmlElement),
      // It should be validated.
      smufl: xmlElement.getAttribute("smufl"),
    );
  }
}
