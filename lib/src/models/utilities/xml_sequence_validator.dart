import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

/// An enumeration representing the quantifier for XML elements in a sequence.
enum XmlQuantifier {
  /// minOccurs="0" maxOccurs="unbounded"
  zeroOrMore(0, null),

  /// minOccurs="1" maxOccurs="unbounded"
  oneOrMore(1, null),

  /// minOccurs="0"
  optional(0, 1),

  /// use="required"
  required(1, 1),

  // minOccurs="0" maxOccurs="2"
  zeroToTwo(0, 2);

  const XmlQuantifier(this.minOccurences, this.maxOccurences);

  /// The minimum number of occurrences allowed
  final int minOccurences;

  /// The maximum number of occurrences allowed (null indicates unbounded)
  final int? maxOccurences;
}

/// Validates the XML [element] children against the expected [sequence].
///
/// The [sequence] is a map representing the expected sequence of XML elements and their quantifiers.
///
/// Throws an [XmlSequenceException] exception if the XML structure does not match the expected sequence.
void validateSequence(
  XmlElement element,
  Map<dynamic, XmlQuantifier> sequence,
) {
  final concatenatedNames = _getConcatenatedNames(element);

  final regexPattern = _generateRegexPattern(sequence);

  final regex = RegExp(regexPattern);

  if (!regex.hasMatch(concatenatedNames)) {
    throw XmlSequenceException(
      message:
          'Invalid sequence. The XML structure does not match the expected sequence.',
      xmlElement: element,
      sequence: sequence,
    );
  }
}

/// Recursively concatenates the names of XML elements and nested elements.
///
/// Returns a string containing the concatenated names.
///
/// Arguments:
/// - [xmlElement] The XML element to process.
String _getConcatenatedNames(XmlElement xmlElement) {
  return xmlElement.children
      .whereType<XmlElement>()
      .map((child) => child.name.toString())
      .join();
}

/// Generates the regular expression pattern based on the expected [sequence].
///
/// The [sequence] is a map representing the expected sequence
/// of XML elements and their quantifiers.
///
/// Returns the generated regular expression pattern as a string.
String _generateRegexPattern(Map<dynamic, XmlQuantifier> sequence) {
  final patternSegments = <String>[];

  for (var entry in sequence.entries) {
    final dynamic key = entry.key;
    final XmlQuantifier quantifier = entry.value;

    if (key is String) {
      final elementNames = key.split('|').map(RegExp.escape).join('|');
      final segmentPattern = _generateElementPattern(elementNames, quantifier);
      patternSegments.add(segmentPattern);
    } else if (key is Map<dynamic, XmlQuantifier>) {
      final nestedPattern = _generateRegexPattern(key).replaceAll(
        RegExp(r'\^|\$'),
        '',
      );
      final quantifierPattern = _generateQuantifierPattern(quantifier);
      final segmentPattern = '($nestedPattern)$quantifierPattern';
      patternSegments.add(segmentPattern);
    } else {
      throw ArgumentError(
        'Invalid sequence format. Keys must be either a String or a Map.',
      );
    }
  }

  return '^${patternSegments.join()}\$';
}

/// Generates the pattern for an [elementNames] and [quantifier].
///
/// The [elementNames] is string containing the element names separated by "|".
///
/// Returns the generated pattern as a string.
String _generateElementPattern(String elementNames, XmlQuantifier quantifier) {
  String segmentPattern;

  switch (quantifier) {
    case XmlQuantifier.zeroOrMore:
      segmentPattern = '($elementNames)*';
      break;
    case XmlQuantifier.oneOrMore:
      segmentPattern = '($elementNames)+';
      break;
    case XmlQuantifier.optional:
      segmentPattern = '($elementNames)?';
      break;
    case XmlQuantifier.required:
      segmentPattern = '($elementNames)';
      break;
    case XmlQuantifier.zeroToTwo:
      segmentPattern = '($elementNames){0,2}';
      break;
  }

  return segmentPattern;
}

/// Generates the pattern for the [quantifier].
///
/// Returns the generated pattern as a string.
String _generateQuantifierPattern(XmlQuantifier quantifier) {
  switch (quantifier) {
    case XmlQuantifier.zeroOrMore:
      return '*';
    case XmlQuantifier.oneOrMore:
      return '+';
    case XmlQuantifier.optional:
      return '?';
    case XmlQuantifier.required:
      return '';
    case XmlQuantifier.zeroToTwo:
      return '{0,2}';
  }
}
