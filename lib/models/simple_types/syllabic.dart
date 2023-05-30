/// Lyric hyphenation is indicated by the syllabic type. The single, begin, end, and
/// middle values represent single-syllable words, word-beginning syllables,
/// word-ending syllables, and mid-word syllables, respectively.
class Syllabic {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  Syllabic(this._value);

}