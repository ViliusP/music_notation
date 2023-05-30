/// The semi-pitched type represents categories of indefinite pitch for percussion
/// instruments.
class SemiPitched {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  SemiPitched(this._value);

}