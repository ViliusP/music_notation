import 'package:music_notation/src/models/exceptions.dart';
import 'package:music_notation/src/models/utilities/common_attributes.dart';
import 'package:xml/xml.dart';

class BeamLevel {
  static const int _min = 1;
  static const int _max = 8;

  /// Throws [FormatExpcetion] if provided value is not integer.
  ///
  /// Throws [InvalidMusicXmlType] if provided value is integer but not beam-level.
  static int parse(String value) {
    int parsedValue = int.parse(value);

    if (parsedValue < _min || parsedValue > _max) {
      throw InvalidMusicXmlType(
        message: "Provided value - $value is not beam-level type",
        xmlElement: null,
      );
    }

    return parsedValue;
  }

  static int? tryParse(String value) {
    int? parsedValue = int.tryParse(value);

    if (parsedValue == null || parsedValue < _min || parsedValue > _max) {
      return null;
    }

    return parsedValue;
  }

  static String generateValidationError(String attributeName, double value) =>
      "Attribute '$attributeName' is not a percentage type: $value";
}

/// Slurs, tuplets, and many other features can be concurrent and overlap within a single musical part.
/// The number-level entity distinguishes up to 16 concurrent objects of the same type when the objects overlap in MusicXML document order.
/// Values greater than 6 are usually only needed for music with a large number of divisi staves in a single part,
/// or if there are more than 6 cross-staff arpeggios in a single measure. When a number-level value is implied, the value is 1 by default.
///
/// When polyphonic parts are involved, the ordering within a MusicXML document can differ from musical score order.
/// As an example, say we have a piano part in 4/4 where within a single measure,
/// all the notes on the top staff are followed by all the notes on the bottom staff.
/// In this example, each staff has a slur that starts on beat 2 and stops on beat 3,
/// and there is a third slur that goes from beat 1 of one staff to beat 4 of the other staff.
///
/// In this situation, the two mid-measure slurs can use the same number because they do not overlap in MusicXML document order,
/// even though they do overlap in musical score order. Within the MusicXML document,
/// the top staff slur will both start and stop before the bottom staff slur starts and stops.
///
/// If the cross-staff slur starts in the top staff and stops in the bottom staff,
/// it will need a separate number from the mid-measure slurs because it overlaps those slurs in MusicXML document order.
/// However, if the cross-staff slur starts in the bottom staff and stops in the top staff,
/// all three slurs can use the same number.
/// None of them overlap within the MusicXML document,
/// even though they all overlap each other in the musical score order.
/// Within the MusicXML document, the start and stop of the top-staff slur will be followed by the stop and start of the cross-staff slur,
/// followed by the start and stop of the bottom-staff slur.
///
/// As this example demonstrates,
/// a reading program should be prepared to handle cases where the number-levels start and stop in an arbitrary order.
/// Because the start and stop values refer to musical score order,
/// a program may find the stopping point of an object earlier in the MusicXML document than it will find its starting point.
class NumberLevel {
  static const int _min = 1;
  static const int _max = 16;

  /// Throws [FormatExpcetion] if provided value is not integer.
  ///
  /// Thorws [InvalidMusicXmlType] if provided value is integer but not beam-level.
  static int parse(String value) {
    int parsedValue = int.parse(value);

    if (parsedValue < _min || parsedValue > _max) {
      throw InvalidMusicXmlType(
        message: "Provided value - $value is not beam-level type",
        xmlElement: null,
      );
    }

    return parsedValue;
  }

  static int? tryParse(String value) {
    int? parsedValue = int.tryParse(value);

    if (parsedValue == null || parsedValue < _min || parsedValue > _max) {
      return null;
    }

    return parsedValue;
  }

  static String generateValidationError(String attributeName, double value) =>
      "Attribute '$attributeName' is not a percentage type: $value";
}

/// The time-only type is used to indicate that a particular playback- or listening-related element only applies particular times through a repeated section.
///
/// The value is a comma-separated list of positive integers arranged in ascending order,
/// indicating which times through the repeated section that the element applies.
class TimeOnly {
  static const String _pattern = r'[1-9][0-9]*(, ?[1-9][0-9]*)*';

  /// Checks if provided [value] is valid time-only.
  ///
  /// Return true if valid.
  /// Otherwise - false.
  static bool validate(String value) {
    return RegExp(_pattern).hasMatch(value);
  }

  static String generateValidationError(String attributeName, String value) =>
      "Attribute '$attributeName' is not a valid time-only: $value";
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
    return RegExp(r'^[a-zA-Z_][a-zA-Z0-9_\-.]*$').hasMatch(value);
  }

  static String generateValidationError(String attributeName, String value) =>
      "Attribute '$attributeName' is not a valid NMTOKEN: $value";
}

/// The rotation-degrees type specifies rotation, pan, and elevation values in degrees.
/// Values range from -180 to 180.
class RotationDegrees {
  /// Return true if [value] is between -180 (inclusive) and 180 (inclusive).
  static bool isValid(double value) {
    return value >= -180 && value <= 180;
  }

  static double? fromXml(XmlElement xmlElement) {
    String? rawRotation = xmlElement.getAttribute(CommonAttributes.rotation);
    if (rawRotation == null) {
      return null;
    }
    double? rotation = double.tryParse(rawRotation);
    if (rotation == null || !isValid(rotation)) {
      throw InvalidMusicXmlType(
        message: generateValidationError(
          CommonAttributes.rotation,
          rawRotation,
        ),
        xmlElement: xmlElement,
      );
    }
    return rotation;
  }

  static String generateValidationError(String attributeName, String value) =>
      "Attribute '$attributeName' is not valid rotation degree: $value";
}

/// The [NumberOrNormal] values can be either a decimal number or the string "normal".
///
/// This is used by the line-height and letter-spacing attributes.
///
/// The "normal" value is represented as null.
class NumberOrNormal {
  static double? fromXml(XmlElement xmlElement, String attributeName) {
    String? rawNumberOrNormal = xmlElement.getAttribute(
      attributeName,
    );
    if (rawNumberOrNormal == null || rawNumberOrNormal == "normal") {
      return null;
    }
    double? rotation = double.tryParse(rawNumberOrNormal);
    if (rotation == null) {
      throw InvalidMusicXmlType(
        message: generateValidationError(
          attributeName,
          rawNumberOrNormal,
        ),
        xmlElement: xmlElement,
      );
    }
    return rotation;
  }

  static String generateValidationError(String attributeName, String value) =>
      "Attribute '$attributeName' is not valid number-or-normal: $value";
}

// Methods and attributes related to the SmuflGlyphName for accidentals in MusicXML.
class AccidentalSmuflGlyphName {
  /// A Regular Expression pattern to validate the SmuflGlyphName. It should start with 'acc', 'medRenFla', 'medRenNatura', 'medRenShar', or 'kievanAccidental'.
  static final RegExp _pattern = RegExp(
    r"^(acc|medRenFla|medRenNatura|medRenShar|kievanAccidental)(\c+)$",
  );

  /// Validates the SmuflGlyphName.
  ///
  /// It returns true if the name is valid and false otherwise.
  static bool validate(String value) {
    return _pattern.hasMatch(value);
  }

  /// generates an error message if the given SmuflGlyphName is invalid.
  static String generateValidationError(String attributeName, String value) =>
      "Attribute '$attributeName' is not a valid accidental smufl glyph name: $value";

  /// Extracts the SmuflGlyphName from the given XmlElement
  /// if it exists and is valid.
  ///
  /// If the SmuflGlyphName is not valid, it throws an InvalidMusicXmlType exception.
  static String? fromXml(XmlElement xmlElement) {
    String? smufl = xmlElement.getAttribute(CommonAttributes.smufl);
    if (smufl == null || validate(smufl)) {
      return smufl;
    }
    throw InvalidMusicXmlType(
      message: "$smufl is not accidental smufl glyph",
      xmlElement: xmlElement,
    );
  }
}

/// The smufl-pictogram-glyph-name type is used to reference a specific Standard Music Font Layout (SMuFL) percussion pictogram character.
///
/// The value is a SMuFL canonical glyph name that starts with pict.
class SmuflPictogramGlyphName {
  static final RegExp _pattern = RegExp(r'pict\c+');

  static bool validate(String value) {
    return !_pattern.hasMatch(value);
  }

  static String generateValidationError(String attributeName, String value) =>
      "Attribute '$attributeName' is not a valid smufl pictogram glyph: $value";
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

  static bool? fromXml(XmlElement xmlElement, String attributeName) {
    String? rawAttribute = xmlElement.getAttribute(
      attributeName,
    );

    bool? yesNo = YesNo.toBool(rawAttribute ?? "");

    // Checks if provided value is "yes", "no" or nothing.
    // If it is something different, it throws error;
    if (rawAttribute != null && yesNo == null) {
      final String message = YesNo.generateValidationError(
        attributeName,
        rawAttribute,
      );
      throw InvalidMusicXmlType(
        message: message,
        xmlElement: xmlElement,
      );
    }
    return yesNo;
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
  static bool isValid(double value) {
    return _min <= value && _max >= value;
  }

  static String generateValidationError(String attributeName, double value) =>
      "Attribute '$attributeName' is not a percentage type: $value";
}

/// Static methods for validating MusicXML anyURI type according to the MusicXML specification.
///
/// The MusicXML anyURI type represents a Uniform Resource Identifier (URI) used in MusicXML documents,
/// including standard URI schemes (e.g., http, https, ftp)
/// and MusicXML-specific fragment identifiers
/// (which are strings ending with '.musicxml' such as p1.musicxml, p2.musicxml).
/// This class provides a method to validate a string as a MusicXML anyURI.
///
/// The anyURI defined by the [W3C XML Schema standard](https://www.w3.org/TR/xmlschema11-2/#anyURI).
class MusicXMLAnyURI {
  /// Validates a string as a MusicXML anyURI.
  ///
  /// Returns true if the input value is a valid MusicXML anyURI according to the MusicXML specification.
  /// Returns false otherwise.
  static bool isValid(String uri) {
    // Custom check for MusicXML files
    if (uri.endsWith('.musicxml')) {
      return true;
    }

    // Check for other URI schemes
    final Uri? parsedUri = Uri.tryParse(uri);

    // If the URI parsing is successful and has a known scheme or it is a mailto URI with a valid email, it's valid
    if (parsedUri?.hasScheme == true) {
      if (["http", "https", "ftp"].contains(parsedUri?.scheme)) {
        return true;
      }
      if (parsedUri?.scheme == 'mailto' && parsedUri?.path.isNotEmpty == true) {
        return _isValidEmail(parsedUri!.path);
      }
    }

    // If no other condition was met, the URI is not valid
    return false;
  }

  static bool _isValidEmail(String email) {
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9]+\.[a-zA-Z0-9-.]+$');
    return emailRegex.hasMatch(email);
  }
}
