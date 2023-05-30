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
