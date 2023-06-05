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
