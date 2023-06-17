import 'package:collection/collection.dart';
import 'package:music_notation/src/models/elements/editorial.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/printing.dart';
import 'package:music_notation/src/models/utilities.dart';
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
    AccidentalValue? value = AccidentalValue.fromString(
      xmlElement.innerText,
    );

    if (value == null) {
      throw InvalidXmlElementException(
        message: "Bad Accidental value",
        xmlElement: xmlElement,
      );
    }

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

/// The accidental-value type represents notated accidentals supported by MusicXML.
///
/// In the MusicXML 2.0 DTD this was a string with values that could be included.
///
/// The XSD strengthens the data typing to an enumerated list.
///
/// The quarter- and three-quarters- accidentals are Tartini-style quarter-tone accidentals.
///
/// The -down and -up accidentals are quarter-tone accidentals that include arrows pointing down or up.
///
/// The slash- accidentals are used in Turkish classical music.
///
/// The numbered sharp and flat accidentals are superscripted versions of the accidental signs, used in Turkish folk music.
///
/// The sori and koron accidentals are microtonal sharp and flat accidentals used in Iranian and Persian music.
///
/// The other accidental covers accidentals other than those listed here. It is usually used in combination with the smufl attribute to specify a particular SMuFL accidental.
///
/// The smufl attribute may be used with any accidental value to help specify the appearance of symbols that share the same MusicXML semantics.
enum AccidentalValue {
  sharp,
  natural,
  flat,
  doubleSharp,
  sharpSharp,
  flatFlat,
  naturalSharp,
  naturalFlat,
  quarterFlat,
  quarterFharp,
  threeQuartersFlat,
  threeQuartersSharp,
  sharpDown,
  sharpUp,
  naturalDown,
  naturalUp,
  flatDown,
  flatUp,
  doubleSharpDown,
  doubleSharpUp,
  flatFlatDown,
  flatFlatUp,
  arrowDown,
  arrowUp,
  tripleSharp,
  tripleFlat,
  slashQuarterSharp,
  slashSharp,
  slashFlat,
  doubleSlashFlat,
  sharp1,
  sharp2,
  sharp3,
  sharp5,
  flat1,
  flat2,
  flat3,
  flat4,
  sori,
  koron,
  other;

  /// Converts hyphen-separated string value to [AccidentalValue].
  ///
  /// Returns null if that name does not exists.
  static AccidentalValue? fromString(String value) {
    return AccidentalValue.values.firstWhereOrNull(
      (e) => e.name == hyphenToCamelCase(value),
    );
  }

  @override
  String toString() => camelCaseToHyphen(name);
}
