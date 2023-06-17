import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

String hyphenToCamelCase(String input) {
  List<String> parts = input.split('-');
  String camelCase = parts[0];

  for (int i = 1; i < parts.length; i++) {
    String part = parts[i];
    camelCase += part[0].toUpperCase() + part.substring(1);
  }

  return camelCase;
}

String camelCaseToHyphen(String input) {
  String hyphenSeparated = '';

  for (int i = 0; i < input.length; i++) {
    if (input[i].toUpperCase() == input[i]) {
      hyphenSeparated += '-${input[i].toLowerCase()}';
    } else {
      hyphenSeparated += input[i];
    }
  }

  return hyphenSeparated;
}

Map inverseMap(Map f) {
  return f.map((k, v) => MapEntry(v, k));
}

enum XmlQuantifier {
  /// minOccurs="0" maxOccurs="unbounded"
  zeroOrMore(0, null),

  /// minOccurs="1" maxOccurs="unbounded"
  oneOrMore(1, null),

  /// minOccurs="0"
  optional(0, 1),

  /// use="required"
  required(1, 1);

  const XmlQuantifier(this.minOccurences, this.maxOccurences);

  final int minOccurences;

  final int? maxOccurences;
}

var sequence = {
  "display-text|accidental-text": XmlQuantifier.zeroOrMore,
};

void validateSequence(
  XmlElement xmlElement,
  Map<String, XmlQuantifier> sequence,
) {
  final childrenNames = xmlElement.children
      .whereType<XmlElement>()
      .map((child) => child.name.toString())
      .toList();

  int i = 0;
  for (var entry in sequence.entries) {
    var elementNames = entry.key.split("|");
    var quantifier = entry.value;

    switch (quantifier) {
      case XmlQuantifier.zeroOrMore:
        while (i < childrenNames.length &&
            elementNames.contains(childrenNames[i])) {
          i++;
        }
        break;
      case XmlQuantifier.oneOrMore:
        if (i >= childrenNames.length ||
            !elementNames.contains(childrenNames[i])) {
          String message = elementNames.length == 1
              ? 'Invalid sequence. Expected "${elementNames[0]}", found ${i < childrenNames.length ? childrenNames[i] : 'end of elements'}'
              : 'Invalid sequence. Expected one of ${elementNames.join(", ")}, found ${i < childrenNames.length ? childrenNames[i] : 'end of elements'}';
          throw InvalidXmlSequence(
            message: message,
            xmlElement: xmlElement,
            sequence: sequence,
          );
        }
        i++;
        while (i < childrenNames.length &&
            elementNames.contains(childrenNames[i])) {
          i++;
        }
        break;
      case XmlQuantifier.optional:
        if (i < childrenNames.length &&
            elementNames.contains(childrenNames[i])) {
          i++;
        }
        break;
      case XmlQuantifier.required:
        if (i >= childrenNames.length ||
            !elementNames.contains(childrenNames[i])) {
          String message = elementNames.length == 1
              ? 'Invalid sequence. Expected "${elementNames[0]}", found ${i < childrenNames.length ? childrenNames[i] : 'end of elements'}'
              : 'Invalid sequence. Expected one of ${elementNames.join(", ")}, found ${i < childrenNames.length ? childrenNames[i] : 'end of elements'}';
          throw InvalidXmlSequence(
            message: message,
            xmlElement: xmlElement,
            sequence: sequence,
          );
        }
        i++;
        break;
    }
  }
  if (i != childrenNames.length) {
    throw InvalidXmlSequence(
      message:
          'Invalid sequence. Found extra elements after validating sequence.',
      xmlElement: xmlElement,
      sequence: sequence,
    );
  }
}