/// The tip-direction type represents the direction in which the tip of a stick or
/// beater points, using Unicode arrow terminology.
class TipDirection {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  TipDirection(this._value);

}