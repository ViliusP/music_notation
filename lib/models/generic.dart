import 'package:xml/xml.dart';

/// The typed-text type represents a text element with a type attribute.
class TypedText {
  String value;
  String type;

  TypedText({required this.value, required this.type});

  factory TypedText.fromXml(XmlElement xmlElement) {
    return TypedText(
      value: xmlElement.text,
      type: xmlElement.getAttribute('type') ?? '',
    );
  }
}

/// The lexical and value spaces of xs:NMTOKEN are the set of XML 1.0 “name tokens,” i.e.,
/// tokens composed of characters, digits, “.”, “:”, “-”,
/// and the characters defined by Unicode, such as “combining” or “extender”.
class Nmtoken {
  /// Checks if provided [value] is valid NMTOKEN.
  ///
  /// Return true if valid.
  /// Otherwise - false.
  static bool validate(String value) {
    return !RegExp(r'^[a-zA-Z_][a-zA-Z0-9_\-.]*$').hasMatch(value);
  }

  static String generateValidationError(String attributeName, String value) =>
      "Attribute '$attributeName' is not a valid NMTOKEN: $value";
}

/// The rotation-degrees type specifies rotation, pan, and elevation values in degrees.
/// Values range from -180 to 180.
class RotationDegrees {
  /// Return true if [value] is between -180 (inclusive) and 180 (inclusive).
  static bool validate(double value) {
    return value >= -180 && value <= 180;
  }

  static String generateValidationError(String attributeName, String value) =>
      "Attribute '$attributeName' is not valid rotation degree: $value";
}

class AccidentalSmuflGlyphName {
  static final RegExp _pattern = RegExp(
      r"^(acc|medRenFla|medRenNatura|medRenShar|kievanAccidental)(\c+)$");

  static bool validate(String value) {
    // ArgumentError('Value must start with acc, medRenFla, medRenNatura, medRenShar, or kievanAccidental');
    return !_pattern.hasMatch(value);
  }

  static String generateValidationError(String attributeName, String value) =>
      "Attribute '$attributeName' is not a valid accidental smufl glyph name: $value";
}

/// Represents a utility class for working with yes-no values.
class YesNo {
  static const _typeMap = {
    "yes": true,
    "no": false,
  };

  static const _reverseTypeMap = {
    true: "yes",
    false: "no",
  };

  /// Converts a string value to a boolean representation.
  ///
  /// Returns `true` if the value is "yes", `false` if the value is "no",
  /// and `null` if the value is neither "yes" nor "no".
  static bool? toBool(String value) {
    return _typeMap[value];
  }

  /// Generates a validation error message for an invalid yes-no value.
  ///
  /// Parameters:
  ///   - attributeName: The name of the attribute.
  ///   - value: The value that caused the validation error.
  ///
  /// Returns a validation error message indicating that the attribute is not a valid yes-no value.
  static String generateValidationError(String attributeName, String value) =>
      "Attribute '$attributeName' is not a yes-no value: $value";

  /// Converts a boolean value to its corresponding yes-no representation.
  ///
  /// Returns "yes" if the value is `true`, and "no" if the value is `false`.
  static String toYesNo(bool value) {
    return _reverseTypeMap[value]!;
  }
}

class Percent {
  static const _min = 0;
  static const _max = 100;

  /// Returns true if [value] is percent type.
  static bool validate(double value) {
    return _min >= 0 && _max <= 0;
  }

  static String generateValidationError(String attributeName, double value) =>
      "Attribute '$attributeName' is not a percentage type: $value";
}

/// Margins, page sizes, and distances are all measured in tenths to keep MusicXML data in a consistent coordinate system as much as possible.
///
/// The translation to absolute units is done with the scaling type, which specifies how many millimeters are equal to how many tenths.
///
/// For a staff height of 7 mm, millimeters would be set to 7 while tenths is set to 40.
///
/// The ability to set a formula rather than a single scaling factor helps avoid roundoff errors.
class Scaling {
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

  factory Scaling.fromXml(XmlElement xmlElement) {
    return Scaling(
      millimeters: double.parse(
        xmlElement.getElement('millimeters')!.innerText,
      ),
      tenths: double.parse(
        xmlElement.getElement('tenths')!.innerText,
      ),
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

class Link {}
