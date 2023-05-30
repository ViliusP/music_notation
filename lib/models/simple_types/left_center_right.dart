/// The left-center-right type is used to define horizontal alignment and text
/// justification.
class LeftCenterRight {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  LeftCenterRight(this._value);

}