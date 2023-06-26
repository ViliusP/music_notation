import 'package:music_notation/src/models/utilities/xml_sequence_validator.dart';
import 'package:xml/xml.dart';

/// A base for all exceptions that are specific to MusicXML.
///
/// Implements the built-in [Exception] class.
abstract class MusicXmlException implements Exception {
  /// A message that describes the error in detail.
  final String message;

  /// The XML element which caused the exception.
  /// This allows for easier debugging as you can see which part of the XML document caused the error.
  final XmlElement xmlElement;

  MusicXmlException({
    required this.message,
    required this.xmlElement,
  });
}

/// Exception thrown when a MusicXML element contains invalid content.
///
/// This exception should be used when a MusicXML element contains unexpected content
/// according to the MusicXML specification. This could be either because the element is
/// unexpectedly empty, or because it contains child elements when only specific data types
/// (like text, string, tenths, decimal etc.) are expected.
///
/// You can then use this exception in your parsing code as follows:
/// ```dart
/// if (xmlElement.isEmpty) {
///   throw InvalidElementContentException(
///     message: 'The element "${xmlElement.name}" is unexpectedly empty.',
///     xmlElement: xmlElement,
///   );
/// } else if (xmlElement.hasElement) {
///   throw InvalidElementContentException(
///     message: 'The element "${xmlElement.name}" contains unexpected child elements.',
///     xmlElement: xmlElement,
///   );
/// }
/// ```
class InvalidElementContentException implements MusicXmlException {
  /// A message that describes the error in detail.
  @override
  final String message;

  /// The XmlElement which caused the exception to be thrown.
  @override
  final XmlElement xmlElement;

  InvalidElementContentException({
    required this.message,
    required this.xmlElement,
  });

  @override
  String toString() {
    return 'InvalidContentElementException: $message';
  }
}

/// Exception that is thrown when an invalid XmlElement is encountered
/// while parsing the MusicXML data.
@Deprecated(
    "use InvalidContentElementException or InvalidFormatElementException")
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

/// Exception thrown when the content of a MusicXML element cannot be
/// correctly parsed into the expected type.
///
/// This exception should be used when an attribute or element content cannot
/// be correctly converted or parsed into the expected type (like decimal, tenths etc.).
/// For example, if a MusicXML element should contain a decimal value according
/// to the specification, but the actual content cannot be parsed into a decimal
/// (perhaps because it contains non-numeric characters), an `MusicXmlFormatException`
/// would be thrown:
///
/// ```dart
/// try {
///   double.parse(xmlElement.text);
/// } catch (FormatException) {
///   throw MusicXmlFormatException(
///     message: 'The element "${xmlElement.name}" cannot be parsed into a decimal number.',
///     xmlElement: xmlElement,
///   );
/// }
/// ```
class MusicXmlFormatException extends FormatException
    implements MusicXmlException {
  /// The XmlElement which caused the exception to be thrown.
  @override
  final XmlElement xmlElement;

  MusicXmlFormatException({
    required String message,
    required this.xmlElement,
    String? source,
  }) : super(message, source);

  @override
  String toString() {
    return 'MusicXmlFormatException: $message\nElement causing the exception: ${xmlElement.toXmlString(pretty: true)}';
  }
}

@Deprecated("use MusicXmlFormatException")
class InvalidMusicXmlType implements Exception {
  final String message;

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

/// Exception thrown when a required XML attribute is missing in a MusicXML document.
///
/// This exception should be used when an XML attribute, which is mandatory
/// according to the MusicXML specification, is not found within an XmlElement.
///
/// The class holds a reference to the problematic XmlElement and a message
/// providing detailed information about the problem.
///
/// Example:
/// ```dart
/// if (!xmlElement.hasAttribute('requiredAttribute')) {
///   throw XmlAttributeRequired(
///     message: 'The attribute "requiredAttribute" is missing.',
///     xmlElement: xmlElement,
///   );
/// }
/// ```
class XmlAttributeRequired implements MusicXmlException {
  /// A message that describes the error in detail.
  @override
  final String message;

  /// The XmlElement which caused the exception to be thrown.
  @override
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

@Deprecated("Use InvalidXmlSequence instead")
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

/// Specific type of MusicXmlException.
///
/// It is used when the sequence of XML elements in the document is incorrect.
class InvalidXmlSequence implements MusicXmlException {
  @override
  final String message;

  @override
  final XmlElement xmlElement;

  /// Shows the correct sequence of XML elements.
  ///
  /// It's useful for debugging because you can compare it with the actual sequence in the XML document.
  final Map<dynamic, XmlQuantifier> sequence;

  const InvalidXmlSequence({
    required this.message,
    required this.xmlElement,
    required this.sequence,
  });

  @override
  String toString() {
    String xml = xmlElement.toXmlString(pretty: true);

    return 'InvalidXmlSequence: $message\n$xml\n$sequence';
  }
}
