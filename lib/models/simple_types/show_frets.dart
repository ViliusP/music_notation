/// The show-frets type indicates whether to show tablature frets as numbers (0, 1,
/// 2) or letters (a, b, c). The default choice is numbers.
class ShowFrets {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  ShowFrets(this._value);

}