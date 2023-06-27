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

String sentenceCaseToCamelCase(String input) {
  return input.replaceAll(' ', '_').splitMapJoin(
        RegExp(r'_([a-z])'),
        onMatch: (m) => m.group(1)!.toUpperCase(),
        onNonMatch: (n) => n,
      );
}

/// Converts a camelCase string to sentence case.
///
/// This function uses a regular expression to find each capital letter in
/// the [input] that comes after a lowercase letter, and then replaces
/// that capital letter with a space and the lowercase version of the letter.
///
/// Example:
/// ```
/// var input = 'camelCaseString';
/// var output = camelCaseToSentenceCase(input);
/// print(output); // prints: 'camel case string'
/// ```
///
/// Note: This function does not capitalize the first letter of the output
/// string. If the output string needs to start with a capital letter, additional
/// processing is required.
String camelCaseToSentenceCase(String input) {
  return input.replaceAllMapped(
    RegExp(r'(?<=[a-z])[A-Z]'),
    (Match m) => ' ${m[0]!.toLowerCase()}',
  );
}

Map inverseMap(Map f) {
  return f.map((k, v) => MapEntry(v, k));
}
