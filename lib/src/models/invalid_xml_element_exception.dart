import 'package:xml/xml.dart';

class InvalidXmlElementException implements Exception {
  final String message;
  final XmlElement xmlElement;
  InvalidXmlElementException(this.message, this.xmlElement);

  @override
  String toString() {
    return 'InvalidXmlElementAttributeException: $message';
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
