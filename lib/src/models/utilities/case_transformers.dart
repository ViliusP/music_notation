/// Converts a hyphen-separated string to camel case.
///
/// This function takes a string [input] with words separated by hyphens
/// and returns a string in camel case (i.e., with words capitalized except the first one and no hyphens).
///
/// If the input string does not contain any hyphen, the first character of the string will be converted to lower case.
/// If the input string is empty, an empty string will be returned.
///
/// Example:
/// ```
/// var input = 'this-is-a-test';
/// var output = hyphenToCamelCase(input);
/// print(output); // prints: 'thisIsATest'
/// ```
String hyphenToCamelCase(String input) {
  List<String> words = input.split('-');
  String camelCase = "";

  for (int i = 0; i < words.length; i++) {
    String word = words[i];
    if (word.isNotEmpty) {
      if (i == 0) {
        // The first word is all lowercase.
        camelCase += word.toLowerCase();
        continue;
      }
      // Subsequent words are capitalized.
      camelCase += word[0].toUpperCase() + word.substring(1).toLowerCase();
    }
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

/// Converts a string from sentence case to camel case.
///
/// This function takes a string [input] in sentence case (i.e., with words separated by spaces)
/// and returns a string in camel case (i.e., with words capitalized except the first one and no spaces).
///
/// If the input string is already in camel case, the same string will be returned.
/// If the input string is empty, an empty string will be returned.
///
/// Example:
/// ```
/// var input = 'this is a test';
/// var output = sentenceCaseToCamelCase(input);
/// print(output); // prints: 'thisIsATest'
/// ```
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
