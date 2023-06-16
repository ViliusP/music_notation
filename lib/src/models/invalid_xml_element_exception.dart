import 'package:xml/xml.dart';

/// Exception that is thrown when an invalid XmlElement is encountered
/// while parsing the MusicXML data.
class InvalidXmlElementException implements Exception {
  /// A message that describes the error in detail.
  final String message;

  /// The XmlElement which caused the exception to be thrown.
  final XmlElement xmlElement;

  /// Creates an instance of the InvalidXmlElementException with an
  /// error [message] and the offending [xmlElement].
  InvalidXmlElementException(this.message, this.xmlElement);

  @override
  String toString() {
    return 'InvalidXmlElementException: $message';
  }
}

class InvalidMusicXmlType implements Exception {
  final String message;

  InvalidMusicXmlType(this.message);

  @override
  String toString() {
    return 'InvalidMusicXmlType: $message';
  }
}

class XmlElementRequired implements Exception {
  final String message;

  XmlElementRequired(this.message);

  @override
  String toString() {
    return 'XmlElementRequired: $message';
  }
}
