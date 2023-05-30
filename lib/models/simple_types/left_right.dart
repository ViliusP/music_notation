/// The left-right type is used to indicate whether one element appears to the left
/// or the right of another element.
class LeftRight {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  LeftRight(this._value);

}