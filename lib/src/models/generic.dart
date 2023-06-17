import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

// abstract class XmlParsable {

//   XmlParsable();

//   factory XmlParsable.fromXml(XmlElement xmlElement);
// }

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
    return _min <= value && _max >= value;
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

class Empty {
  const Empty();
}

class BeamLevel {
  static const int _min = 1;
  static const int _max = 8;

  /// Throws [FormatExpcetion] if provided value is not integer.
  ///
  /// Thorws [InvalidMusicXmlType] if provided value is integer but not beam-level.
  static int parse(String value) {
    int parsedValue = int.parse(value);

    if (parsedValue < _min || parsedValue > _max) {
      throw InvalidMusicXmlType(
          "Provided value - $value is not beam-level type");
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
          "Provided value - $value is not beam-level type");
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
    return !RegExp(_pattern).hasMatch(value);
  }

  static String generateValidationError(String attributeName, String value) =>
      "Attribute '$attributeName' is not a valid time-only: $value";
}

/// The element and position attributes are new as of Version 2.0.
/// They allow for bookmarks and links to be positioned at higher resolution
/// than the level of music-data elements.
///
/// When no element and position attributes are present,
/// the bookmark or link element refers to the next sibling element in the MusicXML file.
///
/// The element attribute specifies an element type for a descendant
/// of the next sibling element that is not a link or bookmark.
///
/// The position attribute specifies the position of this descendant element,
/// where the first position is 1.
///
/// The position attribute is ignored if the element attribute is not present.
///
/// For instance, an element value of "beam" and a position value of "2" defines
/// the link or bookmark to refer to the second beam descendant
/// of the next sibling element that is not a link or bookmark.
///
/// This is equivalent to an XPath test of [.//beam[2]] done in the context of the sibling element.<
class ElementPosition {
  String? element;

  int? position;

  ElementPosition({
    this.element,
    this.position,
  });

  factory ElementPosition.fromXml(XmlElement xmlElement) {
    return ElementPosition();
  }
}
