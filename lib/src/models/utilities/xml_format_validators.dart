import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:music_notation/src/models/exceptions.dart';
import 'package:xml/xml.dart';

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

class ExpectedElement extends Equatable {
  final Set<String> nameOptions;
  final XmlQuantifier quantifier;

  const ExpectedElement({
    required this.nameOptions,
    required this.quantifier,
  });

  // Factory constructor that transforms map-based sequence
  factory ExpectedElement.transformFromMap(Map<dynamic, XmlQuantifier> map) {
    // First, we need to make sure the key is a String
    if (map.keys.every((element) => element is String)) {
      // We should also handle the "|" character as a special case.
      var names = (map.keys.first as String).split('|').toSet();
      return ExpectedElement(
        nameOptions: names,
        quantifier: map.values.first,
      );
    }

    // If the key is another Map, it means we have nested elements
    if (map.keys.first is Map<dynamic, XmlQuantifier>) {
      Map<dynamic, XmlQuantifier> nestedMap =
          map.keys.first as Map<dynamic, XmlQuantifier>;
      List<ExpectedElement> nestedElements = nestedMap.entries
          .map((e) => ExpectedElement.transformFromMap({e.key: e.value}))
          .toList();

      // Union of all name options of nested elements
      Set<String> nameOptions = nestedElements.fold(
        <String>{},
        (previousValue, element) => previousValue..addAll(element.nameOptions),
      );

      return NestedExpectedElement(
        nameOptions: nameOptions,
        quantifier: map.values.first,
        nestedElements: nestedElements,
      );
    }

    throw ArgumentError(
        "The map key must be a String or another Map<dynamic, XmlQuantifier>");
  }

  @override
  List<Object?> get props => [nameOptions, quantifier];
}

class NestedExpectedElement extends ExpectedElement {
  final List<ExpectedElement> nestedElements;

  const NestedExpectedElement({
    required Set<String> nameOptions,
    required XmlQuantifier quantifier,
    required this.nestedElements,
  }) : super(
          nameOptions: nameOptions,
          quantifier: quantifier,
        );

  @override
  List<Object?> get props => [super.props, nestedElements];
}

void validateSequence(
  XmlElement xmlElement,
  Map<dynamic, XmlQuantifier> mapSequence,
) {
  List<ExpectedElement> sequence = mapSequence.entries
      .map((e) => ExpectedElement.transformFromMap({e.key: e.value}))
      .toList();

  int elements = _validateSequence(xmlElement: xmlElement, sequence: sequence);

  int childrenLength = xmlElement.childElements.length;

  if (elements != childrenLength) {
    throw InvalidXmlSequence(
      message:
          'Invalid sequence. Found extra elements after validating sequence.',
      xmlElement: xmlElement,
      sequence: sequence,
    );
  }
}

int _validateSequence({
  required XmlElement xmlElement,
  required List<ExpectedElement> sequence,
  int startFrom = 0,
}) {
  final childrenNames = xmlElement.children
      .whereType<XmlElement>()
      .map((child) => child.name.toString())
      .toList()
      .sublist(startFrom);

  int i = startFrom;
  for (var expectedElement in sequence) {
    if (expectedElement is NestedExpectedElement) {
      int subSequenceMatches = 0;
      bool subSequenceStart = false;
      while (i < childrenNames.length) {
        var matchedElement = expectedElement.nestedElements
            .firstWhereOrNull((e) => e.nameOptions.contains(childrenNames[i]));

        if (!subSequenceStart && matchedElement == null) {
          break;
        }

        if (matchedElement == null) {
          throw InvalidXmlSequence(
            message:
                'Invalid sequence. Unexpected "${childrenNames[i]}" in nested sequence.',
            xmlElement: xmlElement,
            sequence: sequence,
          );
        }

        i = _validateSingleElement(
          element: matchedElement,
          index: i,
          childrenNames: childrenNames,
          xmlElement: xmlElement,
          sequence: sequence,
        );
        subSequenceStart = true;
        subSequenceMatches++;
      }

      if (expectedElement.quantifier == XmlQuantifier.oneOrMore &&
          subSequenceMatches == 0) {
        throw InvalidXmlSequence(
          message:
              'Invalid sequence. Expected at least one of the elements in ${expectedElement.nestedElements.map((e) => e.nameOptions.join(", ")).join(", ")}, found none',
          xmlElement: xmlElement,
          sequence: sequence,
        );
      }
      continue;
    }

    i = _validateSingleElement(
      element: expectedElement,
      index: i,
      childrenNames: childrenNames,
      xmlElement: xmlElement,
      sequence: sequence,
    );
  }
  return i;
}

int _validateSingleElement({
  required ExpectedElement element,
  required int index,
  required List<String> childrenNames,
  required XmlElement xmlElement,
  required List<ExpectedElement> sequence,
}) {
  int i = index;
  switch (element.quantifier) {
    case XmlQuantifier.zeroOrMore:
      while (i < childrenNames.length &&
          element.nameOptions.contains(childrenNames[i])) {
        i++;
      }
      break;
    case XmlQuantifier.oneOrMore:
      if (i >= childrenNames.length ||
          !element.nameOptions.contains(childrenNames[i])) {
        throw InvalidXmlSequence(
          message:
              'Invalid sequence. Expected "${element.nameOptions.join(", ")}", found ${i < childrenNames.length ? childrenNames[i] : 'end of elements'}',
          xmlElement: xmlElement,
          sequence: sequence,
        );
      }
      i++;
      while (i < childrenNames.length &&
          element.nameOptions.contains(childrenNames[i])) {
        i++;
      }
      break;
    case XmlQuantifier.optional:
      if (i < childrenNames.length &&
          element.nameOptions.contains(childrenNames[i])) {
        i++;
      }
      break;
    case XmlQuantifier.required:
      if (i >= childrenNames.length ||
          !element.nameOptions.contains(childrenNames[i])) {
        throw InvalidXmlSequence(
          message:
              'Invalid sequence. Expected "${element.nameOptions.join(", ")}", found ${i < childrenNames.length ? childrenNames[i] : 'end of elements'}',
          xmlElement: xmlElement,
          sequence: sequence,
        );
      }
      i++;
      break;
  }
  return i;
}
