/// The circular-arrow type represents the direction in which a circular arrow
/// points, using Unicode arrow terminology.
class CircularArrow {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  CircularArrow(this._value);

}