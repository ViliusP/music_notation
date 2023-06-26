import 'package:collection/collection.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/case_transformers.dart';
import 'package:xml/xml.dart';

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

  /// Takes content from element and converts it to [AccidentalValue].
  ///
  /// In musicXML, accidental-value is content and always required.
  static AccidentalValue fromXml(XmlElement xmlElement) {
    if (xmlElement.childElements.isNotEmpty) {
      throw InvalidElementContentException(
        message:
            "${xmlElement.name} element must contain only one children - accidental-value",
        xmlElement: xmlElement,
      );
    }

    String rawValue = xmlElement.innerText;
    AccidentalValue? value = AccidentalValue.fromString(rawValue);
    if (value == null) {
      throw MusicXmlFormatException(
        message: generateValidationError(
          rawValue,
        ),
        xmlElement: xmlElement,
      );
    }
    return value;
  }

  /// Generates a validation error message for an invalid [AccidentalValue] value.
  ///
  /// Parameters:
  ///   - value: The value that caused the validation error.
  ///
  /// Returns a validation error message indicating that the value is not a valid accidental-value.
  static String generateValidationError(String value) =>
      "Content is not a accidental-value: $value";
}
