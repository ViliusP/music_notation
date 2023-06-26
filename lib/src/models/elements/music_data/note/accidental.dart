import 'package:music_notation/src/models/data_types/accidental_value.dart';
import 'package:music_notation/src/models/elements/editorial.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/utilities/type_parsers.dart';
import 'package:xml/xml.dart';

/// The accidental type represents actual notated accidentals.
///
/// Editorial and cautionary indications are indicated by attributes.
///
/// Values for these attributes are "no" if not present.
///
/// Specific graphic display such as parentheses, brackets, and size are controlled by the level-display attribute group.
class Accidental {
  AccidentalValue value;

  /// If yes, indicates that this is a cautionary accidental.
  /// The value is no if not present.
  ///
  /// type="yes-no".
  bool cautionary;

  /// If yes, indicates that this is an editorial accidental.
  /// The value is no if not present.
  ///
  /// type="yes-no".
  bool editorial;

  LevelDisplay levelDisplay;

  PrintStyle printStyle;

  /// References a specific Standard Music Font Layout (SMuFL) accidental glyph.
  ///
  /// This is used both with the other accidental value and for disambiguating cases where a single MusicXML accidental value could be represented by multiple SMuFL glyphs.
  ///
  /// type="smufl-accidental-glyph-name"
  String? smufl;

  Accidental({
    required this.value,
    this.cautionary = false,
    required this.editorial,
    required this.levelDisplay,
    required this.printStyle,
    required this.smufl,
  });

  factory Accidental.fromXml(XmlElement xmlElement) {
    AccidentalValue? value = AccidentalValue.fromXml(xmlElement);

    String? editorialAttribute = xmlElement.getAttribute("editorial");
    bool editorial = false;

    if (editorialAttribute != null) {
      editorial = YesNo.toBool(editorialAttribute) ?? false;
    }

    String? cautionaryAttribute = xmlElement.getAttribute("cautionary");
    bool cautionary = false;

    if (cautionaryAttribute != null) {
      cautionary = YesNo.toBool(cautionaryAttribute) ?? false;
    }

    String? smufl = xmlElement.getAttribute("smufl");

    return Accidental(
      value: value,
      cautionary: cautionary,
      editorial: editorial,
      levelDisplay: LevelDisplay.fromXml(xmlElement),
      printStyle: PrintStyle.fromXml(xmlElement),
      smufl: smufl,
    );
  }
}
