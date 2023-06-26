import 'package:collection/collection.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

/// The group-symbol-value type indicates how the symbol for a group or multi-staff part is indicated in the score.
enum GroupSymbolValue {
  none,
  brace,
  line,
  bracket,
  square;

  static GroupSymbolValue? fromString(String value) {
    return GroupSymbolValue.values.firstWhereOrNull(
      (e) => e.name == value,
    );
  }

  /// Takes content from element and converts it to [GroupSymbolValue].
  ///
  /// In musicXML, group-symbol-value is content and always required.
  static GroupSymbolValue fromXml(XmlElement xmlElement) {
    if (xmlElement.children.length != 1 ||
        xmlElement.children.first.nodeType != XmlNodeType.TEXT) {
      throw XmlElementContentException(
        message:
            "'${xmlElement.name}' element should contain only one children - accidental-value",
        xmlElement: xmlElement,
      );
    }

    String rawValue = xmlElement.children.first.value!;
    GroupSymbolValue? value = GroupSymbolValue.fromString(rawValue);
    if (value == null) {
      throw MusicXmlFormatException(
        message: generateValidationError(
          rawValue,
        ),
        source: rawValue,
        xmlElement: xmlElement,
      );
    }
    return value;
  }

  /// Generates a validation error message for an invalid [GroupSymbolValue] value.
  ///
  /// Parameters:
  ///   - value: The value that caused the validation error.
  ///
  /// Returns a validation error message indicating that the value is not a valid group-symbol-value.
  static String generateValidationError(String value) =>
      "Content is not a group-symbol-value: $value";
}
