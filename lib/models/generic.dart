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
    if (!RegExp(r'^[a-zA-Z_][a-zA-Z0-9_\-.]*$').hasMatch(value)) {
      return false;
    }
    return true;
  }
}
