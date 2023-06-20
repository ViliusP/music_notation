import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
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
  InvalidXmlElementException({
    required this.message,
    required this.xmlElement,
  });

  @override
  String toString() {
    return 'InvalidXmlElementException: $message';
  }
}

class InvalidMusicXmlType implements Exception {
  final String message;

  /// The XmlElement which caused the exception to be thrown.
  final XmlElement? xmlElement;

  const InvalidMusicXmlType({
    required this.message,
    required this.xmlElement,
  });

  @override
  String toString() {
    return 'InvalidMusicXmlType: $message';
  }
}

class XmlAttributeRequired implements Exception {
  /// A message that describes the error in detail.
  final String message;

  /// The XmlElement which caused the exception to be thrown.
  final XmlElement xmlElement;

  XmlAttributeRequired({
    required this.message,
    required this.xmlElement,
  });

  @override
  String toString() {
    return 'XmlAttributeRequired: $message';
  }
}

class XmlElementRequired implements Exception {
  final String message;
  final XmlElement? xmlElement;

  XmlElementRequired(this.message, [this.xmlElement]);

  @override
  String toString() {
    final String xml = xmlElement?.toXmlString(pretty: true) ?? "";

    return 'XmlElementRequired: $message\n$xml';
  }
}

class InvalidXmlSequence implements Exception {
  final String message;
  final XmlElement xmlElement;
  final Map<dynamic, XmlQuantifier> sequence;

  const InvalidXmlSequence({
    required this.message,
    required this.xmlElement,
    required this.sequence,
  });

  @override
  String toString() {
    String xml = xmlElement.toXmlString(pretty: true);

    return 'InvalidMusicXmlType: $message\n$xml\n$sequence';
  }
}
