class Pair<T1, T2> {
  final T1 a;
  final T2 b;

  Pair(this.a, this.b);
}

String kebabToCamel(String input) {
  List<String> words = input.split('-');
  List<String> capitalizedWords = words.map((word) {
    return word[0].toUpperCase() + word.substring(1);
  }).toList();
  return capitalizedWords.join('');
}

String kebabToSnake(String input) {
  return input.replaceAll('-', '_').toLowerCase();
}
