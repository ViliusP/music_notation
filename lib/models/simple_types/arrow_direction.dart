/// The arrow-direction type represents the direction in which an arrow points,
/// using Unicode arrow terminology.
class ArrowDirection {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  ArrowDirection(this._value);

}